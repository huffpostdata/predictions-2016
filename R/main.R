source('poll-average-states.R')

input_senate_races_path <- '../data/sheets/input/senate-races.tsv'
output_senate_curves_path <- '../data/sheets/output/senate-curves-DATE.tsv'
output_senate_house_effects_path <- '../data/sheets/output/senate-house-effects-DATE.tsv'

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

load_or_calculate_senate_data_for_races_and_date <- function(races, last_date) {
  totals <- load_or_calculate_senate_data_for_race_and_date(races[1,], last_date)

  for (i in 2:nrow(races)) {
    race <- races[i,]
    row <- load_or_calculate_senate_data_for_race_and_date(race, last_date)
    totals$curves <- rbind(totals$curves, row$curves)
    totals$house_effects <- rbind(totals$house_effects, row$house_effects)
  }

  return(totals)
}

dump_senate_data_for_date <- function(data, last_date) {
  curves_path <- sub('DATE', last_date, output_senate_curves_path)
  house_effects_path <- sub('DATE', last_date, output_senate_house_effects_path)

  write.table(format(data$curves, digits=4), file=curves_path, quote=FALSE, sep='\t', row.names=FALSE, na='')
  write.table(format(data$house_effects, digits=4), file=house_effects_path, quote=FALSE, sep='\t', row.names=FALSE, na='')
}

run_all_senate_for_date <- function(last_date) {
  races <- read.table(input_senate_races_path, header=TRUE, sep='\t')
  senate_data <- load_or_calculate_senate_data_for_races_and_date(races, last_date)
  dump_senate_data_for_date(senate_data, last_date)
}

run_all_senate <- function() {
  run_all_senate_for_date(Sys.Date())
}

main <- function() {
  run_all_senate()
}

main()
