source('../common/calculate-diff-data.R')

args <- commandArgs(TRUE)

if (length(args) < 3) {
  stop("Example usage: Rscript --vanilla one-state.R AZ 2016-arizona-senate-mccain-vs-kirkpatrick R-Lean fast")
}

state_code <- args[1]
chart_slug <- args[2]
cook_rating <- args[3]
fast <- !is.na(args[4]) && args[4] == 'fast'

frame <- CalculateDiffData(state_code, 'president', chart_slug, cook_rating, 'Clinton', 'Trump', fast)
options(scipen=999)
options(digits=20)
write.table(frame$curve, '', na='', quote=FALSE, sep='\t', row.names=FALSE)
