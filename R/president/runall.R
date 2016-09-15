#setwd("//Users//najackson14//Pres-model-current//")
charts <- c(
  #'2016-alabama-president-trump-vs-clinton',
  #'2016-alaska-president-trump-vs-clinton',
	'2016-arizona-president-trump-vs-clinton',
  #'2016-arkansas-president-trump-vs-clinton',
	'2016-california-presidential-general-election-trump-vs-clinton', 
	'2016-colorado-president-trump-vs-clinton',
  #'2016-connecticut-president-trump-vs-clinton',
  #'2016-delaware-president-trump-vs-clinton',
	'2016-florida-presidential-general-election-trump-vs-clinton',
	'2016-georgia-president-trump-vs-clinton',
  #'2016-hawaii-president-trump-vs-clinton',
  #'2016-idaho-president-trump-vs-clinton',
  	'2016-illinois-president-trump-vs-clinton',
  #'2016-indiana-president-trump-vs-clinton',
	'2016-iowa-president-trump-vs-clinton',
  	'2016-kansas-president-trump-vs-clinton',
  #'2016-kentucky-president-trump-vs-clinton',
  #'2016-louisiana-president-trump-vs-clinton', 
  #'2016-maine-president-trump-vs-clinton',
  	'2016-maryland-president-trump-vs-clinton',
  #'2016-massachusetts-president-trump-vs-clinton',
	'2016-michigan-president-trump-vs-clinton',
  #'2016-minnesota-president-trump-vs-clinton',
  #'2016-mississippi-president-trump-vs-clinton',
	'2016-missouri-president-trump-vs-clinton',
  #'2016-montana-president-trump-vs-clinton',
  #'2016-nebraska-president-trump-vs-clinton',
	'2016-nevada-president-trump-vs-clinton',
	'2016-new-hampshire-president-trump-vs-clinton',
	'2016-new-jersey-president-trump-vs-clinton',
  #'2016-new-mexico-president-trump-vs-clinton',
	'2016-new-york-president-trump-vs-clinton',
	'2016-north-carolina-president-trump-vs-clinton',
  #'2016-north-dakota-president-trump-vs-clinton',
	'2016-ohio-president-trump-vs-clinton',
  #'2016-oklahoma-president-trump-vs-clinton',
  	'2016-oregon-president-trump-vs-clinton',
  	'2016-pennsylvania-president-trump-vs-clinton',
  #'2016-rhode-island-president-trump-vs-clinton',
  	'2016-south-carolina-president-trump-vs-clinton',
  #'2016-south-dakota-president-trump-vs-clinton',
  #'2016-tennessee-president-trump-vs-clinton',
  	'2016-texas-president-trump-vs-clinton',
	'2016-utah-president-trump-vs-clinton',
  #'2016-vermont-president-trump-vs-clinton',
	'2016-virginia-president-trump-vs-clinton',
  #'2016-washington-president-trump-vs-clinton',
  #'2016-washington-dc-president-trump-vs-clinton',
  #'2016-west-virginia-president-trump-vs-clinton',
	'2016-wisconsin-president-trump-vs-clinton'
  #'2016-wyoming-president-trump-vs-clinton',
)

for (c in charts) {
  system(paste("Rscript poll-average-states.R '",c,"'",sep=''))
}

system("RScript poll-average-natl2016.R")
system("Rscript postprocessing-pres.R") 
#system("Rscript houseeff-pres.R") 
#system("Rscript pointests.R") 

