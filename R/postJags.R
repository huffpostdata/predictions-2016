## post-estimation
options(stringsAsFactors=FALSE)
library(rjags)

debug_plot <- function(forJags, firstDay, xi) {
  ## rough plot
  plotData <- data.frame(y=forJags$y, date=dateSeq[forJags$date+firstDay])
  par(lend=2)

  M <- 250
  s <- sample(size=M,x=1:nrow(xi))
  chain <- sample(size=M,x=1:dim(xi)[3],replace=TRUE)
  ylims <- range(c(as.vector(xi[s,,]), forJags$y))

  gname <- paste(paste(who,collapse=""),".pdf",sep="")
  quartz(file=gname, type="pdf", bg="white")
  plot(y ~ date,
       data=plotData,
       type="n",
       ylim=ylims,
       xlab="",ylab="",
       axes=FALSE)

  title(paste(who,collapse=" minus "), adj=0, line=2.67)
  axis.Date(side=1,x=as.Date(theDateSeq), lwd=0, lwd.tick=.5, cex.axis=.65)
  axis.Date(side=3,x=as.Date(theDateSeq), lwd=0, lwd.tick=.5, cex.axis=.65)
  axis(2, lwd=0, lwd.tick=.5, las=1, cex.axis=.65)

  for(j in 1:M){
      lines(as.Date(theDateSeq),xi[s[j],,chain[j]], lwd=.25, col=rgb(0,0,0,.10))
  }
  lines(as.Date(theDateSeq),xibar[,"mean"], lwd=4,col=gray(.25))

  points(plotData$date,plotData$y)
  graphics.off()
}

postProcess <- function(out, thePollsters, dateSeq, firstDay){
    out2 <- as.array(out)
    xi <- out2[,grep("^xi",dimnames(out2)[[2]]),]
    xibar <- apply(xi,2,
                   function(x){
                     c(mean(x),
                       quantile(x,c(.025,.975)),
                       sd(x))
                   })
    xibar <- t(xibar)
    theDateSeq <- as.character(dateSeq)[seq(from=firstDay, length=dim(xibar)[1],by=1)]
    dimnames(xi) <- list(NULL,theDateSeq,1:dim(xi)[3])
    dimnames(xibar) <- list(theDateSeq, c("mean","2.5","97.5","sd"))

    ## delta processing to come here too
    delta <- out2[,grep("^delta",dimnames(out2)[[2]]),]
    dimnames(delta) <- list(NULL,thePollsters,NULL)

    deltabar <- apply(delta,2,
                      function(x){
                        n <- length(x)
                        ok <- (1:n)>(n/2)
                        x <- x[ok]
                        c(mean(x),
                          quantile(x,c(.025,.975)),
                          sd(x),
                          mean(x>0))
                      })
    deltabar <- t(deltabar)
    colnames(deltabar) <- c("Estimate","2.5%","97.5%","StdDev","Pr[delta>0]")
    indx <- order(deltabar[,"Estimate"])
    deltabar <- deltabar[indx,]

    ## dbar processing
    dbar <- out2[,grep("^dbar",dimnames(out2)[[2]]),]
    dbarbar <- apply(dbar,2,
                      function(x){
                        n <- length(x)
                        ok <- (1:n)>(n/2)
                        x <- x[ok]
                        c(mean(x),
                          quantile(x,c(.025,.975)),
                          sd(x),
                          mean(x>0))
                      })
    dbarbar <- t(dbarbar)
    colnames(deltabar) <- c("Estimate","2.5%","97.5%","StdDev","Pr[dbar>0]")

    return(list(xi=xi,xibar=xibar,delta=deltabar,dbar=dbarbar))
}

#######################################
## combine results for response options

combine <- function(tmp){
    nms <- names(tmp)
    noInclude <- grep("minus",nms)
    tmp[noInclude] <- NULL

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
    tmpArray.renorm <- apply(tmpArray, c(1,2,3), function(x)x/sum(x,na.rm=TRUE))
    rm(tmpArray)   ## give back some memory
    tmpArray <- aperm(tmpArray.renorm,perm=c(2,3,4,1))
    #save("tmpArray",file='tmp/tmpArray.RData')
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

    return(list(xibar=xibar.out, tmpArray=tmpArray))
}

#################################################
## difference function, produces non-jittered probabilities with "2" designator
diffSummary2 <- function(tmpArray,a,b){
  #load(file=paste(dataDir,"/tmpArray.RData",sep=""))

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
  zbar2 <- apply(z,2,
                  function(x){
                      c(mean(x,na.rm=TRUE),
                        quantile(x,c(.025,.975),na.rm=TRUE),
                        mean(x>0,na.rm=TRUE))
                  })
  zbar2 <- t(zbar2)
  nrecs <- dim(zbar2)[1]
  return(data.frame(who2=rep(paste(a,"minus",b),nrecs),
                    date16=theRows,
                    xibar2=zbar2[,1],
                    lo2=zbar2[,2],
                    up2=zbar2[,3],
                    prob2=zbar2[,4]))
}



##Diff summary--jittering the margins to jitter the probabilities


diffSummary <- function(tmpArray, a,b){
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
  lastrow <- as.numeric(tail(zbar[,4], 1))
  jitter <- if (lastrow > .5) function(x){x - (rnorm(length(x),2,1.5))} else function(x){x + (rnorm(length(x),4,3))}                  
  z <- jitter(z)
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
                    prob=zbar[,4]))
}



combineHouse <- function(tmp, thePollsters){
    n <- length(tmp)
    nms <- names(tmp)

    out <- data.frame(who=rep(nms,each=length(thePollsters)), pollster=rep(thePollsters,n))

    for(i in 1:nrow(out)) {
      out[i,"est"] <- tmp[[out[i,"who"]]][["delta"]][out[i,"pollster"], "Estimate"]
      out[i,"lo"] <- tmp[[out[i,"who"]]][["delta"]][out[i,"pollster"], "2.5%"]
      out[i,"hi"] <- tmp[[out[i,"who"]]][["delta"]][out[i,"pollster"], "97.5%"]
      out[i,"dev"] <- tmp[[out[i,"who"]]][["delta"]][out[i,"pollster"], "StdDev"]
    }

    return(out)
}

###################Line charts #########################

#out <- read.csv(paste(dataDir,"/out.csv",sep=""))
#subset <- c("who", "date", "xibar") #select only variables needed
#out.sm <- out[subset] #create smaller data frame of only 3 vars


##Split by candidate 
#outlong <- split(out.sm, out.sm$who)

## Now have object "outlong" which contains dataframes outlong$[whovalue]
## Call outlong$candname$xibar for candidate values by date
## Plot one line, then add others.

##Plot of everything
#maxy <- 65
#miny <- 0 
#plot_colors <- c("red", "blue", "green")
#png(filename=paste(dataDir,"/RDUchart.png",sep=""), height=750, width=750, bg="white") #later make it dataDir,"/RDUchart.png",sep=""
#plot(outlong$McCain$xibar, type="l", ylim=c(miny, maxy), col=plot_colors[1], lwd=2)
#lines(outlong$Kirkpatrick$xibar, type="l",col=plot_colors[2], lwd=2)
#lines(outlong$Undecided$xibar, type="l",col=plot_colors[3], lwd=2)
#dev.off()

##close look at just R & D plot
#maxy <- 70
#miny <- 30
#plot_colors <- c("red", "blue")
#png(filename=paste(dataDir,"/RDchart.png",sep=""), height=500, width=750, bg="white") ##later make it dataDir,"/RDchart.png",sep=""
#plot(outlong$McCain$xibar, type="l", ylim=c(miny, maxy),  col=plot_colors[1])
#lines(outlong$Kirkpatrick$xibar, type="l",col=plot_colors[2])
#dev.off()



