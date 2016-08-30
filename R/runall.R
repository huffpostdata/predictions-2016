setwd("//Users//najackson14//2016_Senate_model//")
charts <- c(
  #'2016-alabama-senate-shelby-vs-crumpton',
  #'2016-alaska-senate-murkowski-vs-metcalfe',
  '2016-arizona-senate-mccain-vs-kirkpatrick',
  #'2016-arkansas-senate-boozman-vs-eldridge',
  #'2016-california-senate-harris-vs-sanchez', (no reason to run for this -- it will be a dem)
  '2016-colorado-senate-glenn-vs-bennet',
  #'2016-connecticut-senate-carter-vs-blumenthal',
  #'2016-florida-senate-?-vs-?',
  '2016-georgia-senate-isakson-vs-barksdale',
  #'2016-hawaii-senate-carroll-vs-schatz',
  #'2016-idaho-senate-crapo-vs-sturgill',
  #'2016-illinois-senate-kirk-vs-duckworth',
  '2016-indiana-senate-young-vs-bayh',
  '2016-iowa-senate-grassley-vs-judge',
  #'2016-kansas-senate-morgan-vs-wiesner',
  #'2016-kentucky-senate-paul-vs-gray',
  #'2016-louisiana-senate-?-vs-?', #jungle primary
  #'2016-maryland-senate-szeliga-vs-van-hollen',
  '2016-missouri-senate-blunt-vs-kander',
  '2016-nevada-senate-heck-vs-cortez-mastro',
  '2016-new-hampshire-ayotte-vs-hassan',
  '2016-new-york-senate-long-vs-schumer',
  '2016-north-carolina-senate-burr-vs-ross',
  #'2016-north-dakota-senate-hoeven-vs-glassheim',
  '2016-ohio-senate-portman-vs-strickland',
  #'2016-oklahoma-senate-lankford-vs-workman',
  #'2016-oregon-senate-callahan-vs-wyden',
  '2016-pennsylvania-senate-toomey-vs-mcginty',
  #'2016-south-carolina-senate-scott-vs-dixon',
  #'2016-south-dakota-senate-thune-vs-williams',
  '2016-utah-senate-lee-vs-snow',
  #'2016-vermont-senate-milne-vs-leahy',
  #'2016-washington-senate-vance-vs-murray',
  '2016-wisconsin-senate-johnson-vs-feingold'
)

for (c in charts) {
  system(paste("Rscript poll-average-states.R '",c,"'",sep=''))
}

system("Rscript postprocessing.R") 
#system("Rscript house-effects.R") 

