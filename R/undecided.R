dir.create('post/und/', showWarnings=FALSE, recursive=TRUE)
##no polls states to be added as needed: AL, AK, AR, FL, HI, ID, KY, LA, ND, OK, OR, SD, Stays in nopolls: CA

#chart <- '2016-alabama-senate-shelby-vs-crumpton'
#outAL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAL <- outAL[min(grep("Undecided",outAL$who)):nrow(outAL),]
#outAL$date2 <- as.Date(outAL$date, format="%Y-%m-%d")
#outAL <- subset(outAL, date2==today)
#outAL$state<-"AL"
#write.csv(outAL, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-alaska-senate-murkowski-vs-metcalfe'
#outAK <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAK <- outAK[min(grep("Undecided",outAK$who)):nrow(outAK),]
#outAK$date2 <- as.Date(outAK$date, format="%Y-%m-%d")
#outAK <- subset(outAK, date2==today)
#outAK$state<-"AK"
#write.csv(outAK, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-arizona-senate-mccain-vs-kirkpatrick'
outAZ <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outAZ <- outAZ[min(grep("Undecided",outAZ$who)):nrow(outAZ),]
outAZ$date2 <- as.Date(outAZ$date, format="%Y-%m-%d")
outAZ <- subset(outAZ, date2==today)
outAZ$state<-"AZ"
write.csv(outAZ, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-arkansas-senate-boozman-vs-eldridge'
#outAR <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAR <- outAR[min(grep("Undecided",outAR$who)):nrow(outAR),]
#outAR$date2 <- as.Date(outAR$date, format="%Y-%m-%d")
#outAR <- subset(outAR, date2==today)
#outAR$state<-"AR"
#write.csv(outAR, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-colorado-senate-glenn-vs-bennet'
outCO <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outCO <- outCO[min(grep("Undecided",outCO$who)):nrow(outCO),]
outCO$date2 <- as.Date(outCO$date, format="%Y-%m-%d")
outCO <- subset(outCO, date2==today)
outCO$state<-"CO"
write.csv(outCO, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-connecticut-senate-carter-vs-blumenthal'
#outCT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outCT <- outCT[min(grep("Undecided",outCT$who)):nrow(outCT),]
#outCT$date2 <- as.Date(outCT$date, format="%Y-%m-%d")
#outCT <- subset(outCT, date2==today)
#outCT$state<-"CT"
#write.csv(outCT, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

##############FLORIDA##################

chart <- '2016-georgia-senate-isakson-vs-barksdale'
outGA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outGA <- outGA[min(grep("Undecided",outGA$who)):nrow(outGA),]
outGA$date2 <- as.Date(outGA$date, format="%Y-%m-%d")
outGA <- subset(outGA, date2==today)
outGA$state<-"GA"
write.csv(outGA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-hawaii-senate-carroll-vs-schatz'
#outHI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outHI <- outHI[min(grep("Undecided",outHI$who)):nrow(outHI),]
#outHI$date2 <- as.Date(outHI$date, format="%Y-%m-%d")
#outHI <- subset(outHI, date2==today)
#outHI$state<-"HI"
#write.csv(outHI, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-idaho-senate-crapo-vs-sturgill'
#outID <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outID <- outID[min(grep("Undecided",outID$who)):nrow(outID),]
#outID$date2 <- as.Date(outID$date, format="%Y-%m-%d")
#outID <- subset(outID, date2==today)
#outID$state<-"ID"
#write.csv(outID, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-illinois-senate-kirk-vs-duckworth'
#outIL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outIL <- outIL[min(grep("Undecided",outIL$who)):nrow(outIL),]
#outIL$date2 <- as.Date(outIL$date, format="%Y-%m-%d")
#outIL <- subset(outIL, date2==today)
#outIL$state<-"IL"
#write.csv(outIL, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-indiana-senate-young-vs-bayh'
outIN <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outIN <- outIN[min(grep("Undecided",outIN$who)):nrow(outIN),]
outIN$date2 <- as.Date(outIN$date, format="%Y-%m-%d")
outIN <- subset(outIN, date2==today)
outIN$state<-"IN"
write.csv(outIN, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-iowa-senate-grassley-vs-judge'
outIA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outIA <- outIA[min(grep("Undecided",outIA$who)):nrow(outIA),]
outIA$date2 <- as.Date(outIA$date, format="%Y-%m-%d")
outIA <- subset(outIA, date2==today)
outIA$state<-"IA"
write.csv(outIA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-kansas-senate-morgan-vs-wiesner'
#outKS <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outKS <- outKS[min(grep("Undecided",outKS$who)):nrow(outKS),]
#outKS$date2 <- as.Date(outKS$date, format="%Y-%m-%d")
#outKS <- subset(outKS, date2==today)
#outKS$state<-"KS"
#write.csv(outKS, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-kentucky-senate-paul-vs-gray'
#outKY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outKY <- outKY[min(grep("Undecided",outKY$who)):nrow(outKY),]
#outKY$date2 <- as.Date(outKY$date, format="%Y-%m-%d")
#outKY <- subset(outKY, date2==today)
#outKY$state<-"KY"
#write.csv(outKY, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

###########LOUISIANA################

#chart <- '2016-maryland-senate-szeliga-vs-van-hollen'
#outMD <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMD <- outMD[min(grep("Undecided",outMD$who)):nrow(outMD),]
#outMD$date2 <- as.Date(outMD$date, format="%Y-%m-%d")
#outMD <- subset(outMD, date2==today)
#outMD$state<-"MD"
#write.csv(outMD, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-missouri-senate-blunt-vs-kander'
outMO <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outMO <- outMO[min(grep("Undecided",outMO$who)):nrow(outMO),]
outMO$date2 <- as.Date(outMO$date, format="%Y-%m-%d")
outMO <- subset(outMO, date2==today)
outMO$state<-"MO"
write.csv(outMO, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-nevada-senate-heck-vs-cortez-mastro'
outNV <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNV <- outNV[min(grep("Undecided",outNV$who)):nrow(outNV),]
outNV$date2 <- as.Date(outNV$date, format="%Y-%m-%d")
outNV <- subset(outNV, date2==today)
outNV$state<-"NV"
write.csv(outNV, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-hampshire-ayotte-vs-hassan'
outNH <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNH <- outNH[min(grep("Undecided",outNH$who)):nrow(outNH),]
outNH$date2 <- as.Date(outNH$date, format="%Y-%m-%d")
outNH <- subset(outNH, date2==today)
outNH$state<-"NH"
write.csv(outNH, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-york-senate-long-vs-schumer'
outNY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNY <- outNY[min(grep("Undecided",outNY$who)):nrow(outNY),]
outNY$date2 <- as.Date(outNY$date, format="%Y-%m-%d")
outNY <- subset(outNY, date2==today)
outNY$state<-"NY"
write.csv(outNY, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-north-carolina-senate-burr-vs-ross'
outNC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNC <- outNC[min(grep("Undecided",outNC$who)):nrow(outNC),]
outNC$date2 <- as.Date(outNC$date, format="%Y-%m-%d")
outNC <- subset(outNC, date2==today)
outNC$state<-"NC"
write.csv(outNC, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-north-dakota-senate-hoeven-vs-glassheim'
#outND <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outND <- outND[min(grep("Undecided",outND$who)):nrow(outND),]
#outND$date2 <- as.Date(outND$date, format="%Y-%m-%d")
#outND <- subset(outND, date2==today)
#outND$state<-"ND"
#write.csv(outND, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-ohio-senate-portman-vs-strickland'
outOH <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outOH <- outOH[min(grep("Undecided",outOH$who)):nrow(outOH),]
outOH$date2 <- as.Date(outOH$date, format="%Y-%m-%d")
outOH <- subset(outOH, date2==today)
outOH$state<-"OH"
write.csv(outOH, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-oklahoma-senate-lankford-vs-workman'
#outOK <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outOK <- outOK[min(grep("Undecided",outOK$who)):nrow(outOK),]
#outOK$date2 <- as.Date(outOK$date, format="%Y-%m-%d")
#outOK <- subset(outOK, date2==today)
#outOK$state<-"OK"
#write.csv(outOK, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-oregon-senate-callahan-vs-wyden'
#outOR <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outOR <- outOR[min(grep("Undecided",outOR$who)):nrow(outOR),]
#outOR$date2 <- as.Date(outOR$date, format="%Y-%m-%d")
#outOR <- subset(outOR, date2==today)
#outOR$state<-"OR"
#write.csv(outOR, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-pennsylvania-senate-toomey-vs-mcginty'
outPA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outPA <- outPA[min(grep("Undecided",outPA$who)):nrow(outPA),]
outPA$date2 <- as.Date(outPA$date, format="%Y-%m-%d")
outPA <- subset(outPA, date2==today)
outPA$state<-"PA"
write.csv(outPA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-south—carolina-senate-scott-vs-dixon'
#outSC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outSC <- outSC[min(grep("Undecided",outSC$who)):nrow(outSC),]
#outSC$date2 <- as.Date(outSC$date, format="%Y-%m-%d")
#outSC <- subset(outSC, date2==today)
#outSC$state<-"SC"
#write.csv(outSC, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-south-dakota-senate-thune-vs-williams'
#outSD <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outSD <- outSD[min(grep("Undecided",outSD$who)):nrow(outSD),]
#outSD$date2 <- as.Date(outSD$date, format="%Y-%m-%d")
#outSD <- subset(outSD, date2==today)
#outSD$state<-"SD"
#write.csv(outSD, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-utah-senate-lee-vs-snow'
outUT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outUT <- outUT[min(grep("Undecided",outUT$who)):nrow(outUT),]
outUT$date2 <- as.Date(outUT$date, format="%Y-%m-%d")
outUT <- subset(outUT, date2==today)
outUT$state<-"UT"
write.csv(outUT, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016—vermont-senate-milne-vs-leahy'
#outVT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outVT <- outVT[min(grep("Undecided",outVT$who)):nrow(outVT),]
#outVT$date2 <- as.Date(outVT$date, format="%Y-%m-%d")
#outVT <- subset(outVT, date2==today)
#outVT$state<-"VT"
#write.csv(outVT, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-washington-senate-vance-vs-murray'
#outWA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outWA <- outWA[min(grep("Undecided",outWA$who)):nrow(outWA),]
#outWA$date2 <- as.Date(outWA$date, format="%Y-%m-%d")
#outWA <- subset(outWA, date2==today)
#outWA$state<-"WA"
#write.csv(outWA, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-wisconsin-senate-johnson-vs-feingold'
outWI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outWI <- outWI[min(grep("Undecided",outWI$who)):nrow(outWI),]
outWI$date2 <- as.Date(outWI$date, format="%Y-%m-%d")
outWI <- subset(outWI, date2==today)
outWI$state<-"WI"
write.csv(outWI, file=paste('post/und/',chart,'.csv',sep='')) ##save file for merging later


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
