source('../common/calculate-diff-data.R')

options(stringsAsFactors=FALSE)
args <- commandArgs(TRUE)
chart <- args[1]
dataDir <- paste0("data/",chart)
dir.create(dataDir, showWarnings=FALSE, recursive=TRUE)

races <- read.csv('../../data/sheets/input/president-races.tsv', sep='\t')
race <- races[races$pollster_slug == chart, ]

data <- CalculateDiffData(race$state_code, 'president', chart, race$cook_rating, 'Clinton', 'Trump', TRUE)

source('./dump-curve.R')
