# Included by poll-average-states.R and poll-average-natl2016.R
curve <- data$curve
out_undecided <- data.frame(
  who=rep('Undecided', times=nrow(curve)),
  date=curve$date,
  xibar=100 * curve$undecided_xibar,
  lo=100 * curve$undecided_xibar,
  up=100 * curve$undecided_xibar,
  prob=NA
)
out_diff <- data.frame(
  who=rep('Trump minus Clinton', times=nrow(curve)),
  date=curve$date,
  xibar=100 * -curve$diff_xibar,
  lo=100 * -curve$diff_high,
  up=100 * -curve$diff_low,
  prob=100 * (1.0 - curve$dem_win_prob)
)

write.csv(rbind(out_undecided, out_diff), file=paste0(dataDir, '/out.csv'))
