source('../common/calculate-diff-data.R')

chart <- '2016-general-election-trump-vs-clinton'
dataDir <- paste0("data/",chart)
dir.create(dataDir, showWarnings=FALSE, recursive=TRUE)

data <- CalculateDiffData('US', 'president', chart, 'US', 'Clinton', 'Trump', TRUE)

source('./dump-curve.R')
