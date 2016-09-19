library('parallel')

source('../common/calculate-diff-data.R')

args <- commandArgs(TRUE)
fast <- !is.na(args[1]) && args[1] == 'fast'

input_president_races_path <- '../../data/sheets/input/president-races.tsv'
output_dir <- Sys.getenv('OUTPUT_DIR')
output_dir <- ifelse(output_dir != '', output_dir, '../../data/sheets/output')
output_president_curves_path <- paste0(output_dir, '/president-curves.tsv')
output_president_vote_counts_path <- paste0(output_dir, '/president-vote-counts.tsv')
output_president_summaries_path <- paste0(output_dir, '/president-summaries.tsv')
output_president_samples_path <- paste0(output_dir, '/president-samples-STATE')

NMonteCarloSimulations <- 1e8
EndDate <- as.Date('2016-11-08')

if (fast) NMonteCarloSimulations <- 1e6

load_or_calculate_president_data_for_race <- function(race) {
  if (!dir.exists('interim-results')) {
    dir.create('interim-results', recursive=TRUE)
  }
  write('This directory exists just so all-states.R can resume expensive calculations.\n\nDelete this directory and all its contents whenever you want to start an all-states.R run from scratch.', file='interim-results/README')

  file_path <- paste0('interim-results/', race$state_code, '.RData')

  data <- NA
  tryCatch({
    load(file_path)
  }, error = function(e) {
    data <<- CalculateDiffData(
      race$state_code,
      'president',
      race$pollster_slug,
      race$cook_rating,
      'Clinton',
      'Trump',
      fast
    )
    data$race <- race
    save(data, file=file_path)
  })

  return(data)
}

load_or_calculate_national_president_data <- function() {
  file_path <- paste0('interim-results/US.RData')

  data <- NA
  tryCatch({
    load(file_path)
  }, error = function(e) {
    filter_polls <- function(polls) {
      include_list = c(read.table('include-list.txt', sep='\n', header=FALSE, as.is='V1')$V1)

      return(polls$pollster %in% include_list)
    }

    data <<- CalculateDiffData(
      'US',
      'president',
      '2016-general-election-trump-vs-clinton',
      'US',
      'Clinton',
      'Trump',
      fast,
      filter_polls
    )

    save(data, file=file_path)
  })

  return(data$curve)
}

calculate_race_summary <- function(race, national) {
  Today <- Sys.Date()

  curve <- race$curve

  today <- curve[curve$date == Today, c('diff_xibar', 'undecided_xibar')]
  end_prob <- curve[curve$date == EndDate, c('dem_win_prob')]

  if (nrow(today) == 0) {
    # This is a stub. Ignore all our cool calculations.
    return(list(
      state_code=c(race$race$state_code),
      n_electoral_votes=c(as.integer(race$race$n_electoral_votes)),
      dem_win_prob=c(end_prob),
      national_dem_win_prob=NA,
      national_delta=NA,
      national_adjustment=NA,
      dem_win_prob_with_adjustment=NA,
      undecided_margin=NA,
      dem_win_prob_with_adjustment_and_undecided=c(end_prob)
    ))
  }

  # How much we move towards 0.5. For instance: if today is 0.75 (Dem) and
  # election day is 0.65, we move 0.1 towards 0.5; national_delta <- -0.1. For
  # 0.25 -> 0.35 (which is equivalent to 0.75 GOP -> 0.65),
  # national_delta <- 0.1.
  #
  # This measures our national uncertainty stemming from the distance between
  # today and election day.
  national_today_prob <- national[national$date == Today, c('dem_win_prob')]
  national_end_prob <- national[national$date == EndDate, c('dem_win_prob')]
  national_delta <- abs(national_end_prob - 0.5) - abs(national_today_prob - 0.5)

  # Adjust based on uncertainty and correlation.
  #
  # MS, with correlation -0.55, tends to vote _more_ Republican when national
  # polls are _more_ Democratic. OH, with correlation 0.74, votes _more_
  # Democratic when national polls are more Democratic.
  #
  # Examples:
  #   national_delta -0.1 (meaning national leans Dem) -> move MS prob -0.055
  #                       and move OH prob +0.074.
  #   national_delta 0.1 (meaning national leans GOP) -> move MS prob +0.055
  #                      and move OH prob -0.074.
  national_correlation <- as.double(race$race$national_dem_correlation)
  adjustment <- -(national_delta) * national_correlation # + -> lean Dem; - -> lean GOP

  prob_with_adjustment <- max(0.0, min(1.0, ifelse(
    end_prob >= 0.5,
    max(0.5, end_prob + adjustment),
    min(0.5, end_prob + adjustment)
  )))

  undecided_margin <- min(0.1, abs(today$undecided_xibar / today$diff_xibar / 100))

  prob_with_adjustment_and_undecided <- ifelse(
    prob_with_adjustment >= 0.5,
    max(0.5, prob_with_adjustment - undecided_margin),
    min(0.5, prob_with_adjustment + undecided_margin)
  )

  return(list(
    state_code=c(race$race$state_code),
    n_electoral_votes=c(as.integer(race$race$n_electoral_votes)),
    dem_win_prob=c(end_prob),
    national_dem_win_prob=c(national_end_prob),
    national_delta=c(national_delta),
    national_adjustment=c(adjustment),
    dem_win_prob_with_adjustment=c(prob_with_adjustment),
    undecided_margin=c(undecided_margin),
    dem_win_prob_with_adjustment_and_undecided=c(prob_with_adjustment_and_undecided)
  ))
}

calculate_race_summaries <- function(races, national) {
  lists <- lapply(
    races,
    FUN=function(race) data.frame(calculate_race_summary(race, national))
  )

  frame <- do.call(rbind, lists)

  return(frame)
}

load_or_calculate_president_data_for_races <- function(races) {
  races_lists <- apply(races, 1, as.list)
  names(races_lists) <- races$state_code

  data_list <- mclapply(
    races_lists,
    FUN=load_or_calculate_president_data_for_race,
    mc.cores=min(4, detectCores())
  )

  national <- load_or_calculate_national_president_data()

  curves_list <- lapply(data_list, function(x) x$curve)
  curves <- do.call(rbind, curves_list)

  summaries <- calculate_race_summaries(data_list, national)

  state_samples_strings <- lapply(data_list, function(x) x$samples_string)

  return(list(
    curves=curves,
    summaries=summaries,
    state_samples_strings=state_samples_strings
  ))
}

# Monte-Carlo simulation: run lots of election nights for the president and
# return the distribution of electoral votes won by Democrats -- e.g.,
# c(1, 2, 400, 30, ...) means zero votes won by Dems 1 time; one vote won 2
# times; two votes won 400 times; etc.
#
# The output vector always size 539.
predict_n_dem_president_votes <- function(summaries) {
  cat('Running', NMonteCarloSimulations, 'president simulations...\n')

  n_states <- nrow(summaries)
  win_prob <- summaries$dem_win_prob_with_adjustment_and_undecided
  win_n_votes <- summaries$n_electoral_votes

  # 1 -> 0 votes; 2 -> 1 vote; etc.
  n_counts <- rep(0, 539)

  for (n in 1:NMonteCarloSimulations) {
    random_numbers <- runif(n=n_states)
    n_votes <- sum((win_prob > random_numbers) * win_n_votes)
    index <- n_votes + 1
    n_counts[index] <- n_counts[index] + 1
  }

  return(n_counts)
}

dump_president_curves <- function(curves) {
  # Yay, R. format(data$curves) would round digits but show "NA". Plain
  # write.table() would hide "NA" but not round digits. The only way to both
  # hide "NA" and round things is to set global options.
  options(scipen=999)
  options(digits=6)
  write.table(curves, file=output_president_curves_path, quote=FALSE, sep='\t', row.names=FALSE, na='')
}

dump_president_samples <- function(state_samples_strings) {
  for (state_code in names(state_samples_strings)) {
    samples_string <- state_samples_strings[[state_code]]
    filename <- sub('STATE', state_code, output_president_samples_path)
    write(samples_string, file=filename)
  }
}

dump_president_summaries <- function(summaries) {
  # See dump_president_curves() for musings on this
  options(scipen=999)
  options(digits=6)
  write.table(summaries, file=output_president_summaries_path, quote=FALSE, sep='\t', row.names=FALSE, na='')
}

dump_president_vote_counts <- function(vote_counts) {
  frame <- data.frame(
    date=rep(EndDate, length(vote_counts)),
    n_dem=0:(length(vote_counts) - 1),
    n=vote_counts,
    p=(vote_counts / sum(vote_counts))
  )

  write.table(format(frame, digits=6), file=output_president_vote_counts_path, quote=FALSE, sep='\t', row.names=FALSE)
}

run_all_president <- function() {
  races <- read.table(input_president_races_path, header=TRUE, sep='\t')

  president_data <- load_or_calculate_president_data_for_races(races)
  president_curves <- president_data$curves

  dump_president_curves(president_curves)
  dump_president_samples(president_data$state_samples_strings)
  dump_president_summaries(president_data$summaries)

  n_dem_votes <- predict_n_dem_president_votes(president_data$summaries)
  dump_president_vote_counts(n_dem_votes)
}

main <- function() {
  run_all_president()
}

main()
