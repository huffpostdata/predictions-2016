#####################################

## Pollster model

## July 2016

#####################################

suppressPackageStartupMessages(library('rjags'))
library('coda')

options(stringsAsFactors=FALSE)
args <- commandArgs(TRUE)
chart_slug <- args[1]

if (1 > 0) {     # changed from git code
  M <- 1E5       ## number of MCMC iterates, default 100,000
  keep <- 5E3    ## how many to keep
} else {
  M <- 1E3
  keep <- 1E3
}

thin <- M/keep            ## thinning interval

#############################
## data preperation for jags
#############################

calculate_labels <- function(col_names) {
  last_choice_index <- match('poll_id', col_names) - 1
  return(col_names[1:last_choice_index])
}

calculate_contrast <- function(labels) {
  stable_choices <- setdiff(labels, c("Other","Undecided","Not Voting","Refused","Wouldn't Vote","None"))

  return(stable_choices[1:2])
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

postProcess <- function(fname, dateSeq){
    load(file=fname)

    out2 <- as.array(out)
    xi <- out2[,grep("^xi",dimnames(out2)[[2]]),]
    xibar <- apply(xi,2,
                   function(x){
                     c(mean(x),
                       quantile(x,c(.025,.975)),
                       sd(x))
                   })
    xibar <- t(xibar)
    theDateSeq <- as.character(dateSeq)[seq(from=firstDay,
                                            length=dim(xibar)[1],by=1)]
    dimnames(xi) <- list(NULL,theDateSeq,1:dim(xi)[3])
    dimnames(xibar) <- list(theDateSeq,
                            c("mean","2.5","97.5","sd"))

if (FALSE) {
    ## rough plot
    plotData <- data.frame(y=forJags$y,
                           date=dateSeq[forJags$date+firstDay])
    par(lend=2)

    M <- 250
    s <- sample(size=M,x=1:nrow(xi))
    chain <- sample(size=M,x=1:dim(xi)[3],replace=TRUE)
    ylims <- range(c(as.vector(xi[s,,]),
                     forJags$y))

    gname <- paste0(who,".pdf")
    quartz(file=gname,
           type="pdf",
           bg="white")
    plot(y ~ date,
         data=plotData,
         type="n",
         ylim=ylims,
         xlab="",ylab="",
         axes=FALSE)

    title(who,adj=0,line=2.67)
    axis.Date(side=1,x=as.Date(theDateSeq),
              lwd=0,lwd.tick=.5,cex.axis=.65)
    axis.Date(side=3,x=as.Date(theDateSeq),
              lwd=0,lwd.tick=.5,cex.axis=.65)
    axis(2,lwd=0,lwd.tick=.5,
         las=1,cex.axis=.65)

    for(j in 1:M){
        lines(as.Date(theDateSeq),xi[s[j],,chain[j]],
              lwd=.25,
              col=rgb(0,0,0,.10))
    }
    lines(as.Date(theDateSeq),xibar[,"mean"],
          lwd=4,col=gray(.25))

    points(plotData$date,plotData$y)
    graphics.off()
}

    return(list(xi=xi,xibar=xibar))
}

#######################################
## combine results for response options

combine <- function(tmp, dataDir){
    cat("combining/renormaling output for the following response options\n:")
    print(names(tmp))

    n <- length(tmp)
    nms <- names(tmp)
    xi <- lapply(tmp,function(x)x$xi)
    d <- dim(xi[[1]])
    niter <- d[1]
    nchains <- d[3]

    dateSpans <- lapply(xi,
                        function(x){
                            n <- ncol(x)
                            d <- as.Date(colnames(x))
                            return(d[c(1,n)])
                        })

    dateSpans <- do.call("rbind",dateSpans)
    dateRange <- c(dateSpans[which.min(as.Date(dateSpans[,1],origin="1970-01-01")),1],
                   dateSpans[which.max(as.Date(dateSpans[,2],origin="1970-01-01")),2])

    dateSeq <- seq.Date(from=as.Date(dateRange[1],origin="1970-01-01"),
                        to=as.Date(dateRange[2],origin="1970-01-01"),
                        by="day")

    ## create 4-d master array
    tmpArray <- array(NA,c(niter,length(dateSeq),nchains,n))
    dimnames(tmpArray) <- list(NULL,as.character(dateSeq),1:nchains,nms)
    for(j in 1:n){
        ## populate master array with output for each response option
        matchingDays <- match(colnames(xi[[j]]),as.character(dateSeq))
        tmpArray[,matchingDays,,j] <- xi[[j]]
    }

    ## renormalize (and check)
    tmpArray.renorm <- apply(tmpArray,c(1,2,3),
                             function(x)x/sum(x,na.rm=TRUE)*100)
    rm(tmpArray)   ## give back some memory
    tmpArray <- aperm(tmpArray.renorm,perm=c(2,3,4,1))
    save("tmpArray",file=paste(dataDir,"/tmpArray.RData",sep=""))
    ##all.sum <- apply(tmpArray,c(1,2,3),sum,na.rm=TRUE)

    ## average over iterations and chains
    xibar <- apply(tmpArray,c(2,4),mean,na.rm=TRUE)
    xibar[is.nan(xibar)] <- NA

    ## quantiles
    xiq <- apply(tmpArray,c(2,4),
                 quantile,
                 probs=c(.025,.975),
                 na.rm=TRUE)
    xiq <- aperm(xiq,c(2,3,1))
    xiq.out <- xiq[,1,]
    for(j in 2:n){
        xiq.out <- rbind(xiq.out,xiq[,j,])
    }

    nrecs <- dim(xiq.out)[1]

    ## stack by candidate
    xibar.out <- data.frame(who=rep(nms,each=length(dateSeq)),
                            date=rep(as.character(dateSeq),n),
                            xibar=as.vector(xibar),
                            lo=xiq.out[,1],
                            up=xiq.out[,2],
                            prob=rep(NA,nrecs))

    return(xibar.out)

}


#################################################
## difference function
diffSummary <- function(dataDir, a,b){
  load(file=paste(dataDir,"/tmpArray.RData",sep=""))

  theOnes <- match(c(a,b),dimnames(tmpArray)[[4]])
  d <- list(tmpArray[,,,theOnes[1]],
            tmpArray[,,,theOnes[2]])
  theRows <- sort(unique(unlist(lapply(d,function(x)dimnames(x)[[2]]))))
  nDays <- length(theRows)
  nIter <- dim(d[[1]])[1]
  nChains <- dim(d[[1]])[3]
  z1 <- array(NA,c(nIter,nDays,nChains))
  z2 <- array(NA,c(nIter,nDays,nChains))
  z1[,match(dimnames(d[[1]])[[2]],theRows),] <- d[[1]]
  z2[,match(dimnames(d[[2]])[[2]],theRows),] <- d[[2]]
  z <- z1 - z2
  zbar <- apply(z,2,
                  function(x){
                      c(mean(x,na.rm=TRUE),
                        quantile(x,c(.025,.975),na.rm=TRUE),
                        mean(x>0,na.rm=TRUE))
                  })
  zbar <- t(zbar)
  nrecs <- dim(zbar)[1]
  return(data.frame(who=rep(paste(a,"minus",b),nrecs),
                    date=theRows,
                    xibar=zbar[,1],
                    lo=zbar[,2],
                    up=zbar[,3],
                    prob=zbar[,4]*100))
}

#########################################

calculate_diff_curve <- function(chart_slug) {
  ## url to the pollster csv
  data <- read.csv(
    file=url(paste0("http://elections.huffingtonpost.com/pollster/api/charts/",chart_slug,".csv")),
    colClasses=c("start_date"="Date", "end_date"="Date"),
    check.names=FALSE
  )

  ## what we will loop over, below
  theResponses <- calculate_labels(colnames(data))

  ## dates
  today <- as.Date(Sys.time(),tz="America/New_York")
  dateSeq <- seq.Date(from=min(data$start_date), to=today, by="day")
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
  thePollsters <- sort(unique(data$pp))    #list of pollsters w/populations

  dataDir <- paste0("data/",chart_slug)
  dir.create(dataDir, showWarnings=FALSE, recursive=TRUE)


  ##      FOR FORECAST MODEL, COOK RATINGS PRIORS
  state_name <- gsub('2016-|-senate.*', '', chart_slug)
  all_priors <- read.csv("./priors-sen.csv")
  cookPrior1 <- all_priors[all_priors$state == state_name,'prior1']
  cookPrior2 <- all_priors[all_priors$state == state_name,'prior2']


  #######################################
  ## loop over the responses to be modelled
  for(who in theResponses){
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

    out <- coda.samples(jags_model, variable.names=c("xi"), n.iter=M, thin=thin)

    ## save output
    fname <- paste0(dataDir,'/',gsub(who,pattern=" ",replacement=""), ".jags.RData")
    save("data","dateSeq","firstDay", "forJags","out", file=fname)
  }


  ## process jags output
  tmp <- list()
  for(who in theResponses){
    cat(sprintf("Post-processing for candidate %s\n", who))
    fname <- paste(dataDir,'/',who,".jags.RData",sep="")
    cat(paste("reading JAGS output and data from file",fname,"\n"))
    tmp[[who]] <- postProcess(fname, dateSeq)
  }

  ## combine response options
  out <- combine(tmp, dataDir)

  ## process contrasts
  contrast <- calculate_contrast(theResponses)
  outContrast <- diffSummary(dataDir, contrast[1], contrast[2])
  out <- rbind(out, outContrast)

  ##########################################

  write.csv(out, file=paste(dataDir,"/out.csv",sep=""))

  unlink(paste(dataDir,"/*.RData",sep=""))
}

calculate_diff_curve(chart_slug)
