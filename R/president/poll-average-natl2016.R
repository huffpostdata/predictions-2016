source('../common/calculate-diff-data.R')

chart <- '2016-general-election-trump-vs-clinton'
dataDir <- paste0("data/",chart)
dir.create(dataDir, showWarnings=FALSE, recursive=TRUE)

filter_polls <- function(polls) {
  include_list = c(read.table('include-list.txt', sep='\n', header=FALSE, as.is='V1')$V1)

  return(polls$pollster %in% include_list)
}

data <- CalculateDiffData('US', 'president', chart, 'US', 'Clinton', 'Trump', TRUE, filter_polls=filter_polls)

source('./dump-curve.R')
