source('poll-average-states.R')

input_senate_races_path <- '../data/sheets/input/senate-races.tsv'
output_senate_curves_path <- '../data/sheets/output/senate-curves.tsv'
output_senate_seat_counts_path <- '../data/sheets/output/senate-seat-counts.tsv'
output_senate_samples_path <- '../data/sheets/output/senate-samples-STATE'

NMonteCarloSimulations <- 1e8
ElectionDay <- as.Date('2016-11-08')

args <- commandArgs(TRUE)
fast <- !is.na(args[1]) && args[1] == 'fast'

if (fast) NMonteCarloSimulations <- 1e6

load_or_calculate_senate_data_for_race <- function(race) {
  if (!dir.exists('interim-results')) {
    dir.create('interim-results', recursive=TRUE)
  }
  write('This directory exists just so all-states.R can resume expensive calculations.\n\nDelete this directory and all its contents whenever you want to start an all-states.R run from scratch.', file='interim-results/README')

  file_path <- paste0('interim-results/', race$state, '.RData')

  data <- NA
  tryCatch({
    load(file_path)
  }, error = function(e) {
    data <<- calculate_diff_data(
      race$state,
      race$pollster_slug,
      race$cook_rating,
      race$dem_label,
      race$gop_label,
      fast
    )
    save(data, file=file_path)
  })

  return(data)
}

calculate_dem_win_prob_with_undecided <- function(curves) {
  undecided <- ifelse(is.na(curves$undecided_xibar), 0.0, curves$undecided_xibar)
  spread <- ifelse(is.na(curves$diff_xibar), 0.0, curves$diff_xibar)
  original_prob <- curves$dem_win_prob

  # if Dem winning, then adjustment is -; if GOP winning, +
  raw_adjustment <- ifelse(spread == 0.0, 0.0, -undecided / spread)

  # never adjust probability by more than 10%
  clamped_adjustment <- pmax(-0.1, pmin(0.1, raw_adjustment))

  # never flip probability
  new_prob <- ifelse(
    original_prob >= .5,
    pmax(.5, original_prob + clamped_adjustment),
    pmin(.5, original_prob + clamped_adjustment)
  )

  return(new_prob)
}

load_or_calculate_senate_data_for_races <- function(races) {
  races_lists <- apply(races, 1, as.list)
  names(races_lists) <- races$state

  data_list <- lapply(races_lists, load_or_calculate_senate_data_for_race)

  curves_list <- lapply(data_list, function(x) x$curve)
  curves <- do.call(rbind, curves_list)

  state_samples_strings <- lapply(data_list, function(x) x$samples_string)

  return(list(curves=curves,state_samples_strings=state_samples_strings))
}

# Monte-Carlo simulation: run lots of election nights for the senate and return
# the distribution of seats won by Democrats -- e.g., c(1, 2, 400, 30, ...)
# means zero seats won by Dems 1 time; one seat won 2 times; two seats won 400
# times; etc.
predict_n_dem_senate_seats <- function(dem_win_probs) {
  cat('Running', NMonteCarloSimulations, 'senate simulations...\n')

  n_seats <- length(dem_win_probs)

  # 1 -> 0 seats won; 2 -> 1 seat won; etc.
  n_seat_event_counts <- rep(0, n_seats + 1)

  for (n in 1:NMonteCarloSimulations) {
    random_numbers <- runif(n=n_seats)
    n_won <- sum(dem_win_probs > random_numbers)
    index = n_won + 1
    n_seat_event_counts[index] <- n_seat_event_counts[index] + 1
  }

  return(n_seat_event_counts)
}

dump_senate_curves <- function(curves) {
  # Yay, R. format(data$curves) would round digits but show "NA". Plain
  # write.table() would hide "NA" but not round digits. The only way to both
  # hide "NA" and round things is to set global options.
  options(scipen=999)
  options(digits=6)
  write.table(curves, file=output_senate_curves_path, quote=FALSE, sep='\t', row.names=FALSE, na='')
}

dump_senate_samples <- function(state_samples_strings) {
  for (state_code in names(state_samples_strings)) {
    samples_string <- state_samples_strings[[state_code]]
    filename <- sub('STATE', state_code, output_senate_samples_path)
    write(samples_string, file=filename)
  }
}

dump_senate_seat_counts <- function(seat_counts) {
  frame <- data.frame(
    date=rep(ElectionDay, length(seat_counts)),
    n_dem=0:(length(seat_counts) - 1),
    n=seat_counts,
    p=(seat_counts / sum(seat_counts))
  )

  write.table(format(frame, digits=6), file=output_senate_seat_counts_path, quote=FALSE, sep='\t', row.names=FALSE)
}

run_all_senate <- function() {
  races <- read.table(input_senate_races_path, header=TRUE, sep='\t')

  senate_data <- load_or_calculate_senate_data_for_races(races)
  senate_curves <- senate_data$curves

  dump_senate_curves(senate_curves)

  dump_senate_samples(senate_data$state_samples_strings)

  election_day_seat_probabilities = c(senate_curves[senate_curves$date==ElectionDay,'dem_win_prob_with_undecided'])
  n_dem_seats <- predict_n_dem_senate_seats(election_day_seat_probabilities)
  dump_senate_seat_counts(n_dem_seats)
}

main <- function() {
  run_all_senate()
}

main()
