source('poll-average-states.R')

input_senate_races_path <- '../data/sheets/input/senate-races.tsv'
output_senate_curves_path <- '../data/sheets/output/senate-curves-DATE.tsv'
output_senate_house_effects_path <- '../data/sheets/output/senate-house-effects-DATE.tsv'
output_senate_seats_path <- '../data/sheets/output/senate-seat-counts-DATE.tsv'

NMonteCarloSimulations <- 1e8
ElectionDay <- as.Date('2016-11-08')
Today <- sys.Date()

calculate_senate_data_for_race_and_date <- function(race, last_date) {
  return(calculate_dem_gop_curves(
    race$state,
    race$cook_rating,
    race$pollster_slug,
    race$dem_label,
    race$gop_label,
    last_date
  ))
}

load_or_calculate_senate_data_for_race_and_date <- function(race, last_date) {
  file_dir <- paste0('tmp/', last_date)
  if (!dir.exists(file_dir)) {
    dir.create(file_dir, recursive=TRUE)
  }

  file_path <- paste0(file_dir, '/', race$state, '.RData')

  data <- NA
  tryCatch({
    load(file_path)
  }, error = function(e) {
    data <<- calculate_senate_data_for_race_and_date(race, last_date)
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

load_or_calculate_senate_data_for_races_and_date <- function(races, last_date) {
  totals <- load_or_calculate_senate_data_for_race_and_date(races[1,], last_date)

  for (i in 2:nrow(races)) {
    race <- races[i,]
    row <- load_or_calculate_senate_data_for_race_and_date(race, last_date)
    totals$curves <- rbind(totals$curves, row$curves)
    totals$house_effects <- rbind(totals$house_effects, row$house_effects)
  }

  totals$curves$dem_win_prob_with_undecided <- calculate_dem_win_prob_with_undecided(totals$curves)

  return(totals)
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
    n_seat_event_counts[n_won] <- n_seat_event_counts[n_won] + 1
  }

  return(n_seat_event_counts)
}

dump_senate_data_for_date <- function(data, last_date) {
  curves_path <- sub('DATE', last_date, output_senate_curves_path)
  house_effects_path <- sub('DATE', last_date, output_senate_house_effects_path)

  write.table(format(data$curves, digits=4), file=curves_path, quote=FALSE, sep='\t', row.names=FALSE, na='')
  write.table(format(data$house_effects, digits=4), file=house_effects_path, quote=FALSE, sep='\t', row.names=FALSE, na='')
}

dump_senate_seat_counts <- function(seat_counts, last_date) {
  frame <- data.frame(
    date=rep(ElectionDay, length(seat_counts)),
    n_dem=0:(length(seat_counts) - 1),
    n=seat_counts,
    p=(seat_counts / sum(seat_counts))
  )

  seat_counts_path <- sub('DATE', last_date, output_senate_seats_path)
  write.table(format(frame, digits=6), file=seat_counts_path, quote=FALSE, sep='\t', row.names=FALSE, na='')
}

run_all_senate_for_date <- function(last_date) {
  races <- read.table(input_senate_races_path, header=TRUE, sep='\t')
  senate_data <- load_or_calculate_senate_data_for_races_and_date(races, last_date)
  dump_senate_data_for_date(senate_data, last_date)

  election_day_seat_probabilities = c(senate_data$curves[senate_data$curves$date==ElectionDay,'dem_win_prob_with_undecided'])
  n_dem_seats <- predict_n_dem_senate_seats(election_day_seat_probabilities)
  dump_senate_seat_counts(n_dem_seats, last_date)
}

run_all_senate <- function() {
  run_all_senate_for_date(Today)
}

main <- function() {
  run_all_senate()
}

main()
