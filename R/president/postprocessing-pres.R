dir.create('post/', showWarnings=FALSE, recursive=TRUE)
if (file.exists("/var/www/html/pollster")) {
  dataDir <- '/var/www/html/pollster/shared/models/'
} else {
  dataDir <- 'data/'
}

#setting date for subset#
today <- as.Date(Sys.time(),tz="America/New_York")
electionday <- as.Date("2016-11-08")

##Repeat over all states##
##nopolls states: AL, AK, AR, CT, DE, HI, ID, IN, KY, LA, ME, MA, MN, MS, MT, NE, NM, ND, OK, RI, SD, TN, VT, WA, DC, VA, WY

#chart <- '2016-alabama-president-trump-vs-clinton'
#outAL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAL <- outAL[min(grep("minus",outAL$who)):nrow(outAL),] #this tells it to only import the "minus" data--which has the probability associated
#outAL$date2 <- as.Date(outAL$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outAL <- subset(outAL, date2>=today) #deletes rows prior to today so that all files will33 have the same number of rows
#outAL$state<-"AL"
#outAL$lead<-ifelse(outAL$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outAL$numdays <- electionday - today #code number of days to election
#outAL$todayprob <- outAL$prob[outAL$date2 == today] 
#outAL$edayprob <- outAL$prob[outAL$date2 == electionday]
#outAL$statedelta <- outAL$todayprob - outAL$edayprob
#outAL$statedelta <- ifelse(outAL$lead == "Democrat lead", outAL$statedelta * -1, outAL$statedelta)
#write.csv(outAL, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-alaska-president-trump-vs-clinton'
#outAK <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAK <- outAK[min(grep("minus",outAK$who)):nrow(outAK),] #this tells it to only import the "minus" data--which has the probability associated
#outAK$date2 <- as.Date(outAK$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outAK <- subset(outAK, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outAK$state<-"AK"
#outAK$lead<-ifelse(outAK$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outAK$numdays <- electionday - today #code number of days to election
#outAK$todayprob <- outAK$prob[outAK$date2 == today] 
#outAK$edayprob <- outAK$prob[outAK$date2 == electionday]
#outAK$statedelta <- outAK$todayprob - outAK$edayprob
#outAK$statedelta <- ifelse(outAK$lead == "Democrat lead", outAK$statedelta * -1, outAK$statedelta)
#write.csv(outAK, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-arizona-president-trump-vs-clinton'
outAZ <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outAZ <- outAZ[min(grep("minus",outAZ$who)):nrow(outAZ),] #this tells it to only import the "minus" data--which has the probability associated
outAZ$date2 <- as.Date(outAZ$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outAZ <- subset(outAZ, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outAZ$state<-"AZ"
outAZ$lead<-ifelse(outAZ$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outAZ$numdays <- electionday - today #code number of days to election
##Calculate delta for change since T1 to correlate with national poll estimates
## prob @ T1 - prob @ T2, need how much it moved relative to DEMOCRATS since prob adjustment will be on Dprob
outAZ$todayprob <- outAZ$prob[outAZ$date2 == today] 
outAZ$edayprob <- outAZ$prob[outAZ$date2 == electionday]
outAZ$statedelta <- outAZ$todayprob - outAZ$edayprob
outAZ$statedelta <- ifelse(outAZ$lead == "Democrat lead", outAZ$statedelta * -1, outAZ$statedelta)
write.csv(outAZ, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-arkansas-president-trump-vs-clinton'
#outAR <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAR <- outAR[min(grep("minus",outAR$who)):nrow(outAR),] #this tells it to only import the "minus" data--which has the probability associated
#outAR$date2 <- as.Date(outAR$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outAR <- subset(outAR, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outAR$state<-"AR"
#outAR$lead<-ifelse(outAR$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outAR$numdays <- electionday - today #code number of days to election
#outAR$todayprob <- outAR$prob[outAR$date2 == today] 
#outAR$edayprob <- outAR$prob[outAR$date2 == electionday]
#outAR$statedelta <- outAR$todayprob - outAR$edayprob
#outAR$statedelta <- ifelse(outAR$lead == "Democrat lead", outAR$statedelta * -1, outAR$statedelta)
#write.csv(outAR, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-california-presidential-general-election-trump-vs-clinton'
outCA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outCA <- outCA[min(grep("minus",outCA$who)):nrow(outCA),] #this tells it to only import the "minus" data--which has the probability associated
outCA$date2 <- as.Date(outCA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outCA <- subset(outCA, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outCA$state<-"CA"
outCA$lead<-ifelse(outCA$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outCA$numdays <- electionday - today #code number of days to election
outCA$todayprob <- outCA$prob[outCA$date2 == today] 
outCA$edayprob <- outCA$prob[outCA$date2 == electionday]
outCA$statedelta <- outCA$todayprob - outCA$edayprob
outCA$statedelta <- ifelse(outCA$lead == "Democrat lead", outCA$statedelta * -1, outCA$statedelta)
write.csv(outCA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-colorado-president-trump-vs-clinton'
outCO <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outCO <- outCO[min(grep("minus",outCO$who)):nrow(outCO),] #this tells it to only import the "minus" data--which has the probability associated
outCO$date2 <- as.Date(outCO$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outCO <- subset(outCO, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outCO$state<-"CO"
outCO$lead<-ifelse(outCO$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outCO$numdays <- electionday - today #code number of days to election
outCO$todayprob <- outCO$prob[outCO$date2 == today] 
outCO$edayprob <- outCO$prob[outCO$date2 == electionday]
outCO$statedelta <- outCO$todayprob - outCO$edayprob
outCO$statedelta <- ifelse(outCO$lead == "Democrat lead", outCO$statedelta * -1, outCO$statedelta)
write.csv(outCO, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-connecticut-president-trump-vs-clinton'
#outCT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outCT <- outCT[min(grep("minus",outCT$who)):nrow(outCT),] #this tells it to only import the "minus" data--which has the probability associated
#outCT$date2 <- as.Date(outCT$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outCT <- subset(outCT, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outCT$state<-"CT"
#outCT$lead<-ifelse(outCT$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outCT$numdays <- electionday - today #code number of days to election
#outCT$todayprob <- outCT$prob[outCT$date2 == today] 
#outCT$edayprob <- outCT$prob[outCT$date2 == electionday]
#outCT$statedelta <- outCT$todayprob - outCT$edayprob
#outCT$statedelta <- ifelse(outCT$lead == "Democrat lead", outCT$statedelta * -1, outCT$statedelta)
#write.csv(outCT, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-delaware-president-trump-vs-clinton'
#outDE <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outDE <- outDE[min(grep("minus",outDE$who)):nrow(outDE),] #this tells it to only import the "minus" data--which has the probability associated
#outDE$date2 <- as.Date(outDE$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outDE <- subset(outDE, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outDE$state<-"DE"
#outDE$lead<-ifelse(outDE$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outDE$numdays <- electionday - today #code number of days to election
#outDE$todayprob <- outDE$prob[outDE$date2 == today] 
#outDE$edayprob <- outDE$prob[outDE$date2 == electionday]
#outDE$statedelta <- outDE$todayprob - outDE$edayprob
#outDE$statedelta <- ifelse(outDE$lead == "Democrat lead", outDE$statedelta * -1, outDE$statedelta)
#write.csv(outDE, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-florida-presidential-general-election-trump-vs-clinton'
outFL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outFL <- outFL[min(grep("minus",outFL$who)):nrow(outFL),] #this tells it to only import the "minus" data--which has the probability associated
outFL$date2 <- as.Date(outFL$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outFL <- subset(outFL, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outFL$state<-"FL"
outFL$lead<-ifelse(outFL$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outFL$numdays <- electionday - today #code number of days to election
outFL$todayprob <- outFL$prob[outFL$date2 == today] 
outFL$edayprob <- outFL$prob[outFL$date2 == electionday]
outFL$statedelta <- outFL$todayprob - outFL$edayprob
outFL$statedelta <- ifelse(outFL$lead == "Democrat lead", outFL$statedelta * -1, outFL$statedelta)
write.csv(outFL, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-georgia-president-trump-vs-clinton'
outGA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outGA <- outGA[min(grep("minus",outGA$who)):nrow(outGA),] #this tells it to only import the "minus" data--which has the probability associated
outGA$date2 <- as.Date(outGA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outGA <- subset(outGA, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outGA$state<-"GA"
outGA$lead<-ifelse(outGA$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outGA$numdays <- electionday - today #code number of days to election
outGA$todayprob <- outGA$prob[outGA$date2 == today] 
outGA$edayprob <- outGA$prob[outGA$date2 == electionday]
outGA$statedelta <- outGA$todayprob - outGA$edayprob
outGA$statedelta <- ifelse(outGA$lead == "Democrat lead", outGA$statedelta * -1, outGA$statedelta)
write.csv(outGA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-hawaii-president-trump-vs-clinton'
#outHI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outHI <- outHI[min(grep("minus",outHI$who)):nrow(outHI),] #this tells it to only import the "minus" data--which has the probability associated
#outHI$date2 <- as.Date(outHI$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outHI <- subset(outHI, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outHI$state<-"HI"
#outHI$lead<-ifelse(outHI$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outHI$numdays <- electionday - today #code number of days to election
#outHI$todayprob <- outHI$prob[outHI$date2 == today] 
#outHI$edayprob <- outHI$prob[outHI$date2 == electionday]
#outHI$statedelta <- outHI$todayprob - outHI$edayprob
#outHI$statedelta <- ifelse(outHI$lead == "Democrat lead", outHI$statedelta * -1, outHI$statedelta)
#write.csv(outHI, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-idaho-president-trump-vs-clinton'
#outID <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outID <- outID[min(grep("minus",outID$who)):nrow(outID),] #this tells it to only import the "minus" data--which has the probability associated
#outID$date2 <- as.Date(outID$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outID <- subset(outID, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outID$state<-"ID"
#outID$lead<-ifelse(outID$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outID$numdays <- electionday - today #code number of days to election
#outID$todayprob <- outID$prob[outID$date2 == today] 
#outID$edayprob <- outID$prob[outID$date2 == electionday]
#outID$statedelta <- outID$todayprob - outID$edayprob
#outID$statedelta <- ifelse(outID$lead == "Democrat lead", outID$statedelta * -1, outID$statedelta)
#write.csv(outID, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-illinois-president-trump-vs-clinton'
outIL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outIL <- outIL[min(grep("minus",outIL$who)):nrow(outIL),] #this tells it to only import the "minus" data--which has the probability associated
outIL$date2 <- as.Date(outIL$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outIL <- subset(outIL, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outIL$state<-"IL"
outIL$lead<-ifelse(outIL$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outIL$numdays <- electionday - today #code number of days to election
outIL$todayprob <- outIL$prob[outIL$date2 == today] 
outIL$edayprob <- outIL$prob[outIL$date2 == electionday]
outIL$statedelta <- outIL$todayprob - outIL$edayprob
outIL$statedelta <- ifelse(outIL$lead == "Democrat lead", outIL$statedelta * -1, outIL$statedelta)
write.csv(outIL, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-indiana-president-trump-vs-clinton'
#outIN <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outIN <- outIN[min(grep("minus",outIN$who)):nrow(outIN),] #this tells it to only import the "minus" data--which has the probability associated
#outIN$date2 <- as.Date(outIN$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outIN <- subset(outIN, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outIN$state<-"IN"
#outIN$lead<-ifelse(outIN$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outIN$numdays <- electionday - today #code number of days to election
#outIN$todayprob <- outIN$prob[outIN$date2 == today] 
#outIN$edayprob <- outIN$prob[outIN$date2 == electionday]
#outIN$statedelta <- outIN$todayprob - outIN$edayprob
#outIN$statedelta <- ifelse(outIN$lead == "Democrat lead", outIN$statedelta * -1, outIN$statedelta)
#write.csv(outIN, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-iowa-president-trump-vs-clinton'
outIA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outIA <- outIA[min(grep("minus",outIA$who)):nrow(outIA),] #this tells it to only import the "minus" data--which has the probability associated
outIA$date2 <- as.Date(outIA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outIA <- subset(outIA, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outIA$state<-"IA"
outIA$lead<-ifelse(outIA$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outIA$numdays <- electionday - today #code number of days to election
outIA$todayprob <- outIA$prob[outIA$date2 == today] 
outIA$edayprob <- outIA$prob[outIA$date2 == electionday]
outIA$statedelta <- outIA$todayprob - outIA$edayprob
outIA$statedelta <- ifelse(outIA$lead == "Democrat lead", outIA$statedelta * -1, outIA$statedelta)
write.csv(outIA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-kansas-president-trump-vs-clinton'
outKS <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outKS <- outKS[min(grep("minus",outKS$who)):nrow(outKS),] #this tells it to only import the "minus" data--which has the probability associated
outKS$date2 <- as.Date(outKS$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outKS <- subset(outKS, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outKS$state<-"KS"
outKS$lead<-ifelse(outKS$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outKS$numdays <- electionday - today #code number of days to election
outKS$todayprob <- outKS$prob[outKS$date2 == today] 
outKS$edayprob <- outKS$prob[outKS$date2 == electionday]
outKS$statedelta <- outKS$todayprob - outKS$edayprob
outKS$statedelta <- ifelse(outKS$lead == "Democrat lead", outKS$statedelta * -1, outKS$statedelta)
write.csv(outKS, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-kentucky-president-trump-vs-clinton'
#outKY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outKY <- outKY[min(grep("minus",outKY$who)):nrow(outKY),] #this tells it to only import the "minus" data--which has the probability associated
#outKY$date2 <- as.Date(outKY$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outKY <- subset(outKY, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outKY$state<-"KY"
#outKY$lead<-ifelse(outKY$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outKY$numdays <- electionday - today #code number of days to election
#outKY$todayprob <- outKY$prob[outKY$date2 == today] 
#outKY$edayprob <- outKY$prob[outKY$date2 == electionday]
#outKY$statedelta <- outKY$todayprob - outKY$edayprob
#outKY$statedelta <- ifelse(outKY$lead == "Democrat lead", outKY$statedelta * -1, outKY$statedelta)
#write.csv(outKY, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-louisiana-president-trump-vs-clinton'
#outLA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outLA <- outLA[min(grep("minus",outLA$who)):nrow(outLA),] #this tells it to only import the "minus" data--which has the probability associated
#outLA$date2 <- as.Date(outLA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outLA <- subset(outLA, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outLA$state<-"LA"
#outLA$lead<-ifelse(outLA$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outLA$numdays <- electionday - today #code number of days to election
#outLA$todayprob <- outLA$prob[outLA$date2 == today] 
#outLA$edayprob <- outLA$prob[outLA$date2 == electionday]
#outLA$statedelta <- outLA$todayprob - outLA$edayprob
#outLA$statedelta <- ifelse(outLA$lead == "Democrat lead", outLA$statedelta * -1, outLA$statedelta)
#write.csv(outLA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-maine-president-trump-vs-clinton'
#outME <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outME <- outME[min(grep("minus",outME$who)):nrow(outME),] #this tells it to only import the "minus" data--which has the probability associated
#outME$date2 <- as.Date(outME$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outME <- subset(outME, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outME$state<-"ME"
#outME$lead<-ifelse(outME$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outME$numdays <- electionday - today #code number of days to election
#outME$todayprob <- outME$prob[outME$date2 == today] 
#outME$edayprob <- outME$prob[outME$date2 == electionday]
#outME$statedelta <- outME$todayprob - outME$edayprob
#outME$statedelta <- ifelse(outME$lead == "Democrat lead", outME$statedelta * -1, outME$statedelta)
#write.csv(outME, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-maryland-president-trump-vs-clinton'
outMD <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outMD <- outMD[min(grep("minus",outMD$who)):nrow(outMD),] #this tells it to only import the "minus" data--which has the probability associated
outMD$date2 <- as.Date(outMD$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outMD <- subset(outMD, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outMD$state<-"MD"
outMD$lead<-ifelse(outMD$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outMD$numdays <- electionday - today #code number of days to election
outMD$todayprob <- outMD$prob[outMD$date2 == today] 
outMD$edayprob <- outMD$prob[outMD$date2 == electionday]
outMD$statedelta <- outMD$todayprob - outMD$edayprob
outMD$statedelta <- ifelse(outMD$lead == "Democrat lead", outMD$statedelta * -1, outMD$statedelta)
write.csv(outMD, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-massachusetts-president-trump-vs-clinton'
#outMA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMA <- outMA[min(grep("minus",outMA$who)):nrow(outMA),] #this tells it to only import the "minus" data--which has the probability associated
#outMA$date2 <- as.Date(outMA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outMA <- subset(outMA, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outMA$state<-"MA"
#outMA$lead<-ifelse(outMA$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outMA$numdays <- electionday - today #code number of days to election
#outMA$todayprob <- outMA$prob[outMA$date2 == today] 
#outMA$edayprob <- outMA$prob[outMA$date2 == electionday]
#outMA$statedelta <- outMA$todayprob - outMA$edayprob
#outMA$statedelta <- ifelse(outMA$lead == "Democrat lead", outMA$statedelta * -1, outMA$statedelta)
#write.csv(outMA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-michigan-president-trump-vs-clinton'
outMI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outMI <- outMI[min(grep("minus",outMI$who)):nrow(outMI),] #this tells it to only import the "minus" data--which has the probability associated
outMI$date2 <- as.Date(outMI$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outMI <- subset(outMI, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outMI$state<-"MI"
outMI$lead<-ifelse(outMI$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outMI$numdays <- electionday - today #code number of days to election
outMI$todayprob <- outMI$prob[outMI$date2 == today] 
outMI$edayprob <- outMI$prob[outMI$date2 == electionday]
outMI$statedelta <- outMI$todayprob - outMI$edayprob
outMI$statedelta <- ifelse(outMI$lead == "Democrat lead", outMI$statedelta * -1, outMI$statedelta)
write.csv(outMI, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-minnesota-president-trump-vs-clinton'
#outMN <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMN <- outMN[min(grep("minus",outMN$who)):nrow(outMN),] #this tells it to only import the "minus" data--which has the probability associated
#outMN$date2 <- as.Date(outMN$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outMN <- subset(outMN, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outMN$state<-"MN"
#outMN$lead<-ifelse(outMN$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outMN$numdays <- electionday - today #code number of days to election
#outMN$todayprob <- outMN$prob[outMN$date2 == today] 
#outMN$edayprob <- outMN$prob[outMN$date2 == electionday]
#outMN$statedelta <- outMN$todayprob - outMN$edayprob
#outMN$statedelta <- ifelse(outMN$lead == "Democrat lead", outMN$statedelta * -1, outMN$statedelta)
#write.csv(outMN, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-mississippi-president-trump-vs-clinton'
#outMS <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMS <- outMS[min(grep("minus",outMS$who)):nrow(outMS),] #this tells it to only import the "minus" data--which has the probability associated
#outMS$date2 <- as.Date(outMS$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outMS <- subset(outMS, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outMS$state<-"MS"
#outMS$lead<-ifelse(outMS$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outMS$numdays <- electionday - today #code number of days to election
#outMS$todayprob <- outMS$prob[outMS$date2 == today] 
#outMS$edayprob <- outMS$prob[outMS$date2 == electionday]
#outMS$statedelta <- outMS$todayprob - outMS$edayprob
#outMS$statedelta <- ifelse(outMS$lead == "Democrat lead", outMS$statedelta * -1, outMS$statedelta)
#write.csv(outMS, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-missouri-president-trump-vs-clinton'
outMO <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outMO <- outMO[min(grep("minus",outMO$who)):nrow(outMO),] #this tells it to only import the "minus" data--which has the probability associated
outMO$date2 <- as.Date(outMO$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outMO <- subset(outMO, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outMO$state<-"MO"
outMO$lead<-ifelse(outMO$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outMO$numdays <- electionday - today #code number of days to election
outMO$todayprob <- outMO$prob[outMO$date2 == today] 
outMO$edayprob <- outMO$prob[outMO$date2 == electionday]
outMO$statedelta <- outMO$todayprob - outMO$edayprob
outMO$statedelta <- ifelse(outMO$lead == "Democrat lead", outMO$statedelta * -1, outMO$statedelta)
write.csv(outMO, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-montana-president-trump-vs-clinton'
#outMT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMT <- outMT[min(grep("minus",outMT$who)):nrow(outMT),] #this tells it to only import the "minus" data--which has the probability associated
#outMT$date2 <- as.Date(outMT$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outMT <- subset(outMT, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outMT$state<-"MT"
#outMT$lead<-ifelse(outMT$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outMT$numdays <- electionday - today #code number of days to election
#outMT$todayprob <- outMT$prob[outMT$date2 == today] 
#outMT$edayprob <- outMT$prob[outMT$date2 == electionday]
#outMT$statedelta <- outMT$todayprob - outMT$edayprob
#outMT$statedelta <- ifelse(outMT$lead == "Democrat lead", outMT$statedelta * -1, outMT$statedelta)
#write.csv(outMT, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-nebraska-president-trump-vs-clinton'
#outNE <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outNE <- outNE[min(grep("minus",outNE$who)):nrow(outNE),] #this tells it to only import the "minus" data--which has the probability associated
#outNE$date2 <- as.Date(outNE$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outNE <- subset(outNE, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outNE$state<-"NE"
#outNE$lead<-ifelse(outNE$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outNE$numdays <- electionday - today #code number of days to election
#outNE$todayprob <- outNE$prob[outNE$date2 == today] 
#outNE$edayprob <- outNE$prob[outNE$date2 == electionday]
#outNE$statedelta <- outNE$todayprob - outNE$edayprob
#outNE$statedelta <- ifelse(outNE$lead == "Democrat lead", outNE$statedelta * -1, outNE$statedelta)
#write.csv(outNE, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-nevada-president-trump-vs-clinton'
outNV <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNV <- outNV[min(grep("minus",outNV$who)):nrow(outNV),] #this tells it to only import the "minus" data--which has the probability associated
outNV$date2 <- as.Date(outNV$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNV <- subset(outNV, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outNV$state<-"NV"
outNV$lead<-ifelse(outNV$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outNV$numdays <- electionday - today #code number of days to election
outNV$todayprob <- outNV$prob[outNV$date2 == today] 
outNV$edayprob <- outNV$prob[outNV$date2 == electionday]
outNV$statedelta <- outNV$todayprob - outNV$edayprob
outNV$statedelta <- ifelse(outNV$lead == "Democrat lead", outNV$statedelta * -1, outNV$statedelta)
write.csv(outNV, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-hampshire-president-trump-vs-clinton'
outNH <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNH <- outNH[min(grep("minus",outNH$who)):nrow(outNH),] #this tells it to only import the "minus" data--which has the probability associated
outNH$date2 <- as.Date(outNH$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNH <- subset(outNH, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outNH$state<-"NH"
outNH$lead<-ifelse(outNH$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outNH$numdays <- electionday - today #code number of days to election
outNH$todayprob <- outNH$prob[outNH$date2 == today] 
outNH$edayprob <- outNH$prob[outNH$date2 == electionday]
outNH$statedelta <- outNH$todayprob - outNH$edayprob
outNH$statedelta <- ifelse(outNH$lead == "Democrat lead", outNH$statedelta * -1, outNH$statedelta)
write.csv(outNH, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-jersey-president-trump-vs-clinton'
outNJ <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNJ <- outNJ[min(grep("minus",outNJ$who)):nrow(outNJ),] #this tells it to only import the "minus" data--which has the probability associated
outNJ$date2 <- as.Date(outNJ$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNJ <- subset(outNJ, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outNJ$state<-"NJ"
outNJ$lead<-ifelse(outNJ$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outNJ$numdays <- electionday - today #code number of days to election
outNJ$todayprob <- outNJ$prob[outNJ$date2 == today] 
outNJ$edayprob <- outNJ$prob[outNJ$date2 == electionday]
outNJ$statedelta <- outNJ$todayprob - outNJ$edayprob
outNJ$statedelta <- ifelse(outNJ$lead == "Democrat lead", outNJ$statedelta * -1, outNJ$statedelta)
write.csv(outNJ, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-new-mexico-president-trump-vs-clinton'
#outNM <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outNM <- outNM[min(grep("minus",outNM$who)):nrow(outNM),] #this tells it to only import the "minus" data--which has the probability associated
#outNM$date2 <- as.Date(outNM$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outNM <- subset(outNM, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outNM$state<-"NM"
#outNM$lead<-ifelse(outNM$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outNM$numdays <- electionday - today #code number of days to election
#outNM$todayprob <- outNM$prob[outNM$date2 == today] 
#outNM$edayprob <- outNM$prob[outNM$date2 == electionday]
#outNM$statedelta <- outNM$todayprob - outNM$edayprob
#outNM$statedelta <- ifelse(outNM$lead == "Democrat lead", outNM$statedelta * -1, outNM$statedelta)
#write.csv(outNM, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-york-president-trump-vs-clinton'
outNY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNY <- outNY[min(grep("minus",outNY$who)):nrow(outNY),] #this tells it to only import the "minus" data--which has the probability associated
outNY$date2 <- as.Date(outNY$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNY <- subset(outNY, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outNY$state<-"NY"
outNY$lead<-ifelse(outNY$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outNY$numdays <- electionday - today #code number of days to election
outNY$todayprob <- outNY$prob[outNY$date2 == today] 
outNY$edayprob <- outNY$prob[outNY$date2 == electionday]
outNY$statedelta <- outNY$todayprob - outNY$edayprob
outNY$statedelta <- ifelse(outNY$lead == "Democrat lead", outNY$statedelta * -1, outNY$statedelta)
write.csv(outNY, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-north-carolina-president-trump-vs-clinton'
outNC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNC <- outNC[min(grep("minus",outNC$who)):nrow(outNC),] #this tells it to only import the "minus" data--which has the probability associated
outNC$date2 <- as.Date(outNC$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNC <- subset(outNC, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outNC$state<-"NC"
outNC$lead<-ifelse(outNC$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outNC$numdays <- electionday - today #code number of days to election
outNC$todayprob <- outNC$prob[outNC$date2 == today] 
outNC$edayprob <- outNC$prob[outNC$date2 == electionday]
outNC$statedelta <- outNC$todayprob - outNC$edayprob
outNC$statedelta <- ifelse(outNC$lead == "Democrat lead", outNC$statedelta * -1, outNC$statedelta)
write.csv(outNC, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-north-dakota-president-trump-vs-clinton'
#outND <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outND <- outND[min(grep("minus",outND$who)):nrow(outND),] #this tells it to only import the "minus" data--which has the probability associated
#outND$date2 <- as.Date(outND$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outND <- subset(outND, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outND$state<-"ND"
#outND$lead<-ifelse(outND$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outND$numdays <- electionday - today #code number of days to election
#outND$todayprob <- outND$prob[outND$date2 == today] 
#outND$edayprob <- outND$prob[outND$date2 == electionday]
#outND$statedelta <- outND$todayprob - outND$edayprob
#outND$statedelta <- ifelse(outND$lead == "Democrat lead", outND$statedelta * -1, outND$statedelta)
#write.csv(outND, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-ohio-president-trump-vs-clinton'
outOH <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outOH <- outOH[min(grep("minus",outOH$who)):nrow(outOH),] #this tells it to only import the "minus" data--which has the probability associated
outOH$date2 <- as.Date(outOH$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outOH <- subset(outOH, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outOH$state<-"OH"
outOH$lead<-ifelse(outOH$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outOH$numdays <- electionday - today #code number of days to election
outOH$todayprob <- outOH$prob[outOH$date2 == today] 
outOH$edayprob <- outOH$prob[outOH$date2 == electionday]
outOH$statedelta <- outOH$todayprob - outOH$edayprob
outOH$statedelta <- ifelse(outOH$lead == "Democrat lead", outOH$statedelta * -1, outOH$statedelta)
write.csv(outOH, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-oklahoma-president-trump-vs-clinton'
#outOK <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outOK <- outOK[min(grep("minus",outOK$who)):nrow(outOK),] #this tells it to only import the "minus" data--which has the probability associated
#outOK$date2 <- as.Date(outOK$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outOK <- subset(outOK, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outOK$state<-"OK"
#outOK$lead<-ifelse(outOK$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outOK$numdays <- electionday - today #code number of days to election
#outOK$todayprob <- outOK$prob[outOK$date2 == today] 
#outOK$edayprob <- outOK$prob[outOK$date2 == electionday]
#outOK$statedelta <- outOK$todayprob - outOK$edayprob
#outOK$statedelta <- ifelse(outOK$lead == "Democrat lead", outOK$statedelta * -1, outOK$statedelta)
#write.csv(outOK, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-oregon-president-trump-vs-clinton'
outOR <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outOR <- outOR[min(grep("minus",outOR$who)):nrow(outOR),] #this tells it to only import the "minus" data--which has the probability associated
outOR$date2 <- as.Date(outOR$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outOR <- subset(outOR, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outOR$state<-"OR"
outOR$lead<-ifelse(outOR$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outOR$numdays <- electionday - today #code number of days to election
outOR$todayprob <- outOR$prob[outOR$date2 == today] 
outOR$edayprob <- outOR$prob[outOR$date2 == electionday]
outOR$statedelta <- outOR$todayprob - outOR$edayprob
outOR$statedelta <- ifelse(outOR$lead == "Democrat lead", outOR$statedelta * -1, outOR$statedelta)
write.csv(outOR, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-pennsylvania-president-trump-vs-clinton'
outPA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outPA <- outPA[min(grep("minus",outPA$who)):nrow(outPA),] #this tells it to only import the "minus" data--which has the probability associated
outPA$date2 <- as.Date(outPA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outPA <- subset(outPA, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outPA$state<-"PA"
outPA$lead<-ifelse(outPA$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outPA$numdays <- electionday - today #code number of days to election
outPA$todayprob <- outPA$prob[outPA$date2 == today] 
outPA$edayprob <- outPA$prob[outPA$date2 == electionday]
outPA$statedelta <- outPA$todayprob - outPA$edayprob
outPA$statedelta <- ifelse(outPA$lead == "Democrat lead", outPA$statedelta * -1, outPA$statedelta)
write.csv(outPA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-rhode-island-president-trump-vs-clinton'
#outRI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outRI <- outRI[min(grep("minus",outRI$who)):nrow(outRI),] #this tells it to only import the "minus" data--which has the probability associated
#outRI$date2 <- as.Date(outRI$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outRI <- subset(outRI, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outRI$state<-"RI"
#outRI$lead<-ifelse(outRI$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outRI$numdays <- electionday - today #code number of days to election
#outRI$todayprob <- outRI$prob[outRI$date2 == today] 
#outRI$edayprob <- outRI$prob[outRI$date2 == electionday]
#outRI$statedelta <- outRI$todayprob - outRI$edayprob
#outRI$statedelta <- ifelse(outRI$lead == "Democrat lead", outRI$statedelta * -1, outRI$statedelta)
#write.csv(outRI, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-south-carolina-president-trump-vs-clinton'
outSC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outSC <- outSC[min(grep("minus",outSC$who)):nrow(outSC),] #this tells it to only import the "minus" data--which has the probability associated
outSC$date2 <- as.Date(outSC$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outSC <- subset(outSC, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outSC$state<-"SC"
outSC$lead<-ifelse(outSC$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outSC$numdays <- electionday - today #code number of days to election
outSC$todayprob <- outSC$prob[outSC$date2 == today] 
outSC$edayprob <- outSC$prob[outSC$date2 == electionday]
outSC$statedelta <- outSC$todayprob - outSC$edayprob
outSC$statedelta <- ifelse(outSC$lead == "Democrat lead", outSC$statedelta * -1, outSC$statedelta)
write.csv(outSC, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-south-dakota-president-trump-vs-clinton'
#outSD <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outSD <- outSD[min(grep("minus",outSD$who)):nrow(outSD),] #this tells it to only import the "minus" data--which has the probability associated
#outSD$date2 <- as.Date(outSD$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outSD <- subset(outSD, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outSD$state<-"SD"
#outSD$lead<-ifelse(outSD$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outSD$numdays <- electionday - today #code number of days to election
#outSD$todayprob <- outSD$prob[outSD$date2 == today] 
#outSD$edayprob <- outSD$prob[outSD$date2 == electionday]
#outSD$statedelta <- outSD$todayprob - outSD$edayprob
#outSD$statedelta <- ifelse(outSD$lead == "Democrat lead", outSD$statedelta * -1, outSD$statedelta)
#write.csv(outSD, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-tennessee-president-trump-vs-clinton'
#outTN <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outTN <- outTN[min(grep("minus",outTN$who)):nrow(outTN),] #this tells it to only import the "minus" data--which has the probability associated
#outTN$date2 <- as.Date(outTN$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outTN <- subset(outTN, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outTN$state<-"TN"
#outTN$lead<-ifelse(outTN$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outTN$numdays <- electionday - today #code number of days to election
#outTN$todayprob <- outTN$prob[outTN$date2 == today] 
#outTN$edayprob <- outTN$prob[outTN$date2 == electionday]
#outTN$statedelta <- outTN$todayprob - outTN$edayprob
#outTN$statedelta <- ifelse(outTN$lead == "Democrat lead", outTN$statedelta * -1, outTN$statedelta)
#write.csv(outTN, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-texas-president-trump-vs-clinton'
outTX <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outTX <- outTX[min(grep("minus",outTX$who)):nrow(outTX),] #this tells it to only import the "minus" data--which has the probability associated
outTX$date2 <- as.Date(outTX$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outTX <- subset(outTX, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outTX$state<-"TX"
outTX$lead<-ifelse(outTX$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outTX$numdays <- electionday - today #code number of days to election
outTX$todayprob <- outTX$prob[outTX$date2 == today] 
outTX$edayprob <- outTX$prob[outTX$date2 == electionday]
outTX$statedelta <- outTX$todayprob - outTX$edayprob
outTX$statedelta <- ifelse(outTX$lead == "Democrat lead", outTX$statedelta * -1, outTX$statedelta)
write.csv(outTX, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-utah-president-trump-vs-clinton'
outUT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outUT <- outUT[min(grep("minus",outUT$who)):nrow(outUT),] #this tells it to only import the "minus" data--which has the probability associated
outUT$date2 <- as.Date(outUT$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outUT <- subset(outUT, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outUT$state<-"UT"
outUT$lead<-ifelse(outUT$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outUT$numdays <- electionday - today #code number of days to election
outUT$todayprob <- outUT$prob[outUT$date2 == today] 
outUT$edayprob <- outUT$prob[outUT$date2 == electionday]
outUT$statedelta <- outUT$todayprob - outUT$edayprob
outUT$statedelta <- ifelse(outUT$lead == "Democrat lead", outUT$statedelta * -1, outUT$statedelta)
write.csv(outUT, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-vermont-president-trump-vs-clinton'
#outVT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outVT <- outVT[min(grep("minus",outVT$who)):nrow(outVT),] #this tells it to only import the "minus" data--which has the probability associated
#outVT$date2 <- as.Date(outVT$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outVT <- subset(outVT, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outVT$state<-"VT"
#outVT$lead<-ifelse(outVT$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outVT$numdays <- electionday - today #code number of days to election
#outVT$todayprob <- outVT$prob[outVT$date2 == today] 
#outVT$edayprob <- outVT$prob[outVT$date2 == electionday]
#outVT$statedelta <- outVT$todayprob - outVT$edayprob
#outVT$statedelta <- ifelse(outVT$lead == "Democrat lead", outVT$statedelta * -1, outVT$statedelta)
#write.csv(outVT, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-virginia-president-trump-vs-clinton'
outVA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outVA <- outVA[min(grep("minus",outVA$who)):nrow(outVA),] #this tells it to only import the "minus" data--which has the probability associated
outVA$date2 <- as.Date(outVA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outVA <- subset(outVA, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outVA$state<-"VA"
outVA$lead<-ifelse(outVA$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outVA$numdays <- electionday - today #code number of days to election
outVA$todayprob <- outVA$prob[outVA$date2 == today] 
outVA$edayprob <- outVA$prob[outVA$date2 == electionday]
outVA$statedelta <- outVA$todayprob - outVA$edayprob
outVA$statedelta <- ifelse(outVA$lead == "Democrat lead", outVA$statedelta * -1, outVA$statedelta)
write.csv(outVA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-washington-president-trump-vs-clinton'
#outWA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outWA <- outWA[min(grep("minus",outWA$who)):nrow(outWA),] #this tells it to only import the "minus" data--which has the probability associated
#outWA$date2 <- as.Date(outWA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outWA <- subset(outWA, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outWA$state<-"WA"
#outWA$lead<-ifelse(outWA$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outWA$numdays <- electionday - today #code number of days to election
#outWA$todayprob <- outWA$prob[outWA$date2 == today] 
#outWA$edayprob <- outWA$prob[outWA$date2 == electionday]
#outWA$statedelta <- outWA$todayprob - outWA$edayprob
#outWA$statedelta <- ifelse(outWA$lead == "Democrat lead", outWA$statedelta * -1, outWA$statedelta)
#write.csv(outWA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-washington-dc-president-trump-vs-clinton'
#outDC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outDC <- outDC[min(grep("minus",outDC$who)):nrow(outDC),] #this tells it to only import the "minus" data--which has the probability associated
#outDC$date2 <- as.Date(outDC$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outDC <- subset(outDC, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outDC$state<-"DC"
#outDC$lead<-ifelse(outDC$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outDC$numdays <- electionday - today #code number of days to election
#outDC$todayprob <- outDC$prob[outDC$date2 == today] 
#outDC$edayprob <- outDC$prob[outDC$date2 == electionday]
#outDC$statedelta <- outDC$todayprob - outDC$edayprob
#outDC$statedelta <- ifelse(outDC$lead == "Democrat lead", outDC$statedelta * -1, outDC$statedelta)
#write.csv(outDC, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-west-virginia-president-trump-vs-clinton'
#outWV <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outWV <- outWV[min(grep("minus",outWV$who)):nrow(outWV),] #this tells it to only import the "minus" data--which has the probability associated
#outWV$date2 <- as.Date(outWV$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outWV <- subset(outWV, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outWV$state<-"WV"
#outWV$lead<-ifelse(outWV$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outWV$numdays <- electionday - today #code number of days to election
#outWV$todayprob <- outWV$prob[outWV$date2 == today] 
#outWV$edayprob <- outWV$prob[outWV$date2 == electionday]
#outWV$statedelta <- outWV$todayprob - outWV$edayprob
#outWV$statedelta <- ifelse(outWV$lead == "Democrat lead", outWV$statedelta * -1, outWV$statedelta)
#write.csv(outWV, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-wisconsin-president-trump-vs-clinton'
outWI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outWI <- outWI[min(grep("minus",outWI$who)):nrow(outWI),] #this tells it to only import the "minus" data--which has the probability associated
outWI$date2 <- as.Date(outWI$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outWI <- subset(outWI, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outWI$state<-"WI"
outWI$lead<-ifelse(outWI$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outWI$numdays <- electionday - today #code number of days to election
outWI$todayprob <- outWI$prob[outWI$date2 == today] 
outWI$edayprob <- outWI$prob[outWI$date2 == electionday]
outWI$statedelta <- outWI$todayprob - outWI$edayprob
outWI$statedelta <- ifelse(outWI$lead == "Democrat lead", outWI$statedelta * -1, outWI$statedelta)
write.csv(outWI, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-wyoming-president-trump-vs-clinton'
#outWY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outWY <- outWY[min(grep("minus",outWY$who)):nrow(outWY),] #this tells it to only import the "minus" data--which has the probability associated
#outWY$date2 <- as.Date(outWY$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outWY <- subset(outWY, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
#outWY$state<-"WY"
#outWY$lead<-ifelse(outWY$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
#outWY$numdays <- electionday - today #code number of days to election
#outWY$todayprob <- outWY$prob[outWY$date2 == today] 
#outWY$edayprob <- outWY$prob[outWY$date2 == electionday]
#outWY$statedelta <- outWY$todayprob - outWY$edayprob
#outWY$statedelta <- ifelse(outWY$lead == "Democrat lead", outWY$statedelta * -1, outWY$statedelta)
#write.csv(outWY, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later


####Merge files into one#####
filenames <- list.files(path="post/", pattern='^2016.*csv', full.names=TRUE)
alldata<-do.call("rbind", lapply(filenames, read.csv, header=TRUE))
alldata$X.1<-NULL ##deletes defunct case number column
alldata$X<-NULL  ##deletes the other defunct case number column
alldata$date<-NULL ##deletes duplicate date column (date2 is in date format)
#write.csv(alldata,"post/alldata.csv")

##Take only last row from each state
pollstates <- alldata[which(alldata$date2=="2016-11-08"),]
write.csv(pollstates,"post/pollstates.csv")

##Get undecided info for adjustment below
source("undecided-pres.R")

##merge with nopolls-states.csv
nopollstates <- read.csv("nopolls-states.csv")

nopollstates$numdays <- electionday - today
allstates <- rbind(pollstates, nopollstates)

allstates$natcorr <- 0
allstates$natcorr[allstates$state == "AL"] <- -0.244653324
allstates$natcorr[allstates$state == "AK"] <- 0.247870729
allstates$natcorr[allstates$state == "AZ"] <- 0.152466489
allstates$natcorr[allstates$state == "AR"] <- -0.333665226
allstates$natcorr[allstates$state == "CA"] <- 0.14515663
allstates$natcorr[allstates$state == "CO"] <- 0.51263468
allstates$natcorr[allstates$state == "CT"] <- 0.547637552
allstates$natcorr[allstates$state == "DE"] <- 0.246571296
allstates$natcorr[allstates$state == "FL"] <- -0.581966931
allstates$natcorr[allstates$state == "GA"] <- -0.386494137
allstates$natcorr[allstates$state == "HI"] <- 0.077443706
allstates$natcorr[allstates$state == "ID"] <- 0.173568011
allstates$natcorr[allstates$state == "IL"] <- 0.718326354
allstates$natcorr[allstates$state == "IN"] <- 0.589855087
allstates$natcorr[allstates$state == "IA"] <- 0.101691601
allstates$natcorr[allstates$state == "KS"] <- 0.312746869
allstates$natcorr[allstates$state == "KY"] <- 0.211816931
allstates$natcorr[allstates$state == "LA"] <- -0.467572528
allstates$natcorr[allstates$state == "ME"] <- -0.029253895
allstates$natcorr[allstates$state == "MD"] <- 0.33644485
allstates$natcorr[allstates$state == "MA"] <- 0.403308934
allstates$natcorr[allstates$state == "MI"] <- 0.558589278
allstates$natcorr[allstates$state == "MN"] <- 0.415050131
allstates$natcorr[allstates$state == "MS"] <- -0.550264796
allstates$natcorr[allstates$state == "MO"] <- 0.38376488
allstates$natcorr[allstates$state == "MT"] <- 0.239613592
allstates$natcorr[allstates$state == "NE"] <- 0.223261251
allstates$natcorr[allstates$state == "NV"] <- 0.180878577
allstates$natcorr[allstates$state == "NH"] <- 0.079476814
allstates$natcorr[allstates$state == "NJ"] <- 0.682533752
allstates$natcorr[allstates$state == "NM"] <- 0.44503172
allstates$natcorr[allstates$state == "NY"] <- 0.487193249
allstates$natcorr[allstates$state == "NC"] <- -0.270236426
allstates$natcorr[allstates$state == "ND"] <- -0.078167543
allstates$natcorr[allstates$state == "OH"] <- 0.73570332
allstates$natcorr[allstates$state == "OK"] <- 0.104669858
allstates$natcorr[allstates$state == "OR"] <- 0.086661164
allstates$natcorr[allstates$state == "PA"] <- 0.497404433
allstates$natcorr[allstates$state == "RI"] <- 0.318697426
allstates$natcorr[allstates$state == "SC"] <- -0.552305102
allstates$natcorr[allstates$state == "SD"] <- 0.011122938
allstates$natcorr[allstates$state == "TN"] <- -0.298177733
allstates$natcorr[allstates$state == "TX"] <- -0.156431049
allstates$natcorr[allstates$state == "UT"] <- 0.342516753
allstates$natcorr[allstates$state == "VT"] <- -0.010687314
allstates$natcorr[allstates$state == "VA"] <- -0.397361917
allstates$natcorr[allstates$state == "WA"] <- 0.27242909
allstates$natcorr[allstates$state == "DC"] <- 0.343043534
allstates$natcorr[allstates$state == "WV"] <- 0.408556493
allstates$natcorr[allstates$state == "WI"] <- 0.508409487
allstates$natcorr[allstates$state == "WY"] <- 0.325882246
allstates$natcorr <- as.numeric(allstates$natcorr)

## Correlate delta(prob) from national with delta(prob) from states, adjust
chart <- '2016-general-election-trump-vs-clinton'
outUS <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outUS <- outUS[min(grep("minus",outUS$who)):nrow(outUS),] #this tells it to only import the "minus" data--which has the probability associated
outUS$date2 <- as.Date(outUS$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outUS <- subset(outUS, date2>=today) #deletes rows prior to today so that all files will have the same number of rows
outUS$state<-"US"
outUS$lead<-ifelse(outUS$who=="Trump minus Clinton","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outUS$numdays <- electionday - today #code number of days to election
outUS$todayprob <- outUS$prob[outUS$date2 == today] 
outUS$edayprob <- outUS$prob[outUS$date2 == electionday]
outUS$probdelta <- outUS$todayprob - outUS$edayprob
outUS$probdelta <- ifelse(outUS$lead == "Democrat lead", outUS$probdelta * -1, outUS$probdelta)
outUS <- subset(outUS, date2==electionday)

#calculating deltas to correlate with national, create variables
allstates$natdelta <- outUS$probdelta
allstates$adjdelta <- allstates$statedelta + (allstates$natdelta * allstates$natcorr)

#undecided adjustment
allstates$undecMargin <- abs(allstates$undecided/allstates$xibar)
allstates$undecMargin[allstates$undecMargin > 10] <- 10 #don't allow values above 10

#create call variable
allstates$prob <- as.numeric(allstates$prob)
allstates$call[allstates$lead=="Democrat lead" & allstates$prob >= 50] <- "D"
allstates$call[allstates$lead=="Republican lead" & allstates$prob >= 50] <- "R"
allstates$call[allstates$lead=="Democrat lead" & allstates$prob < 50] <- "R"
allstates$call[allstates$lead=="Republican lead" & allstates$prob < 50] <- "D"

allstates$adjprob <- allstates$todayprob - allstates$adjdelta
allstates$adjprob2 <- ifelse(allstates$todayprob >= 50, allstates$adjprob - allstates$undecMargin, allstates$adjprob + allstates$undecMargin)

allstates$finalprob <- ifelse(allstates$todayprob >= 50 & allstates$adjprob2 < 50, 50, allstates$adjprob2)
allstates$finalprob <- ifelse(allstates$todayprob <= 50 & allstates$adjprob2 > 50, 50, allstates$adjprob2)
allstates$finalprob[allstates$finalprob >= 100] <- 99.9 #truncate at 99.9 to prevent 100+ percent certainty
allstates$finalprob[allstates$finalprob <= 0] <- 0.01 #truncate at 0.01 to prevent 0 percent certainty

#Convert to D-side probs 
allstates$Dprob <- ifelse(allstates$call=="R" & allstates$finalprob >= 50, 100 - allstates$finalprob, allstates$finalprob)
allstates$Dprob <- ifelse(allstates$call=="D" & allstates$finalprob <= 50, 100 - allstates$finalprob, allstates$Dprob)


write.csv(allstates,"post/allstates.csv")


outPres16 <- allstates[, c("state", "call", "finalprob", "Dprob")]
write.csv(outPres16, "post/outPres16.csv")




# Monte Carlo approach for generating overall D hold probability

#sims <- 10000                                  # number of simulations to run
#DWins <- 0                                  # number of simulations in which Dems won a majority
#Tie <- 0
#for (s in 1:sims) {                           # iterate over simulations
#  DSeats <- 0                               # number of Dem seats won in this simulation
#  for (i in 1:nrow(allstates)) {              # iterate over races
#    seat <- allstates[i, ]
#    if (sample(0:99, 1) < seat['Dprob']) { # generate a random number between 0 and 99, if random number is less than Dem prob, increment Dem seats won
#      DSeats = DSeats + 1
#    }
#  }
#  if (DSeats + 36 > 50) {                   # if Dems won the majority in this simulation, increment D wins
#    DWins = DWins + 1
#  }
#  if (DSeats + 36 == 50) {					# if seat count is tied, increment tie count
#  	Tie = Tie + 1
#  }
#}
#print(paste("After ",sims," simulations, Democrats won ",DWins," (",(DWins/sims*100),"%)", sep="")) # print percent of simulations where Dems won majority

#Dtakeover <- (DWins/sims*100)
#TieProb <- (Tie/sims*100)
#countD <- sum(allstates$call=="D") + 36
#countR <- sum(allstates$call=="R") + 30
#count5050D <- sum(allstates$finalprob==50 & allstates$call=="D")
#count5050R <- sum(allstates$finalprob==50 & allstates$call=="R")

#SeatCount <- rbind(countD, count5050D, countR, count5050R, Dtakeover, TieProb)

#write.csv(SeatCount, "post/seatcount.csv")

