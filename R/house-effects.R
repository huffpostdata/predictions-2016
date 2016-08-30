library(rjson)

dir.create('house/', showWarnings=FALSE, recursive=TRUE)
if (file.exists("/var/www/html/pollster")) {
  dataDir <- '/var/www/html/pollster/shared/models/'
} else {
  dataDir <- 'data/'
}

today <- as.Date(Sys.time(),tz="America/New_York")

##no polls states to be added as needed: AL, AK, AR, FL, HI, ID, KY, LA, ND, OK, OR, SD, Keep CA in no polls

#chart <- '2016-alabama-senate-shelby-vs-crumpton'
#houseAL <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseAL <- houseAL[min(grep("minus",houseAL$who)):nrow(houseAL),]
#houseAL$state<-"AL"
#houseAL$democrat<-"Crumpton"
#houseAL$republican<-"Shelby"
#houseAL$direction<-ifelse(houseAL$who=="Shelby minus Crumpton","Democrat positive", "Republican positive")
#write.csv(houseAL, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-alaska-senate-murkowski-vs-metcalfe'
#houseAK <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseAK <- houseAK[min(grep("minus",houseAK$who)):nrow(houseAK),]
#houseAK$state<-"AK"
#houseAK$democrat<-"Metcalfe"
#houseAK$republican<-"Murkowski"
#houseAK$direction<-ifelse(houseAK$who=="Murkowski minus Metcalfe","Democrat positive", "Republican positive")
#write.csv(houseAK, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-arizona-senate-mccain-vs-kirkpatrick'
houseAZ <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseAZ <- houseAZ[min(grep("minus",houseAZ$who)):nrow(houseAZ),]
houseAZ$state<-"AZ"
houseAZ$democrat<-"Kirkpatrick"
houseAZ$republican<-"McCain"
houseAZ$direction<-ifelse(houseAZ$who=="McCain minus Kirkpatrick","Democrat positive", "Republican positive")
write.csv(houseAZ, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-arkansas-senate-boozman-vs-eldridge'
#houseAR <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseAR <- houseAR[min(grep("minus",houseAR$who)):nrow(houseAR),]
#houseAR$state<-"AR"
#houseAR$democrat<-"Eldridge"
#houseAR$republican<-"Boozman"
#houseAR$direction<-ifelse(houseAR$who=="Boozman minus Eldridge","Democrat positive", "Republican positive")
#write.csv(houseAR, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-colorado-senate-glenn-vs-bennet'
houseCO <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseCO <- houseCO[min(grep("minus",houseCO$who)):nrow(houseCO),]
houseCO$state<-"CO"
houseCO$democrat<-"Bennet"
houseCO$republican<-"Glenn"
houseCO$direction<-ifelse(houseCO$who=="Glenn minus Bennet","Democrat positive", "Republican positive")
write.csv(houseCO, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-connecticut-senate-carter-vs-blumenthal'
#houseCT <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseCT <- houseCT[min(grep("minus",houseCT$who)):nrow(houseCT),]
#houseCT$state<-"CT"
#houseCT$democrat<-"Blumenthal"
#houseCT$republican<-"Carter"
#houseCT$direction<-ifelse(houseCT$who=="Carter minus Blumenthal","Democrat positive", "Republican positive")
#write.csv(houseCT, file=paste('house/',chart,'.csv',sep=''))

############FLORIDA#############

chart <- '2016-georgia-senate-isakson-vs-barksdale'
houseGA <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseGA <- houseGA[min(grep("minus",houseGA$who)):nrow(houseGA),]
houseGA$state<-"GA"
houseGA$democrat<-"Barksdale"
houseGA$republican<-"Isakson"
houseGA$direction<-ifelse(houseGA$who=="Isakson minus Barksdale","Democrat positive", "Republican positive")
write.csv(houseGA, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-hawaii-senate-carroll-vs-schatz'
#houseHI <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseHI <- houseHI[min(grep("minus",houseHI$who)):nrow(houseHI),]
#houseHI$state<-"HI"
#houseHI$democrat<-"Schatz"
#houseHI$republican<-"Carroll"
#houseHI$direction<-ifelse(houseHI$who=="Carroll minus Schatz","Democrat positive", "Republican positive")
#write.csv(houseHI, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-idaho-senate-crapo-vs-sturgill'
#houseID <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseID <- houseID[min(grep("minus",houseID$who)):nrow(houseID),]
#houseID$state<-"ID"
#houseID$democrat<-"Sturgill"
#houseID$republican<-"Crapo"
#houseID$direction<-ifelse(houseID$who=="Crapo minus Sturgill","Democrat positive", "Republican positive")
#write.csv(houseID, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-illinois-senate-kirk-vs-duckworth'
#houseIL <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseIL <- houseIL[min(grep("minus",houseIL$who)):nrow(houseIL),]
#houseIL$state<-"IL"
#houseIL$democrat<-"Duckworth"
#houseIL$republican<-"Kirk"
#houseIL$direction<-ifelse(houseIL$who=="Kirk minus Duckworth","Democrat positive", "Republican positive")
#write.csv(houseIL, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-indiana-senate-young-vs-bayh'
houseIN <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseIN <- houseIN[min(grep("minus",houseIN$who)):nrow(houseIN),]
houseIN$state<-"IN"
houseIN$democrat<-"Bayh"
houseIN$republican<-"Young"
houseIN$direction<-ifelse(houseIN$who=="Young minus Bayh","Democrat positive", "Republican positive")
write.csv(houseIN, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-iowa-senate-grassley-vs-judge'
houseIA <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseIA <- houseIA[min(grep("minus",houseIA$who)):nrow(houseIA),]
houseIA$state<-"IA"
houseIA$democrat<-"Judge"
houseIA$republican<-"Grassley"
houseIA$direction<-ifelse(houseIA$who=="Grassley minus Judge","Democrat positive", "Republican positive")
write.csv(houseIA, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-kansas-senate-morgan-vs-wiesner'
#houseKS <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseKS <- houseKS[min(grep("minus",houseKS$who)):nrow(houseKS),]
#houseKS$state<-"KS"
#houseKS$democrat<-"Wiesner"
#houseKS$republican<-"Moran"
#houseKS$direction<-ifelse(houseKS$who=="Moran minus Weisner","Democrat positive", "Republican positive")
#write.csv(houseKS, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-kentucky-senate-paul-vs-gray'
#houseKY <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseKY <- houseKY[min(grep("minus",houseKY$who)):nrow(houseKY),]
#houseKY$state<-"KY"
#houseKY$democrat<-"Gray"
#houseKY$republican<-"Paul"
#houseKY$direction<-ifelse(houseKY$who=="Paul minus Gray","Democrat positive", "Republican positive")
#write.csv(houseKY, file=paste('house/',chart,'.csv',sep=''))

##############LOUISIANA##############

#chart <- '2016-maryland-senate-szeliga-vs-van-hollen'
#houseMD <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseMD <- houseMD[min(grep("minus",houseMD$who)):nrow(houseMD),]
#houseMD$state<-"MD"
#houseMD$democrat<-"Van-Hollen"
#houseMD$republican<-"Szeliga"
#houseMD$direction<-ifelse(houseMD$who=="Szeliga minus Van-Hollen","Democrat positive", "Republican positive")
#write.csv(houseMD, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-missouri-senate-blunt-vs-kander'
houseMO <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseMO <- houseMO[min(grep("minus",houseMO$who)):nrow(houseMO),]
houseMO$state<-"MO"
houseMO$democrat<-"Kander"
houseMO$republican<-"Blunt"
houseMO$direction<-ifelse(houseMO$who=="Blunt minus Kander","Democrat positive", "Republican positive")
write.csv(houseMO, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-nevada-senate-heck-vs-cortez-mastro'
houseNV <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseNV <- houseNV[min(grep("minus",houseNV$who)):nrow(houseNV),]
houseNV$state<-"NV"
houseNV$democrat<-"Cortez-Masto"
houseNV$republican<-"Heck"
houseNV$direction<-ifelse(houseNV$who=="Heck minus Cortez-Masto","Democrat positive", "Republican positive")
write.csv(houseNV, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-new-hampshire-ayotte-vs-hassan'
houseNH <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseNH <- houseNH[min(grep("minus",houseNH$who)):nrow(houseNH),]
houseNH$state<-"NH"
houseNH$democrat<-"Hassan"
houseNH$republican<-"Ayotte"
houseNH$direction<-ifelse(houseNH$who=="Ayotte minus Hassan","Democrat positive", "Republican positive")
write.csv(houseNH, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-new-york-senate-long-vs-schumer'
houseNY <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseNY <- houseNY[min(grep("minus",houseNY$who)):nrow(houseNY),]
houseNY$state<-"NY"
houseNY$democrat<-"Schumer"
houseNY$republican<-"Long"
houseNY$direction<-ifelse(houseNY$who=="Long minus Schumer","Democrat positive", "Republican positive")
write.csv(houseNY, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-north-carolina-senate-burr-vs-ross'
houseNC <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseNC <- houseNC[min(grep("minus",houseNC$who)):nrow(houseNC),]
houseNC$state<-"NC"
houseNC$democrat<-"Ross"
houseNC$republican<-"Burr"
houseNC$direction<-ifelse(houseNC$who=="Burr minus Ross","Democrat positive", "Republican positive")
write.csv(houseNC, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-north-dakota-senate-hoeven-vs-glassheim'
#houseND <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseND <- houseND[min(grep("minus",houseND$who)):nrow(houseND),]
#houseND$state<-"ND"
#houseND$democrat<-"Glassheim"
#houseND$republican<-"Hoeven"
#houseND$direction<-ifelse(houseND$who=="Hoeven minus Glassheim","Democrat positive", "Republican positive")
#write.csv(houseND, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-ohio-senate-portman-vs-strickland'
houseOH <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseOH <- houseOH[min(grep("minus",houseOH$who)):nrow(houseOH),]
houseOH$state<-"OH"
houseOH$democrat<-"Strickland"
houseOH$republican<-"Portman"
houseOH$direction<-ifelse(houseOH$who=="Portman minus Strickland","Democrat positive", "Republican positive")
write.csv(houseOH, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-oklahoma-senate-lankford-vs-workman'
#houseOK <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseOK <- houseOK[min(grep("minus",houseOK$who)):nrow(houseOK),]
#houseOK$state<-"OK"
#houseOK$democrat<-"Workman"
#houseOK$republican<-"Lankford"
#houseOK$direction<-ifelse(houseOK$who=="Lankford minus Workman","Democrat positive", "Republican positive")
#write.csv(houseOK, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-oregon-senate-callahan-vs-wyden'
#houseOR <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseOR <- houseOR[min(grep("minus",houseOR$who)):nrow(houseOR),]
#houseOR$state<-"OR"
#houseOR$democrat<-"Wyden"
#houseOR$republican<-"Callahan"
#houseOR$direction<-ifelse(houseOR$who=="Callahan minus Wyden","Democrat positive", "Republican positive")
#write.csv(houseOR, file=paste('house/',chart,'.csv',sep=‘'))

chart <- '2016-pennsylvania-senate-toomey-vs-mcginty'
housePA <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
housePA <- housePA[min(grep("minus",housePA$who)):nrow(housePA),]
housePA$state<-"PA"
housePA$democrat<-"McGinty"
housePA$republican<-"Toomey"
housePA$direction<-ifelse(housePA$who=="Toomey minus McGinty","Democrat positive", "Republican positive")
write.csv(housePA, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-south—carolina-senate-scott-vs-dixon'
#houseSC <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseSC <- houseSC[min(grep("minus",houseSC$who)):nrow(houseSC),]
#houseSC$state<-"SC"
#houseSC$democrat<-"Dixon"
#houseSC$republican<-"Scott"
#houseSC$direction<-ifelse(houseSC$who=="Scott minus Dixon","Democrat positive", "Republican positive")
#write.csv(houseSC, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-south-dakota-senate-thune-vs-williams'
#houseSD <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseSD <- houseSD[min(grep("minus",houseSD$who)):nrow(houseSD),]
#houseSD$state<-"SD"
#houseSD$democrat<-"Williams"
#houseSD$republican<-"Thune"
#houseSD$direction<-ifelse(houseSD$who=="Thune minus Williams","Democrat positive", "Republican positive")
#write.csv(houseSD, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-utah-senate-lee-vs-snow'
houseUT <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseUT <- houseUT[min(grep("minus",houseUT$who)):nrow(houseUT),]
houseUT$state<-"UT"
houseUT$democrat<-"Snow"
houseUT$republican<-"Lee"
houseUT$direction<-ifelse(houseUT$who=="Lee minus Snow","Democrat positive", "Republican positive")
write.csv(houseUT, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016—vermont-senate-milne-vs-leahy'
#houseVT <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseVT <- houseVT[min(grep("minus",houseVT$who)):nrow(houseVT),]
#houseVT$state<-"VT"
#houseVT$democrat<-"Leahy"
#houseVT$republican<-"Milne"
#houseVT$direction<-ifelse(houseVT$who=="Milne minus Leahy","Democrat positive", "Republican positive")
#write.csv(houseVT, file=paste('house/',chart,'.csv',sep=''))

#chart <- '2016-washington-senate-vance-vs-murray'
#houseWA <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
#houseWA <- houseWA[min(grep("minus",houseWA$who)):nrow(houseWA),]
#houseWA$state<-"WA"
#houseWA$democrat<-"Murray"
#houseWA$republican<-"Vance"
#houseWA$direction<-ifelse(houseWA$who=="Vance minus Murray","Democrat positive", "Republican positive")
#write.csv(houseWA, file=paste('house/',chart,'.csv',sep=''))

chart <- '2016-wisconsin-senate-johnson-vs-feingold'
houseWI <- read.csv(paste(dataDir,chart,'/house.csv',sep=''))
houseWI <- houseWI[min(grep("minus",houseWI$who)):nrow(houseWI),]
houseWI$state<-"WI"
houseWI$democrat<-"Feingold"
houseWI$republican<-"Johnson"
houseWI$direction<-ifelse(houseWI$who=="Johnson minus Feingold","Democrat positive", "Republican positive")
write.csv(houseWI, file=paste('house/',chart,'.csv',sep=''))


filenames <- list.files(path="house/", pattern='2016.*csv', full.names=TRUE)
allhouse<-do.call("rbind", lapply(filenames, read.csv, header=TRUE))
allhouse$X.1<-NULL ##deletes defunct case number column
allhouse$X<-NULL  ##deletes the other defunct case number column
allhouse$direction2[allhouse$direction=="Democrat positive"] <- "-1"
allhouse$direction2[allhouse$direction=="Republican positive"] <- "1"
allhouse$direction2 <- as.numeric(allhouse$direction2)
allhouse$est2 <- (allhouse$direction2 * allhouse$est)
allhouse$est2 <- round(allhouse$est2, 2)
allhouse$lo2 <- ifelse(allhouse$direction2 == 1, allhouse$lo, allhouse$direction2 * allhouse$hi)
allhouse$lo2 <- round(allhouse$lo2, 2)
allhouse$hi2 <- ifelse(allhouse$direction2 == 1, allhouse$hi, allhouse$direction2 * allhouse$lo)
allhouse$hi2 <- round(allhouse$hi2, 2)


write.csv(allhouse,"house/allhouse.csv") ##check to make sure everything s right

houseSenate16 <- allhouse[, c("state", "pollster", "est2", "lo2", "hi2", "dev")]

write.csv(houseSenate16, "house/houseSenate16.csv") ##may want to put this in a separate location from the other files.


######################################
#this was for the system -- Jay wrote
######################################

#if (file.exists("/var/www/html/elections")) {
#  write.csv(houseSenate16, "/var/www/html/pollster/shared/models/houseSenate16.csv")
#  write.csv(houseSenate16, paste("/var/www/html/pollster/shared/models/houseSenate16_",today,".csv",sep=""))
#  write.csv(houseSenate16, "/var/www/html/elections/shared/senate_2016/houseSenate16.csv")
#  write.csv(houseSenate16, paste("/var/www/html/elections/shared/senate_2016/houseSenate16_",today,".csv",sep=""))
#}

#if (file.exists("/var/www/html/elections")) {
#  system(paste("mkdir -p /var/www/html/pollster/shared/models/",today,"/house",sep=""))
#  system(paste("cp house/2016-*.csv /var/www/html/pollster/shared/models/",today,"/house/",sep=""))
#  system(paste("cp house/allhouse.csv /var/www/html/pollster/shared/models/",today,"/house/",sep=""))
#  system(paste("cp house/houseSenate16.csv /var/www/html/pollster/shared/models/",today,"/house/",sep=""))
#}
