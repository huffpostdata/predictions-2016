source('poll-average-states.R')

args <- commandArgs(TRUE)

if (length(args) < 5) {
  stop("Example usage: Rscript --vanilla one-state.R AZ 2016-arizona-senate-mccain-vs-kirkpatrick R-Lean Kirkpatrick McCain fast")
}

state_code <- args[1]
chart_slug <- args[2]
cook_rating <- args[3]
dem_label <- args[4]
gop_label <- args[5]
fast <- !is.na(args[6]) && args[6] == 'fast'

frame <- calculate_diff_curve(state_code, chart_slug, cook_rating, dem_label, gop_label, fast)
options(scipen=999)
options(digits=20)
write.table(frame, '', na='', quote=FALSE, sep='\t', row.names=FALSE)
