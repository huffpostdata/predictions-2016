#library(rjson)

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
##no polls states to be added as needed: AL, AK, AR, FL, HI, ID, KY, LA, ND, OK, OR, SD; stays in no polls: CA

#chart <- '2016-alabama-senate-shelby-vs-crumpton'
#outAL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAL <- outAL[min(grep("minus",outAL$who)):nrow(outAL),] #this tells it to only import the "minus" data--which has the probability associated
#outAL$date2 <- as.Date(outAL$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outAL <- subset(outAL, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outAL$state<-"AL"
#outAL$democrat<-"Crumpton"
#outAL$republican<-"Shelby"
#outAL$lead<-ifelse(outAL$who=="Shelby minus Crumpton","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outAL$numdays <- electionday - today #code number of days to election
#write.csv(outAL, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-alaska-senate-murkowski-vs-metcalfe'
#outAK <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAK <- outAK[min(grep("minus",outAK$who)):nrow(outAK),] #this tells it to only import the "minus" data--which has the probability associated
#outAK$date2 <- as.Date(outAK$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outAK <- subset(outAK, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outAK$state<-"AK"
#outAK$democrat<-"Metcalfe"
#outAK$republican<-"Murkowski"
#outAK$lead<-ifelse(outAK$who=="Murkowski minus Metcalfe","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outAK$numdays <- electionday - today #code number of days to election
#write.csv(outAK, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

##import data, put in correct format##
chart <- '2016-arizona-senate-McCain-vs-Kirkpatrick'
outAZ <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outAZ <- outAZ[min(grep("minus",outAZ$who)):nrow(outAZ),] #this tells it to only import the "minus" data--which has the probability associated
outAZ$date2 <- as.Date(outAZ$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outAZ <- subset(outAZ, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outAZ$state<-"AZ"
outAZ$democrat<-"Kirkpatrick"
outAZ$republican<-"McCain"
outAZ$lead<-ifelse(outAZ$who=="McCain minus Kirkpatrick","Republican lead", "Democrat lead") ##code whether probability shows rep lead or dem lead
outAZ$numdays <- electionday - today #code number of days to election
write.csv(outAZ, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-arkansas-senate-boozman-vs-eldridge'
#outAR <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outAR <- outAR[min(grep("minus",outAR$who)):nrow(outAR),] #this tells it to only import the "minus" data--which has the probability associated
#outAR$date2 <- as.Date(outAR$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outAR <- subset(outAR, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outAR$state<-"AR"
#outAR$democrat<-"Eldridge"
#outAR$republican<-"Boozman"
#outAR$lead<-ifelse(outAR$who=="Boozman minus Eldridge","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outAR$numdays <- electionday - today #code number of days to election
#write.csv(outAR, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-colorado-senate-glenn-vs-bennet'
outCO <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outCO <- outCO[min(grep("minus",outCO$who)):nrow(outCO),] #this tells it to only import the "minus" data--which has the probability associated
outCO$date2 <- as.Date(outCO$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outCO <- subset(outCO, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outCO$state<-"CO"
outCO$democrat<-"Bennet"
outCO$republican<-"Glenn"
outCO$lead<-ifelse(outCO$who=="Glenn minus Bennet","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outCO$numdays <- electionday - today #code number of days to election
write.csv(outCO, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-connecticut-senate-carter-vs-blumenthal'
#outCT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outCT <- outCT[min(grep("minus",outCT$who)):nrow(outCT),] #this tells it to only import the "minus" data--which has the probability associated
#outCT$date2 <- as.Date(outCT$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outCT <- subset(outCT, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outCT$state<-"CT"
#outCT$democrat<-"Blumenthal"
#outCT$republican<-"Carter"
#outCT$lead<-ifelse(outCT$who=="Carter minus Blumenthal","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outCT$numdays <- electionday - today #code number of days to election
#write.csv(outCT, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#############FLORIDA##############

chart <- '2016-georgia-senate-isakson-vs-barksdale'
outGA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outGA <- outGA[min(grep("minus",outGA$who)):nrow(outGA),] #this tells it to only import the "minus" data--which has the probability associated
outGA$date2 <- as.Date(outGA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outGA <- subset(outGA, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outGA$state<-"GA"
outGA$democrat<-"Barksdale"
outGA$republican<-"Isakson"
outGA$lead<-ifelse(outGA$who=="Isakson minus Barksdale","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outGA$numdays <- electionday - today #code number of days to election
write.csv(outGA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-hawaii-senate-carroll-vs-schatz'
#outHI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outHI <- outHI[min(grep("minus",outHI$who)):nrow(outHI),] #this tells it to only import the "minus" data--which has the probability associated
#outHI$date2 <- as.Date(outHI$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outHI <- subset(outHI, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outHI$state<-"HI"
#outHI$democrat<-"Schatz"
#outHI$republican<-"Carroll"
#outHI$lead<-ifelse(outHI$who=="Carroll minus Schatz","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outHI$numdays <- electionday - today #code number of days to election
#write.csv(outHI, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-idaho-senate-crapo-vs-sturgill'
#outID <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outID <- outID[min(grep("minus",outID$who)):nrow(outID),] #this tells it to only import the "minus" data--which has the probability associated
#outID$date2 <- as.Date(outID$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outID <- subset(outID, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outID$state<-"ID"
#outID$democrat<-"Sturgill"
#outID$republican<-"Crapo"
#outID$lead<-ifelse(outID$who=="Crapo minus Sturgill","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outID$numdays <- electionday - today #code number of days to election
#write.csv(outID, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-illinois-senate-kirk-vs-duckworth'
#outIL <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outIL <- outIL[min(grep("minus",outIL$who)):nrow(outIL),] #this tells it to only import the "minus" data--which has the probability associated
#outIL$date2 <- as.Date(outIL$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outIL <- subset(outIL, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outIL$state<-"IL"
#outIL$democrat<-"Duckworth"
#outIL$republican<-"Kirk"
#outIL$lead<-ifelse(outIL$who=="Kirk minus Duckworth","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outIL$numdays <- electionday - today #code number of days to election
#write.csv(outIL, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-indiana-senate-young-vs-bayh'
outIN <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outIN <- outIN[min(grep("minus",outIN$who)):nrow(outIN),] #this tells it to only import the "minus" data--which has the probability associated
outIN$date2 <- as.Date(outIN$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outIN <- subset(outIN, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outIN$state<-"IN"
outIN$democrat<-"Bayh"
outIN$republican<-"Young"
outIN$lead<-ifelse(outIN$who=="Young minus Bayh","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outIN$numdays <- electionday - today #code number of days to election
write.csv(outIN, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-iowa-senate-grassley-vs-judge'
outIA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outIA <- outIA[min(grep("minus",outIA$who)):nrow(outIA),] #this tells it to only import the "minus" data--which has the probability associated
outIA$date2 <- as.Date(outIA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outIA <- subset(outIA, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outIA$state<-"IA"
outIA$democrat<-"Judge"
outIA$republican<-"Grassley"
outIA$lead<-ifelse(outIA$who=="Grassley minus Judge","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outIA$numdays <- electionday - today #code number of days to election
write.csv(outIA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-kansas-senate-morgan-vs-wiesner'
#outKS <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outKS <- outKS[min(grep("minus",outKS$who)):nrow(outKS),] #this tells it to only import the "minus" data--which has the probability associated
#outKS$date2 <- as.Date(outKS$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outKS <- subset(outKS, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outKS$state<-"KS"
#outKS$democrat<-"Wiesner"
#outKS$republican<-"Moran"
#outKS$lead<-ifelse(outKS$who=="Moran minus Wiesner","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outKS$numdays <- electionday - today #code number of days to election
#write.csv(outKS, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-kentucky-senate-paul-vs-gray'
#outKY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outKY <- outKY[min(grep("minus",outKY$who)):nrow(outKY),] #this tells it to only import the "minus" data--which has the probability associated
#outKY$date2 <- as.Date(outKY$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outKY <- subset(outKY, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outKY$state<-"KY"
#outKY$democrat<-"Gray"
#outKY$republican<-"Paul"
#outKY$lead<-ifelse(outKY$who=="Paul minus Gray","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outKY$numdays <- electionday - today #code number of days to election
#write.csv(outKY, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

###########LOUISIANA#############

#chart <- '2016-maryland-senate-szeliga-vs-van-hollen'
#outMD <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outMD <- outMD[min(grep("minus",outMD$who)):nrow(outMD),] #this tells it to only import the "minus" data--which has the probability associated
#outMD$date2 <- as.Date(outMD$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outMD <- subset(outMD, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outMD$state<-"MD"
#outMD$democrat<-"Van-Hollen"
#outMD$republican<-"Szeliga"
#outMD$lead<-ifelse(outMD$who=="Szeliga minus Van-Hollen","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outMD$numdays <- electionday - today #code number of days to election
#write.csv(outMD, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-missouri-senate-blunt-vs-kander'
outMO <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outMO <- outMO[min(grep("minus",outMO$who)):nrow(outMO),] #this tells it to only import the "minus" data--which has the probability associated
outMO$date2 <- as.Date(outMO$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outMO <- subset(outMO, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outMO$state<-"MO"
outMO$democrat<-"Kander"
outMO$republican<-"Blunt"
outMO$lead<-ifelse(outMO$who=="Blunt minus Kander","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outMO$numdays <- electionday - today #code number of days to election
write.csv(outMO, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-nevada-senate-heck-vs-cortez-mastro'
outNV <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNV <- outNV[min(grep("minus",outNV$who)):nrow(outNV),] #this tells it to only import the "minus" data--which has the probability associated
outNV$date2 <- as.Date(outNV$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNV <- subset(outNV, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outNV$state<-"NV"
outNV$democrat<-"Cortez-Masto"
outNV$republican<-"Heck"
outNV$lead<-ifelse(outNV$who=="Heck minus Cortez-Masto","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outNV$numdays <- electionday - today #code number of days to election
write.csv(outNV, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-hampshire-ayotte-vs-hassan'
outNH <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNH <- outNH[min(grep("minus",outNH$who)):nrow(outNH),] #this tells it to only import the "minus" data--which has the probability associated
outNH$date2 <- as.Date(outNH$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNH <- subset(outNH, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outNH$state<-"NH"
outNH$democrat<-"Hassan"
outNH$republican<-"Ayotte"
outNH$lead<-ifelse(outNH$who=="Ayotte minus Hassan","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outNH$numdays <- electionday - today #code number of days to election
write.csv(outNH, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-new-york-senate-long-vs-schumer'
outNY <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNY <- outNY[min(grep("minus",outNY$who)):nrow(outNY),] #this tells it to only import the "minus" data--which has the probability associated
outNY$date2 <- as.Date(outNY$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNY <- subset(outNY, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outNY$state<-"NY"
outNY$democrat<-"Schumer"
outNY$republican<-"Long"
outNY$lead<-ifelse(outNY$who=="Long minus Schumer","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outNY$numdays <- electionday - today #code number of days to election
write.csv(outNY, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-north-carolina-senate-burr-vs-ross'
outNC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outNC <- outNC[min(grep("minus",outNC$who)):nrow(outNC),] #this tells it to only import the "minus" data--which has the probability associated
outNC$date2 <- as.Date(outNC$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outNC <- subset(outNC, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outNC$state<-"NC"
outNC$democrat<-"Ross"
outNC$republican<-"Burr"
outNC$lead<-ifelse(outNC$who=="Burr minus Ross","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outNC$numdays <- electionday - today #code number of days to election
write.csv(outNC, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-north-dakota-senate-hoeven-vs-glassheim'
#outND <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outND <- outND[min(grep("minus",outND$who)):nrow(outND),] #this tells it to only import the "minus" data--which has the probability associated
#outND$date2 <- as.Date(outND$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outND <- subset(outND, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outND$state<-"ND"
#outND$democrat<-"Glassheim"
#outND$republican<-"Hoeven"
#outND$lead<-ifelse(outND$who=="Hoeven minus Glassheim","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outND$numdays <- electionday - today #code number of days to election
#write.csv(outND, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-ohio-senate-portman-vs-strickland'
outOH <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outOH <- outOH[min(grep("minus",outOH$who)):nrow(outOH),] #this tells it to only import the "minus" data--which has the probability associated
outOH$date2 <- as.Date(outOH$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outOH <- subset(outOH, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outOH$state<-"OH"
outOH$democrat<-"Strickland"
outOH$republican<-"Portman"
outOH$lead<-ifelse(outOH$who=="Portman minus Strickland","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outOH$numdays <- electionday - today #code number of days to election
write.csv(outOH, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-oklahoma-senate-lankford-vs-workman'
#outOK <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outOK <- outOK[min(grep("minus",outOK$who)):nrow(outOK),] #this tells it to only import the "minus" data--which has the probability associated
#outOK$date2 <- as.Date(outOK$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outOK <- subset(outOK, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outOK$state<-"OK"
#outOK$democrat<-"Workman"
#outOK$republican<-"Lankford"
#outOK$lead<-ifelse(outOK$who=="Lankford minus Workman","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outOK$numdays <- electionday - today #code number of days to election
#write.csv(outOK, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-oregon-senate-callahan-vs-wyden'
#outOR <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outOR <- outOR[min(grep("minus",outOR$who)):nrow(outOR),] #this tells it to only import the "minus" data--which has the probability associated
#outOR$date2 <- as.Date(outOR$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outOR <- subset(outOR, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outOR$state<-"OR"
#outOR$democrat<-"Wyden"
#outOR$republican<-"Callahan"
#outOR$lead<-ifelse(outOR$who=="Callahan minus Wyden","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outOR$numdays <- electionday - today #code number of days to election
#write.csv(outOR, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-pennsylvania-senate-toomey-vs-mcginty'
outPA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outPA <- outPA[min(grep("minus",outPA$who)):nrow(outPA),] #this tells it to only import the "minus" data--which has the probability associated
outPA$date2 <- as.Date(outPA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outPA <- subset(outPA, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outPA$state<-"PA"
outPA$democrat<-"McGinty"
outPA$republican<-"Toomey"
outPA$lead<-ifelse(outPA$who=="Toomey minus McGinty","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outPA$numdays <- electionday - today #code number of days to election
write.csv(outPA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-south—carolina-senate-scott-vs-dixon'
#outSC <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outSC <- outSC[min(grep("minus",outSC$who)):nrow(outSC),] #this tells it to only import the "minus" data--which has the probability associated
#outSC$date2 <- as.Date(outSC$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outSC <- subset(outSC, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outSC$state<-"SC"
#outSC$democrat<-"Dixon"
#outSC$republican<-"Scott"
#outSC$lead<-ifelse(outSC$who=="Scott minus Dixon","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outSC$numdays <- electionday - today #code number of days to election
#write.csv(outSC, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-south-dakota-senate-thune-vs-williams'
#outSD <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outSD <- outSD[min(grep("minus",outSD$who)):nrow(outSD),] #this tells it to only import the "minus" data--which has the probability associated
#outSD$date2 <- as.Date(outSD$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outSD <- subset(outSD, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outSD$state<-"SD"
#outSD$democrat<-"Williams"
#outSD$republican<-"Thune"
#outSD$lead<-ifelse(outSD$who=="Thune minus Williams","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outSD$numdays <- electionday - today #code number of days to election
#write.csv(outSD, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-utah-senate-lee-vs-snow'
outUT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outUT <- outUT[min(grep("minus",outUT$who)):nrow(outUT),] #this tells it to only import the "minus" data--which has the probability associated
outUT$date2 <- as.Date(outUT$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outUT <- subset(outUT, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outUT$state<-"UT"
outUT$democrat<-"Snow"
outUT$republican<-"Lee"
outUT$lead<-ifelse(outUT$who=="Lee minus Snow","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outUT$numdays <- electionday - today #code number of days to election
write.csv(outUT, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016—vermont-senate-milne-vs-leahy'
#outVT <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outVT <- outVT[min(grep("minus",outVT$who)):nrow(outVT),] #this tells it to only import the "minus" data--which has the probability associated
#outVT$date2 <- as.Date(outVT$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outVT <- subset(outVT, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outVT$state<-"VT"
#outVT$democrat<-"Leahy"
#outVT$republican<-"Milne"
#outVT$lead<-ifelse(outVT$who=="Milne minus Leahy","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outVT$numdays <- electionday - today #code number of days to election
#write.csv(outVT, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

#chart <- '2016-washington-senate-vance-vs-murray'
#outWA <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
#outWA <- outWA[min(grep("minus",outWA$who)):nrow(outWA),] #this tells it to only import the "minus" data--which has the probability associated
#outWA$date2 <- as.Date(outWA$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
#outWA <- subset(outWA, date2==today) #deletes rows prior to today so that all files will have the same number of rows
#outWA$state<-"WA"
#outWA$democrat<-"Murray"
#outWA$republican<-"Vance"
#outWA$lead<-ifelse(outWA$who=="Vance minus Murray","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
#outWA$numdays <- electionday - today #code number of days to election
#write.csv(outWA, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later

chart <- '2016-wisconsin-senate-johnson-vs-feingold'
outWI <- read.csv(paste(dataDir,chart,'/out.csv',sep=''))
outWI <- outWI[min(grep("minus",outWI$who)):nrow(outWI),] #this tells it to only import the "minus" data--which has the probability associated
outWI$date2 <- as.Date(outWI$date, format="%Y-%m-%d") #date read in as a factor, convert to date for subsetting
outWI <- subset(outWI, date2==today) #deletes rows prior to today so that all files will have the same number of rows
outWI$state<-"WI"
outWI$democrat<-"Feingold"
outWI$republican<-"Johnson"
outWI$lead<-ifelse(outWI$who=="Johnson minus Feingold","Republican lead", "Democrat lead") ##code whether probability shows Dem lead or Rep lead
outWI$numdays <- electionday - today #code number of days to election
write.csv(outWI, file=paste('post/',chart,'.csv',sep='')) ##save file for merging later


####Merge files into one#####
filenames <- list.files(path="post/", pattern='^2016.*csv', full.names=TRUE)
alldata<-do.call("rbind", lapply(filenames, read.csv, header=TRUE))
alldata$X.1<-NULL ##deletes defunct case number column
alldata$X<-NULL  ##deletes the other defunct case number column
alldata$date<-NULL ##deletes duplicate date column (date2 is in date format)
#write.csv(alldata,"post/alldata.csv")

##Take only last row from each state
pollstates <- alldata # [which(alldata$date2==today),]
#write.csv(pollstates,"post/pollstates.csv")

##Get undecided info for adjustment below
source("undecided.R")

##merge with nopolls-states.csv
nopollstates <- read.csv("nopolls-states.csv")
nopollstates$numdays <- electionday - today
nopollstates$date2 <- today
allstates <- rbind(pollstates, nopollstates)
#write.csv(allstates,"post/allstates.csv")

allstates$prob <- as.numeric(allstates$prob)
allstates$call[allstates$lead=="Democrat lead" & allstates$prob >= 50] <- "D"
allstates$call[allstates$lead=="Republican lead" & allstates$prob >= 50] <- "R"
allstates$call[allstates$lead=="Democrat lead" & allstates$prob < 50] <- "R"
allstates$call[allstates$lead=="Republican lead" & allstates$prob < 50] <- "D"

allstates$finalprobA <- ifelse(allstates$lead=="Republican lead" & allstates$call=="D", 100 - allstates$prob, allstates$prob)
allstates$finalprobA <- ifelse(allstates$lead=="Democrat lead" & allstates$call=="R", 100 - allstates$prob, allstates$finalprobA)

#undecided adjustment
allstates$undecMargin <- abs(allstates$undecided/allstates$xibar)
allstates$undecMargin[allstates$undecMargin=="NaN"]<- 0
allstates$undecMargin[allstates$undecMargin > 10] <- 10 #don't allow values above 10

allstates$finalprob <- allstates$finalprobA - allstates$undecMargin
allstates$finalprob[allstates$finalprob <= 50] <- 50 #truncate at 50 to keep adjustments from flipping the race

#write.csv(allstates,"post/allstates.csv") ##write the whole file only if you need to check everything

outSenate16 <- allstates[, c("state", "call", "finalprob", "democrat", "republican")]
write.csv(outSenate16, "post/outSenate16.csv")
write.csv(outSenate16, paste("post/outSenate16_",today,".csv",sep=""))


#Convert to D-side probs for D takeover prob calculation
allstates$DprobA <- 0
allstates$DprobA[allstates$call=="R"] <- 100 ##need to subtract from 100 for D prob
allstates$Dprob <- ifelse(allstates$DprobA==100, as.numeric(allstates$DprobA) - as.numeric(allstates$finalprob), allstates$finalprob)

# Monte Carlo approach for generating overall D hold probability

sims <- 10000                                  # number of simulations to run
DWins <- 0                                  # number of simulations in which Dems won a majority
Tie <- 0
for (s in 1:sims) {                           # iterate over simulations
  DSeats <- 0                               # number of Dem seats won in this simulation
  for (i in 1:nrow(allstates)) {              # iterate over races
    seat <- allstates[i, ]
    if (sample(0:99, 1) < seat['Dprob']) { # generate a random number between 0 and 99, if random number is less than Dem prob, increment Dem seats won
      DSeats = DSeats + 1
    }
  }
  if (DSeats + 36 > 50) {                   # if Dems won the majority in this simulation, increment D wins
    DWins = DWins + 1
  }
  if (DSeats + 36 == 50) {					# if seat count is tied, increment tie count
  	Tie = Tie + 1
  }
}
print(paste("After ",sims," simulations, Democrats won ",DWins," (",(DWins/sims*100),"%)", sep="")) # print percent of simulations where Dems won majority

Dtakeover <- (DWins/sims*100)
TieProb <- (Tie/sims*100)
countD <- sum(allstates$call=="D") + 36
countR <- sum(allstates$call=="R") + 30
count5050D <- sum(allstates$finalprob==50 & allstates$call=="D")
count5050R <- sum(allstates$finalprob==50 & allstates$call=="R")

SeatCount <- rbind(countD, count5050D, countR, count5050R, Dtakeover, TieProb)

write.csv(SeatCount, "post/seatcount.csv")

