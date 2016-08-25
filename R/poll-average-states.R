suppressPackageStartupMessages(library('rjags')) 
library('coda')
options(stringsAsFactors=FALSE)

source("postJags.R")

election_date <- as.Date('2016-11-08')
M <- 1E5    ## number of MCMC iterates, default 100,000
keep <- 5E3 ## how many to keep
#M <- 1E3
#keep <- 1E3
cook_priors <- data.frame(
  rating=c('D-Solid', 'D-Likely', 'D-Lean', 'Toss Up', 'R-Lean', 'R-Likely', 'R-Solid'),
  prior1=c(0.4823, 0.4881, NA, 0.4792, 0.4746, 0.4879, 0.4783),
  prior2=c(0.1584, 0.1205, NA, 0.0619, 0.0824, 0.0824, 0.1807),
  dem_win_prob=c(1.0, 0.90, 0.80, 0.5, 0.20, 0.10, 0.99)
)

get_pollster_csv <- function(slug) {
  if (slug == '') {
    return(data.frame())
  }

  return(read.csv(
    file=url(paste0('http://elections.huffingtonpost.com/pollster/api/charts/', slug, '.csv')),
    colClasses=c(start_date='Date', end_date='Date'),
    check.names=FALSE
  ))
}

stub_dem_gop_curves <- function(state_code, cook_rating, last_date) {
  dates <- seq.Date(from=last_date, to=election_date, by='day')
  n <- length(dates)
  na <- rep(NA, n)
  dem_win_prob <- cook_priors[cook_priors$rating==cook_rating,'dem_win_prob']
  return(list(
    curves=data.frame(
      state=rep(state_code, n),
      date=dates,
      dem_xibar=na,
      dem_low=na,
      dem_high=na,
      gop_xibar=na,
      gop_low=na,
      gop_high=na,
      dem_win_prob=rep(dem_win_prob, n)
    ),
    house_effects=data.frame(pollster=c(), est=c(), lo=c(), hi=c(), dev=c())
  ))
}

calculate_dem_gop_curves <- function(state_code, cook_rating, pollster_slug, dem_label, gop_label, last_date) {
  pollster_csv <- get_pollster_csv(pollster_slug)

  # Filter out "future" polls -- so we can re-run at a later date without too
  # much error.
  pollster_csv <- pollster_csv[pollster_csv$end_date <= last_date,]

  # Not enough polls? Don't model -- just use the Cook rating.
  if (nrow(pollster_csv) < 5) {
    return(stub_dem_gop_curves(state_code, cook_rating, last_date))
  }

  calculate_labels <- function(col_names) {
    last_choice_index <- match('poll_id', col_names) - 1
    return(col_names[1:last_choice_index])
  }

  calculate_responses <- function(col_names) {
    all_choices <- calculate_labels(col_names)
    return(c(all_choices, list(c(dem_label, gop_label))))
  }

  truncate_sample_size <- function(v) {
    return(pmin(v, 3000))
  }

  impute_sample_size <- function(frame) {
    na_sample_size <- is.na(frame$sample_size)

    if(!any(na_sample_size)) {
      return(frame$sample_size)
    }
    cat(paste("mean imputing for", sum(na_sample_size), "bad/missing sample sizes\n"))

    # Array of pollster -> mean for all pollsters with sample sizes
    pollster_mean <- tapply(frame$sample_size, frame$pollster, mean, na.rm=TRUE)
    pollster_mean_index <- match(frame$pollster, names(pollster_mean))

    # scalar mean across all pollsters -- a fallback in case a pollster has no sample sizes ever
    global_mean <- mean(frame$sample_size, na.rm=TRUE)

    return(ifelse(na_sample_size,
      ifelse(is.na(pollster_mean_index), global_mean, pollster_mean[pollster_mean_index]),
      frame$sample_size
    ))
  }

  theResponses <- calculate_responses(colnames(pollster_csv))
  dateSeq <- seq.Date(from=min(pollster_csv$start_date), to=election_date, by="day")

  pollster_csv$n_days <- as.numeric(pollster_csv$end_date) - as.numeric(pollster_csv$start_date) + 1
  if (any(pollster_csv$n_days < 1)) {
    stop('found mangled start and end dates')
  }

  pollster_csv$sample_size_imputed_truncated <- truncate_sample_size(impute_sample_size(pollster_csv))

  # [adamhooper6] Value 0 makes for "Node inconsistent with parent" error. Use
  # almost-zero. 
  for (label in calculate_labels(colnames(pollster_csv))) {
    pollster_csv[[label]] <- ifelse(pollster_csv[[label]] == 0, 1E-6, pollster_csv[[label]])
  }

  ## pollsters and pops
  pollster_csv$pp <- paste0(pollster_csv$pollster, ":", pollster_csv$sample_subpopulation)
  pollsters <- sort(unique(pollster_csv$pollster)) #list of pollsters
  thePollsters <- sort(unique(pollster_csv$pp))	#list of pollsters w/populations

  cookPrior1 <- cook_priors[cook_priors$rating==cook_rating, 'prior1']
  cookPrior2 <- cook_priors[cook_priors$rating==cook_rating, 'prior2']

  agg <- list()

  for(who in theResponses){
    who <- unlist(who)

    cat(sprintf("Running for outcome %s\n", paste(who, collapse=" minus ")))

    tmp <- makeJagsObject(pollster_csv, thePollsters, dateSeq, who,offset=0)
    forJags <- tmp$forJags
    firstDay <- tmp$firstDay

    initFunc <- function() { makeInits(forJags, cookPrior1, cookPrior2) }
    if(length(who)==2){
      initFunc <- function() { makeInitsContrasts(forJags, cookPrior1, cookPrior2) }
    }

    ## call JAGS
    foo <- jags.model(
      file="singleTarget.bug",
      data=forJags,
      n.chains=4,
      inits=initFunc,
      quiet=TRUE
    )
    update(foo,M/5)

    out <- coda.samples(
      foo,
      variable.names=c("xi","delta","sigma","dbar"),
      n.iter=M,
      thin=M/keep
    )

    ## save output -- for debugging
    #fname <- paste0('tmp/',gsub(paste(who,collapse=""),pattern=" ",replacement=""), ".jags.RData")
    #data <- pollster_csv
    #save("data","dateSeq","firstDay", "forJags","out", file=fname)

    # Set xi, xibar, delta, dbar
    agg[[paste(who, collapse=' minus ')]] <- postProcess(out, thePollsters, dateSeq, firstDay)
  }

  combined <- combine(agg)
  combined_out <- combined$xibar
  tmpArray <- combined$tmpArray

  ## process contrasts with jitter
  combined_out <- rbind(combined_out, diffSummary(tmpArray, dem_label, gop_label))
  combined_out <- cbind(combined_out, diffSummary2(tmpArray, dem_label, gop_label))

  nice_frame_dates <- seq.Date(from=as.Date('2016-01-01'), to=election_date, by='day')
  n_dates <- length(nice_frame_dates)
  nice_frame <- data.frame(
    state=rep(state_code, n_dates),
    date=nice_frame_dates
  )

  dem_frame_t <- combined_out[combined_out$who==dem_label, c('date', 'xibar', 'lo', 'up')]
  dem_frame <- data.frame(
    date=as.Date(dem_frame_t$date),
    dem_xibar=dem_frame_t$xibar,
    dem_low=dem_frame_t$lo,
    dem_high=dem_frame_t$up
  )
  nice_frame <- merge(nice_frame, dem_frame, by=c('date'))

  gop_frame_t <- combined_out[combined_out$who==gop_label, c('date', 'xibar', 'lo', 'up')]
  gop_frame <- data.frame(
    date=as.Date(gop_frame_t$date),
    gop_xibar=gop_frame_t$xibar,
    gop_low=gop_frame_t$lo,
    gop_high=gop_frame_t$up
  )
  nice_frame <- merge(nice_frame, gop_frame, by=c('date'))

  undecided_frame_t <- combined_out[combined_out$who=='Undecided', c('date', 'xibar')]
  undecided_frame <- data.frame(
    date=as.Date(undecided_frame_t$date),
    undecided_xibar=undecided_frame_t$xibar
  )
  nice_frame <- merge(nice_frame, undecided_frame, by=c('date'))

  diff_label <- paste0(dem_label, ' minus ', gop_label)
  prob_frame_t <- combined_out[combined_out$who==diff_label, c('date', 'prob')]
  prob_frame <- data.frame(date=as.Date(prob_frame_t$date), dem_win_prob=prob_frame_t$prob)
  nice_frame <- merge(nice_frame, prob_frame, by=c('date'))

  house_effects <- combineHouse(agg, thePollsters)

  return(list(curves=nice_frame, house_effects=house_effects))
}

## object for jags
makeJagsObject <- function(data, thePollsters, dateSeq, who, offset=0) {
    tmpData <- data
    theColumn <- match(who,names(tmpData))
    y.tmp <- tmpData[,theColumn]                     ## the response
    y.tmp <- matrix(y.tmp,ncol=length(theColumn))    ## be a matrix
    ok <- apply(y.tmp,1,function(x)!(any(is.na(x)))) ## clobber NA
    tmpData <- tmpData[ok,]                          ## subset to obs with good data
    y <- as.matrix(tmpData[,theColumn])
    if(dim(y)[2]==2){
      ## we have a contrast!
      a <- y[,1]/100
      b <- y[,2]/100
      y <- a - b
      va <- a*(1-a)
      vb <- b*(1-b)
      cov <- -a*b
      v <- (va + vb - 2*cov)/tmpData$sample_size_imputed_truncated
    } else {
      y <- y/100
      v <- y*(1-y)/tmpData$sample_size_imputed_truncated          ## variance
    }
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

makeInits <- function(forJags, cookPrior1, cookPrior2){
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

makeInitsContrasts <- function(forJags, cookPrior1, cookPrior2){
  sigma <- runif(n=1,0,.003)
  xi <- rep(0,forJags$NPERIODS)
  xi[1] <- rnorm(n=1,cookPrior1,cookPrior2)
  for(i in 2:forJags$NPERIODS) {
    xi[i] <- rnorm(n=1,xi[i-1],sd=sigma)
  }

  ## house effect delta inits
  delta <- rnorm(n=forJags$NHOUSES,mean=0,sd=.02)
  out <- list(xi.raw=xi,sigma=sigma,delta.raw=delta)
  return(out)
}
