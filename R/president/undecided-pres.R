dir.create('post/und/', showWarnings=FALSE, recursive=TRUE)
##nopolls states: AL, AK, AR, CT, DE, HI, ID, IN, KY, LA, ME, MA, MN, MS, MT, NE, NM, ND, OK, RI, SD, TN, VT, WA, DC, VA, WY

#chart <- '2016-alabama-president-trump-vs-clinton'
#outAL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAL <- outAL[min(grep("Undecided",outAL$who)):nrow(outAL),]
#outAL$date2 <- as.Date(outAL$date, format="%Y-%m-%d")
#outAL <- subset(outAL, date2==today)
#outAL$state<-"AL"
#write.csv(outAL, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-alaska-president-trump-vs-clinton'
#outAK <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAK <- outAK[min(grep("Undecided",outAK$who)):nrow(outAK),]
#outAK$date2 <- as.Date(outAK$date, format="%Y-%m-%d")
#outAK <- subset(outAK, date2==today)
#outAK$state<-"AK"
#write.csv(outAK, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-arizona-president-trump-vs-clinton'
outAZ <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outAZ <- outAZ[min(grep("Undecided",outAZ$who)):nrow(outAZ),]
outAZ$date2 <- as.Date(outAZ$date, format="%Y-%m-%d")
outAZ <- subset(outAZ, date2==today)
outAZ$state<-"AZ"
write.csv(outAZ, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-arkansas-president-trump-vs-clinton'
#outAR <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAR <- outAR[min(grep("Undecided",outAR$who)):nrow(outAR),]
#outAR$date2 <- as.Date(outAR$date, format="%Y-%m-%d")
#outAR <- subset(outAR, date2==today)
#outAR$state<-"AR"
#write.csv(outAR, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-california-presidential-general-election-trump-vs-clinton'
outCA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outCA <- outCA[min(grep("Undecided",outCA$who)):nrow(outCA),]
outCA$date2 <- as.Date(outCA$date, format="%Y-%m-%d")
outCA <- subset(outCA, date2==today)
outCA$state<-"CA"
write.csv(outCA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-colorado-president-trump-vs-clinton'
outCO <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outCO <- outCO[min(grep("Undecided",outCO$who)):nrow(outCO),]
outCO$date2 <- as.Date(outCO$date, format="%Y-%m-%d")
outCO <- subset(outCO, date2==today)
outCO$state<-"CO"
write.csv(outCO, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-connecticut-president-trump-vs-clinton'
#outCT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outCT <- outCT[min(grep("Undecided",outCT$who)):nrow(outCT),]
#outCT$date2 <- as.Date(outCT$date, format="%Y-%m-%d")
#outCT <- subset(outCT, date2==today)
#outCT$state<-"CT"
#write.csv(outCT, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-delaware-president-trump-vs-clinton'
#outDE <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outDE <- outDE[min(grep("Undecided",outDE$who)):nrow(outDE),]
#outDE$date2 <- as.Date(outDE$date, format="%Y-%m-%d")
#outDE <- subset(outDE, date2==today)
#outDE$state<-"DE"
#write.csv(outDE, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-florida-presidential-general-election-trump-vs-clinton'
outFL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outFL <- outFL[min(grep("Undecided",outFL$who)):nrow(outFL),]
outFL$date2 <- as.Date(outFL$date, format="%Y-%m-%d")
outFL <- subset(outFL, date2==today)
outFL$state<-"FL"
write.csv(outFL, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-georgia-president-trump-vs-clinton'
outGA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outGA <- outGA[min(grep("Undecided",outGA$who)):nrow(outGA),]
outGA$date2 <- as.Date(outGA$date, format="%Y-%m-%d")
outGA <- subset(outGA, date2==today)
outGA$state<-"GA"
write.csv(outGA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-hawaii-president-trump-vs-clinton'
#outHI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outHI <- outHI[min(grep("Undecided",outHI$who)):nrow(outHI),]
#outHI$date2 <- as.Date(outHI$date, format="%Y-%m-%d")
#outHI <- subset(outHI, date2==today)
#outHI$state<-"HI"
#write.csv(outHI, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-idaho-president-trump-vs-clinton'
#outID <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outID <- outID[min(grep("Undecided",outID$who)):nrow(outID),]
#outID$date2 <- as.Date(outID$date, format="%Y-%m-%d")
#outID <- subset(outID, date2==today)
#outID$state<-"ID"
#write.csv(outID, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-illinois-president-trump-vs-clinton'
#outIL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outIL <- outIL[min(grep("Undecided",outIL$who)):nrow(outIL),]
#outIL$date2 <- as.Date(outIL$date, format="%Y-%m-%d")
#outIL <- subset(outIL, date2==today)
#outIL$state<-"IL"
#write.csv(outIL, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-indiana-president-trump-vs-clinton'
#outIN <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outIN <- outIN[min(grep("Undecided",outIN$who)):nrow(outIN),]
#outIN$date2 <- as.Date(outIN$date, format="%Y-%m-%d")
#outIN <- subset(outIN, date2==today)
#outIN$state<-"IN"
#write.csv(outIN, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-iowa-president-trump-vs-clinton'
outIA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outIA <- outIA[min(grep("Undecided",outIA$who)):nrow(outIA),]
outIA$date2 <- as.Date(outIA$date, format="%Y-%m-%d")
outIA <- subset(outIA, date2==today)
outIA$state<-"IA"
write.csv(outIA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-kansas-president-trump-vs-clinton'
outKS <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outKS <- outKS[min(grep("Undecided",outKS$who)):nrow(outKS),]
outKS$date2 <- as.Date(outKS$date, format="%Y-%m-%d")
outKS <- subset(outKS, date2==today)
outKS$state<-"KS"
write.csv(outKS, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-kentucky-president-trump-vs-clinton'
#outKY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outKY <- outKY[min(grep("Undecided",outKY$who)):nrow(outKY),]
#outKY$date2 <- as.Date(outKY$date, format="%Y-%m-%d")
#outKY <- subset(outKY, date2==today)
#outKY$state<-"KY"
#write.csv(outKY, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-louisiana-president-trump-vs-clinton'
#outLA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outLA <- outLA[min(grep("Undecided",outLA$who)):nrow(outLA),]
#outLA$date2 <- as.Date(outLA$date, format="%Y-%m-%d")
#outLA <- subset(outLA, date2==today)
#outLA$state<-"LA"
#write.csv(outLA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-maine-president-trump-vs-clinton'
#out*ME <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outME <- outME[min(grep("Undecided",outME$who)):nrow(outME),]
#outME$date2 <- as.Date(outME$date, format="%Y-%m-%d")
#outME <- subset(outME, date2==today)
#outME$state<-"ME"
#write.csv(outME, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-maryland-president-trump-vs-clinton'
outMD <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outMD <- outMD[min(grep("Undecided",outMD$who)):nrow(outMD),]
outMD$date2 <- as.Date(outMD$date, format="%Y-%m-%d")
outMD <- subset(outMD, date2==today)
outMD$state<-"MD"
write.csv(outMD, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-massachusetts-president-trump-vs-clinton'
#outMA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMA <- outMA[min(grep("Undecided",outMA$who)):nrow(outMA),]
#outMA$date2 <- as.Date(outMA$date, format="%Y-%m-%d")
#outMA <- subset(outMA, date2==today)
#outMA$state<-"MA"
#write.csv(outMA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-michigan-president-trump-vs-clinton'
outMI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outMI <- outMI[min(grep("Undecided",outMI$who)):nrow(outMI),]
outMI$date2 <- as.Date(outMI$date, format="%Y-%m-%d")
outMI <- subset(outMI, date2==today)
outMI$state<-"MI"
write.csv(outMI, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-minnesota-president-trump-vs-clinton'
#outMN <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMN <- outMN[min(grep("Undecided",outMN$who)):nrow(outMN),]
#outMN$date2 <- as.Date(outMN$date, format="%Y-%m-%d")
#outMN <- subset(outMN, date2==today)
#outMN$state<-"MN"
#write.csv(outMN, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-mississippi-president-trump-vs-clinton'
#outMS <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMS <- outMS[min(grep("Undecided",outMS$who)):nrow(outMS),]
#outMS$date2 <- as.Date(outMS$date, format="%Y-%m-%d")
#outMS <- subset(outMS, date2==today)
#outMS$state<-"MS"
#write.csv(outMS, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-missouri-president-trump-vs-clinton'
outMO <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outMO <- outMO[min(grep("Undecided",outMO$who)):nrow(outMO),]
outMO$date2 <- as.Date(outMO$date, format="%Y-%m-%d")
outMO <- subset(outMO, date2==today)
outMO$state<-"MO"
write.csv(outMO, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-montana-president-trump-vs-clinton'
#outMT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMT <- outMT[min(grep("Undecided",outMT$who)):nrow(outMT),]
#outMT$date2 <- as.Date(outMT$date, format="%Y-%m-%d")
#outMT <- subset(outMT, date2==today)
#outMT$state<-"MT"
#write.csv(outMT, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-nebraska-president-trump-vs-clinton'
#outNE <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outNE <- outNE[min(grep("Undecided",outNE$who)):nrow(outNE),]
#outNE$date2 <- as.Date(outNE$date, format="%Y-%m-%d")
#outNE <- subset(outNE, date2==today)
#outNE$state<-"NE"
#write.csv(outNE, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-nevada-president-trump-vs-clinton'
outNV <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNV <- outNV[min(grep("Undecided",outNV$who)):nrow(outNV),]
outNV$date2 <- as.Date(outNV$date, format="%Y-%m-%d")
outNV <- subset(outNV, date2==today)
outNV$state<-"NV"
write.csv(outNV, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-hampshire-president-trump-vs-clinton'
outNH <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNH <- outNH[min(grep("Undecided",outNH$who)):nrow(outNH),]
outNH$date2 <- as.Date(outNH$date, format="%Y-%m-%d")
outNH <- subset(outNH, date2==today)
outNH$state<-"NH"
write.csv(outNH, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-new-jersey-president-trump-vs-clinton'
#outNJ <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outNJ <- outNJ[min(grep("Undecided",outNJ$who)):nrow(outNJ),]
#outNJ$date2 <- as.Date(outNJ$date, format="%Y-%m-%d")
#outNJ <- subset(outNJ, date2==today)
#outNJ$state<-"NJ"
#write.csv(outNJ, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-new-mexico-president-trump-vs-clinton'
#outNM <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outNM <- outNM[min(grep("Undecided",outNM$who)):nrow(outNM),]
#outNM$date2 <- as.Date(outNM$date, format="%Y-%m-%d")
#outNM <- subset(outNM, date2==today)
#outNM$state<-"NM"
#write.csv(outNM, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-york-president-trump-vs-clinton'
outNY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNY <- outNY[min(grep("Undecided",outNY$who)):nrow(outNY),]
outNY$date2 <- as.Date(outNY$date, format="%Y-%m-%d")
outNY <- subset(outNY, date2==today)
outNY$state<-"NY"
write.csv(outNY, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-north-carolina-president-trump-vs-clinton'
outNC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNC <- outNC[min(grep("Undecided",outNC$who)):nrow(outNC),]
outNC$date2 <- as.Date(outNC$date, format="%Y-%m-%d")
outNC <- subset(outNC, date2==today)
outNC$state<-"NC"
write.csv(outNC, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-north-dakota-president-trump-vs-clinton'
#outND <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outND <- outND[min(grep("Undecided",outND$who)):nrow(outND),]
#outND$date2 <- as.Date(outND$date, format="%Y-%m-%d")
#outND <- subset(outND, date2==today)
#outND$state<-"ND"
#write.csv(outND, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-ohio-president-trump-vs-clinton'
outOH <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outOH <- outOH[min(grep("Undecided",outOH$who)):nrow(outOH),]
outOH$date2 <- as.Date(outOH$date, format="%Y-%m-%d")
outOH <- subset(outOH, date2==today)
outOH$state<-"OH"
write.csv(outOH, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-oklahoma-president-trump-vs-clinton'
#outOK <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outOK <- outOK[min(grep("Undecided",outOK$who)):nrow(outOK),]
#outOK$date2 <- as.Date(outOK$date, format="%Y-%m-%d")
#outOK <- subset(outOK, date2==today)
#outOK$state<-"OK"
#write.csv(outOK, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-oregon-president-trump-vs-clinton'
outOR <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outOR <- outOR[min(grep("Undecided",outOR$who)):nrow(outOR),]
outOR$date2 <- as.Date(outOR$date, format="%Y-%m-%d")
outOR <- subset(outOR, date2==today)
outOR$state<-"OR"
write.csv(outOR, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-pennsylvania-president-trump-vs-clinton'
outPA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outPA <- outPA[min(grep("Undecided",outPA$who)):nrow(outPA),]
outPA$date2 <- as.Date(outPA$date, format="%Y-%m-%d")
outPA <- subset(outPA, date2==today)
outPA$state<-"PA"
write.csv(outPA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-rhode-island-president-trump-vs-clinton'
#outRI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outRI <- outRI[min(grep("Undecided",outRI$who)):nrow(outRI),]
#outRI$date2 <- as.Date(outRI$date, format="%Y-%m-%d")
#outRI <- subset(outRI, date2==today)
#outRI$state<-"RI"
#write.csv(outRI, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-south-carolina-president-trump-vs-clinton'
outSC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outSC <- outSC[min(grep("Undecided",outSC$who)):nrow(outSC),]
outSC$date2 <- as.Date(outSC$date, format="%Y-%m-%d")
outSC <- subset(outSC, date2==today)
outSC$state<-"SC"
write.csv(outSC, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-south-dakota-president-trump-vs-clinton'
#outSD <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outSD <- outSD[min(grep("Undecided",outSD$who)):nrow(outSD),]
#outSD$date2 <- as.Date(outSD$date, format="%Y-%m-%d")
#outSD <- subset(outSD, date2==today)
#outSD$state<-"SD"
#write.csv(outSD, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-tennessee-president-trump-vs-clinton'
#outTN <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outTN <- outTN[min(grep("Undecided",outTN$who)):nrow(outTN),]
#outTN$date2 <- as.Date(outTN$date, format="%Y-%m-%d")
#outTN <- subset(outTN, date2==today)
#outTN$state<-"TN"
#write.csv(outTN, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-texas-president-trump-vs-clinton'
outTX <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outTX <- outTX[min(grep("Undecided",outTX$who)):nrow(outTX),]
outTX$date2 <- as.Date(outTX$date, format="%Y-%m-%d")
outTX <- subset(outTX, date2==today)
outTX$state<-"TX"
write.csv(outTX, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-utah-president-trump-vs-clinton'
outUT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outUT <- outUT[min(grep("Undecided",outUT$who)):nrow(outUT),]
outUT$date2 <- as.Date(outUT$date, format="%Y-%m-%d")
outUT <- subset(outUT, date2==today)
outUT$state<-"UT"
write.csv(outUT, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-vermont-president-trump-vs-clinton'
#outVT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outVT <- outVT[min(grep("Undecided",outVT$who)):nrow(outVT),]
#outVT$date2 <- as.Date(outVT$date, format="%Y-%m-%d")
#outVT <- subset(outVT, date2==today)
#outVT$state<-"VT"
#write.csv(outVT, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-virginia-president-trump-vs-clinton'
outVA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outVA <- outVA[min(grep("Undecided",outVA$who)):nrow(outVA),]
outVA$date2 <- as.Date(outVA$date, format="%Y-%m-%d")
outVA <- subset(outVA, date2==today)
outVA$state<-"VA"
write.csv(outVA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-washington-president-trump-vs-clinton'
#outWA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outWA <- outWA[min(grep("Undecided",outWA$who)):nrow(outWA),]
#outWA$date2 <- as.Date(outWA$date, format="%Y-%m-%d")
#outWA <- subset(outWA, date2==today)
#outWA$state<-"WA"
#write.csv(outWA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-washington-dc-president-trump-vs-clinton'
#outDC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outDC <- outDC[min(grep("Undecided",outDC$who)):nrow(outDC),]
#outDC$date2 <- as.Date(outDC$date, format="%Y-%m-%d")
#outDC <- subset(outDC, date2==today)
#outDC$state<-"DC"
#write.csv(outDC, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-west-virginia-president-trump-vs-clinton'
#outWV <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outWV <- outWV[min(grep("Undecided",outWV$who)):nrow(outWV),]
#outWV$date2 <- as.Date(outWV$date, format="%Y-%m-%d")
#outWV <- subset(outWV, date2==today)
#outWV$state<-"WV"
#write.csv(outWV, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-wisconsin-president-trump-vs-clinton'
outWI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outWI <- outWI[min(grep("Undecided",outWI$who)):nrow(outWI),]
outWI$date2 <- as.Date(outWI$date, format="%Y-%m-%d")
outWI <- subset(outWI, date2==today)
outWI$state<-"WI"
write.csv(outWI, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-wyoming-president-trump-vs-clinton'
#outWY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outWY <- outWY[min(grep("Undecided",outWY$who)):nrow(outWY),]
#outWY$date2 <- as.Date(outWY$date, format="%Y-%m-%d")
#outWY <- subset(outWY, date2==today)
#outWY$state<-"WY"
#write.csv(outWY, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

####Merge files into one#####
filenames <- list.files(path="post/und/", pattern='2016.*csv', full.names=TRUE)
alldata<-do.call("rbind", lapply(filenames, read.csv, header=TRUE))
alldata$X.1<-NULL ##deletes defunct case number column
alldata$X<-NULL  ##deletes the other defunct case number column
alldata$date<-NULL ##deletes duplicate date column (date2 is in date format)
alldata <- alldata[which(alldata$who=="Undecided"), ]
write.csv(alldata,"post/und/alldata.csv")

##Take only last row from each state
undecided <- alldata #[which(alldata$date2=="2016-11-08"),]
write.csv(undecided,"post/und/pollstates.csv")

pollstates$undecided <- undecided$xibar
