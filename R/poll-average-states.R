#####################################

## Pollster model

## July 2016

#####################################

suppressPackageStartupMessages(library('rjags'))
library('coda')

options(stringsAsFactors=FALSE)
args <- commandArgs(TRUE)
chart_slug <- args[1]
cook_rating <- args[2]
dem_label <- args[3]
gop_label <- args[4]

if (args[5] == 'fast') {
  M <- 1E3
  Keep <- 1E3
} else {
  M <- 1E5       ## number of MCMC iterates, default 100,000
  Keep <- 5E3    ## how many to keep
}

ElectionDay <- as.Date('2016-11-08')

CookPriors <- data.frame(
  rating=c('D-Solid', 'D-Likely', 'D-Lean', 'Toss Up', 'R-Lean', 'R-Likely', 'R-Solid'),
  prior1=c(0.4823, 0.4881, 0.4865, 0.4792, 0.4746, 0.4879, 0.4783),
  prior2=c(0.1584, 0.1205, 0.0706, 0.0619, 0.0824, 0.0824, 0.1807),
  dem_win_prob=c(1.0, 0.90, 0.80, 0.5, 0.20, 0.10, 0.01)
)

#############################
## data preperation for jags
#############################

calculate_labels <- function(col_names) {
  last_choice_index <- match('poll_id', col_names) - 1
  return(col_names[1:last_choice_index])
}

## object for jags
makeJagsObject <- function(data, thePollsters, dateSeq, who, offset=0){
    tmpData <- data
    theColumn <- match(who,names(tmpData))
    y.tmp <- tmpData[,theColumn]                     ## the response
    y.tmp <- matrix(y.tmp,ncol=length(theColumn))    ## be a matrix
    ok <- apply(y.tmp,1,function(x)!(any(is.na(x)))) ## clobber NA
    tmpData <- tmpData[ok,]                          ## subset to obs with good data
    y <- as.matrix(tmpData[,theColumn])
    y <- y/100
    v <- y*(1-y)/tmpData$nobs_truncated              ## variance
    prec <- 1/v
    ## pollster/population combinations


    j <- match(tmpData$pp,thePollsters)

    ## loop over polls
    NPOLLS <- dim(tmpData)[1]
    counter <- 1
    pollList <- list()
    for(i in 1:NPOLLS){
        pollLength <- tmpData$n_days[i]
        ##cat(paste("pollLength:",pollLength,"\n"))
        dateSeq.limits <- match(c(tmpData$start_date[i],tmpData$end_date[i]),dateSeq)
        dateSeq.local <- dateSeq.limits[1]:dateSeq.limits[2]
        ##cat("dateSeq.local:\n")
        ##print(dateSeq.local)
        pollList[[i]] <- data.frame(y=rep(y[i],pollLength),
                                    j=rep(j[i],pollLength),
                                    prec=rep(prec[i]/pollLength,pollLength),
                                    date=dateSeq.local)
    }
    pollList <- do.call("rbind",pollList)

    forJags <- as.list(pollList)
    forJags$NOBS <- dim(pollList)[1]
    forJags$NHOUSES <- length(thePollsters)
    forJags$NPERIODS <- length(dateSeq)

    ## renormalize dates relative to what we have for this candidate
    firstDay <- match(min(tmpData$start_date),dateSeq)
    forJags$date <- forJags$date - firstDay + 1
    forJags$NPERIODS <- forJags$NPERIODS - firstDay + 1

    ## prior for house effects
    forJags$d0 <- rep(0,forJags$NHOUSES)
    delta.prior.sd <- .025
    delta.prior.prec <- (1/delta.prior.sd)^2
    forJags$D0 <- diag(rep(delta.prior.prec,forJags$NHOUSES))

    ## offset, user-defined?
    forJags$offset <- offset

    return(list(forJags=forJags,firstDay=firstDay))
}

makeInits <- function(forJags, cookPrior1, cookPrior2) {
    sigma <- runif(n=1,0,.003)
    xi <- rep(NA,forJags$NPERIODS)
    xi[1] <- rnorm(n=1, cookPrior1,cookPrior2)
    for(i in 2:forJags$NPERIODS){
        xi[i] <- rnorm(n=1,xi[i-1],sd=sigma)
    }
    xi.bad <- xi < .01
    xi[xi.bad] <- .01
    xi.bad <- xi > .99
    xi[xi.bad] <- .99


    ## house effect delta inits
    delta <- rnorm(n=forJags$NHOUSES,mean=0,sd=.02)
    out <- list(xi.raw=xi,sigma=sigma,delta.raw=delta)
    return(out)
}

# Turns the mcmc.list from a JAGS model into a proper Array of xi values.
#
# The first dimension is the "iteration" number. The second is the date, as a
# character.
#
# "iteration" here is a loose term. Remember that the input is a mcmc.list
# object: it has C chains, and each chain has I iterations. An output
# "iteration" i means "chain floor(i/C), iteration i%%C". (We don't care which
# chain a given value comes from.
mcmc_list_to_xi_array <- function(mcmc_list, firstDay, dateSeq){
    iter_i_chain <- as.array(mcmc_list)

    # Transpose so chain and iter are together
    ret <- aperm(iter_i_chain, c(1, 3, 2))

    # Cast as a 2D array instead of a 3D array
    dim(ret) <- c(dim(ret)[1] * dim(ret)[2], dim(ret)[3])

    # Set the dims: we're going by date
    theDateSeq <- as.character(dateSeq)[seq(from=firstDay, length=dim(ret)[2], by=1)]
    dimnames(ret) <- list(iteration=NULL, date=theDateSeq)

    #save('ret', file='debug.RData')

    return(ret)
}

# Builds a 3D array of xi results, normalized.
#
# Array format:
#
#     arr[,,'2016-08-04']: results for Aug. 4
#     arr['McCain',,]: results for McCain
#     arr[,1,]: results for one "iteration"
#
# In other words, arr[,1,'2016-08-04'] pulls one xi value from each entry in
# candidate_xis and normalizes so they all add up to 1.0.
build_normalized_array <- function(candidate_xis) {
    cat('combining/renormaling output for: ')
    print(names(candidate_xis))

    n_iterations <- dim(candidate_xis[[1]])[1]

    dateSpans <- lapply(candidate_xis, function(xi) colnames(xi)[c(1,ncol(xi))])
    dateSpans <- do.call("rbind",dateSpans)
    dateRange <- c(as.Date(min(dateSpans[,1])), as.Date(max(dateSpans[,2])))
    dateSeq <- seq.Date(from=dateRange[1], to=dateRange[2], by="day")

    # Create 3D master array: date -> chain/iter -> candidate -> fraction
    #
    # (We fold iterations from all chains into one big chain+iter vector.)
    arr <- array(NA, c(length(candidate_xis), n_iterations, length(dateSeq)))
    dimnames(arr) <- list(who=names(candidate_xis), iteration=NULL, date=as.character(dateSeq))
    for (who in names(candidate_xis)) {
      xi <- candidate_xis[[who]]
      matching_days <- match(colnames(xi), as.character(dateSeq))
      arr[who,,matching_days] <- xi
    }

    normalized <- apply(arr, c('iteration', 'date'), function(x) x/sum(x, na.rm=TRUE))

    return(normalized)
}

# Builds a data.frame with average results by date for the given choice.
#
# Example usage:
#
#     frame <- build_choice_frame(arr, 'Undecided', list(undecided_xibar='mean'))
#
# Parameters:
#
# normalized_array: see build_normalized_array()
# choice: one of the choices in the normalized_array
# columns_list: desired column names and what they mean. List indexes are
#               column names in the output frame. Values are their meanings.
#               'mean' is the only valid meaning, for now.
build_choice_frame <- function(normalized_array, choice, columns_list) {
  xi <- normalized_array[choice,,]

  dates <- as.Date(dimnames(xi)[['date']])

  ret <- data.frame(date=dates)
  for (index in names(columns_list)) {
    name = columns_list[[index]]

    if (name == 'mean') {
      values <- apply(xi, 2, mean)
    } else {
      stop('name must be "mean"')
    }

    ret[[index]] = values
  }

  return(ret)
}

#################################################
## difference function
diffSummary <- function(normalized_array, dem_who, gop_who) {
  diff_array <- normalized_array[dem_who,,] - normalized_array[gop_who,,]

  averages <- apply(diff_array, 'date', function(x) c(
    mean(x, na.rm=TRUE),
    quantile(x, c(0.025, 0.975), na.rm=TRUE),
    mean(x > 0, na.rm=TRUE)
  ))

  dimnames(averages)[[1]] <- c('mean', '0.025', '0.975', 'prob')

  return(data.frame(
    date=as.Date(dimnames(averages)$date),
    diff_xibar=averages['mean',],
    diff_low=averages['0.025',],
    diff_high=averages['0.975',],
    dem_win_prob=averages['prob',]
  ))
}

#########################################

calculate_diff_curve <- function(chart_slug, cook_rating, dem_label, gop_label) {
  ## url to the pollster csv
  data <- read.csv(
    file=url(paste0("http://elections.huffingtonpost.com/pollster/api/charts/",chart_slug,".csv")),
    colClasses=c("start_date"="Date", "end_date"="Date"),
    check.names=FALSE
  )

  ## what we will loop over, below
  theResponses <- calculate_labels(colnames(data))

  ## dates
  data$n_days <- as.numeric(data$end_date)-as.numeric(data$start_date) + 1
  if (any(data$n_days < 1)) {
    stop("found mangled start and end dates")
  }

  dateSeq <- seq.Date(from=min(data$start_date), to=ElectionDay, by="day")

  ## missing sample sizes?
  nobs <- data$sample_size
  nobs.bad <- is.na(nobs) | nobs <= 0
  if(any(nobs.bad)){
    cat(paste("mean imputing for", sum(nobs.bad), "bad/missing sample sizes\n"))
    nobs.bar <- tapply(nobs,data$pollster,mean,na.rm=TRUE)
    nobs.bar[is.na(nobs.bar)] <- mean(nobs,na.rm=TRUE)

    nobs[nobs.bad] <- nobs.bar[match(data$pollster[nobs.bad],names(nobs.bar))]
  }
  data$nobs <- nobs
  data$nobs_truncated <- ifelse(data$nobs > 3000, 3000, data$nobs)

  rm(nobs)

  # [adamhooper6] Value 0 makes for "Node inconsistent with parent" error. Use
  # almost-zero.
  for (label in calculate_labels(colnames(data))) {
    data[[label]] <- ifelse(data[[label]] == 0, 1E-6, data[[label]])
  }

  ## pollsters and pops
  data$pp <- paste0(data$pollster, ":", data$sample_subpopulation)
  pollsters <- sort(unique(data$pollster)) #list of pollsters
  thePollsters <- sort(unique(data$pp))    #list of pollsters w/populations

  dataDir <- paste0("data/",chart_slug)
  dir.create(dataDir, showWarnings=FALSE, recursive=TRUE)

  ## FOR FORECAST MODEL, COOK RATINGS PRIORS
  cook_index <- match(cook_rating, CookPriors$rating)
  cookPrior1 <- CookPriors[cook_index,'prior1']
  cookPrior2 <- CookPriors[cook_index,'prior2']

  candidate_xis <- list()

  #######################################
  ## loop over the responses to be modelled
  for (who in calculate_labels(colnames(data))) {
    cat(sprintf("Running for outcome %s\n", who))

    tmp <- makeJagsObject(data, thePollsters, dateSeq, who, offset=0)
    forJags <- tmp$forJags
    firstDay <- tmp$firstDay

    initFunc <- function() { return(makeInits(forJags, cookPrior1, cookPrior2)) }
    ## call JAGS
    jags_model <- jags.model(
      file="singleTarget.bug",
      data=forJags,
      n.chains=4,
      inits=initFunc,
      quiet=TRUE
    )
    update(jags_model, M/5)

    out <- coda.samples(jags_model, variable.names=c("xi"), n.iter=M, thin=M/Keep)
    xi_array <- mcmc_list_to_xi_array(out, firstDay, dateSeq)

    candidate_xis[[who]] <- xi_array

    #save("data","dateSeq","firstDay", "forJags","out","xi_array" file='out.RData')
  }

  tmpArray <- build_normalized_array(candidate_xis)

  undecided_frame <- build_choice_frame(tmpArray, 'Undecided', list(undecided_xibar='mean'))
  diff_frame <- diffSummary(tmpArray, dem_label, gop_label)
  out <- data.frame(date=dateSeq)
  out <- merge(out, diff_frame, by=c('date'))
  out <- merge(out, undecided_frame, by=c('date'))

  ##########################################

  #write.csv(out, file=paste(dataDir,"/out.csv",sep=""))

  return(out)
}

frame <- calculate_diff_curve(chart_slug, cook_rating, dem_label, gop_label)
options(scipen=999)
options(digits=20)
write.table(frame, 'out.tsv', na='', quote=FALSE, sep='\t', row.names=FALSE)
