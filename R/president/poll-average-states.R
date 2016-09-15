#####################################

## Pollster model

## July 2016

#####################################
#some of top part is changed from git code to be customized for NJ local runs

suppressPackageStartupMessages(library('rjags')) 
library('coda')

options(stringsAsFactors=FALSE)
args <- commandArgs(TRUE)
chart <- args[1]
#chart <- '2016-arizona-president-trump-vs-clinton'

## url to the pollster csv
data <- read.csv(
  file=url(paste0("http://elections.huffingtonpost.com/pollster/api/charts/",chart,".csv")),
  colClasses=c(
    "start_date"="Date",
    "end_date"="Date"
  ),
  check.names=FALSE
)

#############################
## data preperation for jags
#############################

calculate_labels <- function(col_names) {
  last_choice_index <- match('poll_id', col_names) - 1
  return(col_names[1:last_choice_index])
}

calculate_responses <- function(col_names) {
  all_choices <- calculate_labels(col_names)

  stable_choices <- setdiff(all_choices, c("Other","Undecided","Not Voting","Refused","Wouldn't Vote","None"))

  contrast <- list(stable_choices[1:2])

  return(c(all_choices, contrast))
}

## what we will loop over, below
theResponses <- calculate_responses(colnames(data))

## dates
today <- as.Date(Sys.time(),tz="America/New_York")
electionday <- as.Date("2016-11-08")
dateSeq <- seq.Date(from=min(data$start_date),
                    to=electionday,
                    by="day")
data$n_days <- as.numeric(data$end_date)-as.numeric(data$start_date) + 1
if (any(data$n_days < 1)) {
    stop("found mangled start and end dates")
}
NDAYS <- length(dateSeq)

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
thePollsters <- sort(unique(data$pp))	#list of pollsters w/populations

dataDir <- paste0("data/",chart)
dir.create(dataDir, showWarnings=FALSE, recursive=TRUE)

if (1 < 0) {							#changed from git code
  M <- 1E5                              ## number of MCMC iterates, default 100,000
  keep <- if (NDAYS > 600) 1E3 else 5E3 ## how many to keep
} else {
  M <- 1E3
  keep <- 1E3
}

thin <- M/keep            ## thinning interval


##      FOR FORECAST MODEL, COOK RATINGS PRIORS            
state_name <- gsub('2016-|-president.*', '', chart)
all_priors <- read.csv("./priors-pres.csv")
cookPrior1 <- all_priors[all_priors$state == state_name,'prior1']
cookPrior2 <- all_priors[all_priors$state == state_name,'prior2']


## object for jags
makeJagsObject <- function(who,
                           offset=0){
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
      v <- (va + vb - 2*cov)/tmpData$nobs_truncated
    } else {
      y <- y/100
      v <- y*(1-y)/tmpData$nobs_truncated          ## variance
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

makeInits <- function(){
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

makeInitsContrasts <- function(){
  sigma <- runif(n=1,0,.003)
  xi <- rep(0,forJags$NPERIODS)
  

  ## house effect delta inits
  delta <- rnorm(n=forJags$NHOUSES,mean=0,sd=.02)
  out <- list(xi.raw=xi,sigma=sigma,delta.raw=delta)
  return(out)
}

#######################################
## loop over the responses to be modelled
for(who in theResponses){
  who <- unlist(who)

    cat(sprintf("\nRunning for outcome %s\n", paste(who, collapse=" minus ")))

    tmp <- makeJagsObject(who,offset=0)
    forJags <- tmp$forJags
    firstDay <- tmp$firstDay

  initFunc <- makeInits
  if(length(who)==2){
    initFunc <- makeInitsContrasts
  }
    ## call JAGS
    foo <- jags.model(file="singleTarget.bug",
                      data=forJags,
                      n.chains=4,
                      inits=initFunc,
                      quiet=TRUE
                      )
    update(foo,M/5)

    out <- coda.samples(foo,
                        variable.names=c("xi","delta","sigma","dbar"),
                        n.iter=M,thin=thin)

    ## save output
    fname <- paste0(dataDir,'/',gsub(paste(who,collapse=""),pattern=" ",replacement=""),
                    ".jags.RData")
    save("data","dateSeq","firstDay", "forJags","out", file=fname)
}

source("postJags.R")
