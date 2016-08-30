## post-estimation
options(stringsAsFactors=FALSE)
library(rjags)

postProcess <- function(fname){
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

    ## rough plot
    plotData <- data.frame(y=forJags$y,
                           date=dateSeq[forJags$date+firstDay])
    par(lend=2)

    M <- 250
    s <- sample(size=M,x=1:nrow(xi))
    chain <- sample(size=M,x=1:dim(xi)[3],replace=TRUE)
    ylims <- range(c(as.vector(xi[s,,]),
                     forJags$y))

if (FALSE) {
    gname <- paste(paste(who,collapse=""),".pdf",sep="")
    quartz(file=gname,
           type="pdf",
           bg="white")
    plot(y ~ date,
         data=plotData,
         type="n",
         ylim=ylims,
         xlab="",ylab="",
         axes=FALSE)

    title(paste(who,collapse=" minus "),
          adj=0,line=2.67)
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
diffSummary <- function(a,b){
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

## process jags output
tmp <- list()
for(who in theResponses){
 	who <- unlist(who)
 		cat(sprintf(
 			"n\nPost-processing for candidate %s\n",
 			paste(who, collapse=" minus ")
 		))
    fname <- paste(dataDir,'/',paste(who,collapse=""),".jags.RData",sep="")
 	cat(paste("reading JAGS output and data from file",fname,"\n|"))
 	tmp[[paste(who,collapse=" minus ")]] <- postProcess(fname)
}

## combine response options
out <- combine(tmp)

## process contrasts 
theContrasts <- grep("minus",names(tmp))
n.Contrasts <- length(theContrasts)
if(n.Contrasts>0){
  outContrasts <- list()
  for(j in 1:n.Contrasts){
    thisContrast.name <- names(tmp)[theContrasts[j]]
    nms <- strsplit(thisContrast.name,split=" minus ")[[1]]
    outContrasts[[j]] <- diffSummary(nms[1],nms[2])
  }
  outContrasts <- do.call("rbind",outContrasts)
  out <- rbind(out,outContrasts)
}


##########################################

write.csv(out, file=paste(dataDir,"/out.csv",sep=""))

unlink(paste(dataDir,"/*.RData",sep=""))




