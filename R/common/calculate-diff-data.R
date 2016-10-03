CookPriors.senate <- data.frame(
  rating=c('D-Solid', 'D-Likely', 'D-Lean', 'Toss Up', 'R-Lean', 'R-Likely', 'R-Solid'),
  prior1=c(0.4823, 0.4881, 0.4865, 0.4792, 0.4746, 0.4879, 0.4783),
  prior2=c(0.1584, 0.1205, 0.0706, 0.0619, 0.0824, 0.0824, 0.1807),
  dem_win_prob=c(0.9877, 0.9333, 0.8095, 0.5, 1.0 - 0.8095, 1.0 - 0.9333, 1.0 - 0.9877),
  mean=c(NA, NA, NA, NA, NA, NA, NA),
  stddev=c(NA, NA, NA, NA, NA, NA, NA)
)
CookPriors.president <- data.frame(
  rating=c('D-Solid', 'D-Likely', 'D-Lean', 'Toss Up', 'R-Lean', 'R-Likely', 'R-Solid', 'US'),
  prior1=c(0.4915, 0.4862, 0.4925, 0.4927, 0.4931, 0.4933, 0.4906, 0.47),
  prior2=c(0.1603, 0.0632, 0.0497, 0.0233, 0.0599, 0.0614, 0.1246, 0.05),
  dem_win_prob=c(0.9975, 0.9490, 0.8565, 0.5, 1.0 - 0.8565, 1.0 - 0.9490, 1.0 - 0.9975, NA),
  mean=c(0.2955, 0.2370, 0.1286, 0.0106, -0.0660, -0.1066, -0.2895, NA),
  stddev=c(0.0695, 0.0542, 0.0272, 0.06475, 0.06745, 0.0584, 0.0741, NA)
)

CalculateDiffData <- function(
    state_code, senate_or_president, chart_slug, cook_rating,
    dem_label, gop_label, fast,
    filter_polls=NULL,
    today=NULL, startDate=NULL, endDate=NULL, outputStartDate=NULL
) {
  # Uses an MCMC model to calculate a list(curve, samples_string)
  #
  # Args:
  #   state_code: two-letter state code that we'll add to the curve
  #   senate_or_president: either 'senate' or 'president' (determines Cook constants)
  #   chart_slug: slug we'll query Pollster for. If empty, we'll use cook_rating instead
  #   cook_rating: Cook rating: one of {D-Solid,D-Likely,D-Lean,Toss Up,R-Lean,R-Likely,R-Solid} (or 'US' for presidential)
  #   dem_label: Democrat's label on the chart (e.g., "Clinton")
  #   gop_label: Republican's label on the chart (e.g., "Trump")
  #   fast: if true, don't run the MCMC model long enough (useful for debugging)
  #   include_poll: NULL, or function that takes a data.frame of polls and outputs TRUE for rows that should be included
  #   today: date after which we don't know anything (default Sys.Date())
  #   startDate: date our simulation begins (default Jan. 1)
  #   endDate: date our simulation ends (default election day)
  #   outputStartDate: first date we return in our data.frame (default Jul. 1)
  #
  # Returns:
  #   a list(curve, samples_string).
  #   curve: a data.frame with:
  #     state: state_code, repeated.
  #     date: anything from startDate to endDate. When chart_slug is empty,
  #           only endDate will be present. Otherwise, we return every day.
  #     diff_xibar: Average Dem fraction minus GOP fraction, [-1.0, 1.0]
  #     diff_stddev: stddev on the diff
  #     undecided_xibar: Average "Undecided" fraction
  #     dem_win_prob: fraction of simulations in which Dem beat GOP on this date
  #     dem_win_prob_with_undecided: ditto, modulo an "undecided" calculation
  #   samples_string: a string of hex integers meant to be read by our JS backend

  ####################
  # Variables, for quick tweaking

  McmcParams <- list(
    fast=list(
      n_iterations=1000,
      n_samples=1000,
      n_chains=4,
      n_pre_monitor_iterations=1000
    ),
    slow=list(
      n_iterations=100000,
      n_samples=5000,
      n_chains=4,
      n_pre_monitor_iterations=20000
    )
  )

  if (is.null(startDate)) {       startDate <- as.Date('2016-01-01') }
  if (is.null(endDate)) {         endDate <- as.Date('2016-11-08') }
  if (is.null(today)) {           today <- Sys.Date() }
  if (is.null(outputStartDate)) { outputStartDate <- as.Date('2016-07-01') }

  nDates <- as.integer(endDate - startDate + 1)

  MinNPollsForModel <- 5
  MinNPollsForOutput <- 2
  NOutputSamples <- 200 # 1,000 looks cluttered
  Uint16Factor <- 2**16 - 1 # to convert [0.0,1.0] fractions to [0, 65536) 16-bit integers

  if (senate_or_president == 'senate') {
    CookPriors <- CookPriors.senate
  } else {
    CookPriors <- CookPriors.president
  }

  #################
  # Functions we'll use in our main code
  # (Search for "Method starts here" to jump to where we use them)

  calculate_labels <- function(col_names) {
    last_choice_index <- match('poll_id', col_names) - 1
    return(col_names[1:last_choice_index])
  }

  ## object for jags
  makeJagsObject <- function(data, thePollsters, who) {
    responses <- data[!is.na(data[[who]]),c('start_date', 'end_date', 'nobs_truncated', 'pp', who)]
    responses$n_days <- as.integer(responses$end_date - responses$start_date + 1)

    responses$y <- responses[[who]] / 100
    responses$prec <- responses$nobs_truncated / (responses$y * (1 - responses$y))
    responses$j <- match(responses$pp, thePollsters)

    pollList <- data.frame(
      y=rep(responses$y, responses$n_days),
      j=rep(responses$j, responses$n_days),
      prec=rep(responses$prec / responses$n_days, responses$n_days),
      date=rep(responses$start_date - startDate, responses$n_days) + sequence(responses$n_days)
    )

      forJags <- as.list(pollList)
      forJags$NOBS <- nrow(pollList)
      forJags$NHOUSES <- length(thePollsters)
      forJags$NPERIODS <- nDates

      ## prior for house effects
      forJags$d0 <- rep(0,forJags$NHOUSES)
      delta.prior.sd <- .025
      delta.prior.prec <- (1/delta.prior.sd)^2
      forJags$D0 <- diag(rep(delta.prior.prec,forJags$NHOUSES))

      return(forJags)
  }

  makeInits <- function(forJags, cookPrior1, cookPrior2) {
      sigma <- runif(n=1, 0, 0.003)
      xi <- rep(NA, nDates)
      xi[1] <- rnorm(n=1, cookPrior1,cookPrior2)
      for (i in 2:nDates) {
          xi[i] <- rnorm(n=1,xi[i-1],sd=sigma)
      }
      xi.bad <- xi < .01
      xi[xi.bad] <- .01
      xi.bad <- xi > .99
      xi[xi.bad] <- .99


      ## house effect delta inits
      delta <- rnorm(n=forJags$NHOUSES,mean=0,sd=.02)
      out <- list(xi.raw=xi,sigma=sigma,delta.raw=delta)
      return(out)
  }

  # Turns the mcmc.list from a JAGS model into a proper Array of xi values.
  #
  # The first dimension is the "iteration" number. The second is the date, as a
  # character.
  #
  # "iteration" here is a loose term. Remember that the input is a mcmc.list
  # object: it has C chains, and each chain has I iterations. An output
  # "iteration" i means "chain floor(i/C), iteration i%%C". (We don't care which
  # chain a given value comes from.
  mcmc_list_to_xi_array <- function(mcmc_list) {
      # 3D array: [iteration,date (as integer),chain number]
      iter_date_chain <- as.array(mcmc_list)

      # Filter out the dates we don't care about
      iter_date_chain <- iter_date_chain[,(outputStartDate - startDate + 1):nDates, ]

      # Clamp: caller expects [0, 1] but the JAGS model doesn't guarantee it
      iter_date_chain <- pmin(pmax(iter_date_chain, 0.0), 1.0)

      # Transpose so chain and iter are together
      ret <- aperm(iter_date_chain, c(1, 3, 2))

      # Cast as a 2D array instead of a 3D array
      dim(ret) <- c(dim(ret)[1] * dim(ret)[2], dim(ret)[3])

      # Set the dims: we're going by date
      dateSeq <- as.character(seq.Date(from=outputStartDate, to=endDate, by='day'))

      dimnames(ret) <- list(iteration=NULL, date=dateSeq)

      #save('ret', file='debug.RData')

      return(ret)
  }

  # Builds a 3D array of xi results, normalized.
  #
  # Array format:
  #
  #     arr[,,'2016-08-04']: results for Aug. 4
  #     arr['McCain',,]: results for McCain
  #     arr[,1,]: results for one "iteration"
  #
  # In other words, arr[,1,'2016-08-04'] pulls one xi value from each entry in
  # candidate_xis and normalizes so they all add up to 1.0.
  build_normalized_array <- function(candidate_xis) {
      # All candidate_xi arrays have the same dims; make a big, 3D array
      arr <- array(
        unlist(candidate_xis),
        dim=c(dim(candidate_xis[[1]]), length(candidate_xis))
      )
      dimnames(arr) <- list(
        iteration=NULL,
        date=dimnames(candidate_xis[[1]])[[2]],
        who=names(candidate_xis)
      )

      # move candidate values next to each other in each date+iter
      # reuse variable name to save memory
      arr <- aperm(arr, c(3, 1, 2))

      normalized <- apply(arr, c('iteration', 'date'), function(x) x/sum(x, na.rm=TRUE))

      return(normalized)
  }

  # Builds a data.frame with average results by date for the given choice.
  #
  # Example usage:
  #
  #     frame <- build_choice_frame(arr, 'Undecided', list(undecided_xibar='mean'))
  #
  # Parameters:
  #
  # normalized_array: see build_normalized_array()
  # choice: one of the choices in the normalized_array
  # columns_list: desired column names and what they mean. List indexes are
  #               column names in the output frame. Values are their meanings.
  #               Possibilities are 'diff' and 'sd'.
  build_choice_frame <- function(normalized_array, choice, columns_list) {
    xi <- normalized_array[choice,,]

    dates <- as.Date(dimnames(xi)[['date']])

    ret <- data.frame(date=dates)
    for (index in names(columns_list)) {
      name = columns_list[[index]]

      if (name == 'mean') {
        values <- apply(xi, 'date', mean)
      } else if (name == 'sd') {
        values <- apply(xi, 'date', sd)
      } else {
        stop('name must be "mean" or "sd"')
      }

      ret[[index]] = values
    }

    return(ret)
  }

  #################################################
  ## difference function
  diffSummary <- function(normalized_array, dem_who, gop_who) {
    diff_array <- normalized_array[dem_who,,] - normalized_array[gop_who,,]

    averages <- apply(diff_array, 'date', function(x) c(
      mean(x),
      sd(x),
      mean(x > 0)
    ))

    dimnames(averages)[[1]] <- c('mean', 'stddev', 'prob')

    return(data.frame(
      date=as.Date(dimnames(averages)$date),
      diff_xibar=averages['mean',],
      diff_stddev=averages['stddev',],
      dem_win_prob=averages['prob',]
    ))
  }

  # Given vectors of win probabilities, spreads and undecided counts, return
  # probabilities shifted towards 0.5, with higher undecideds leading to larger
  # shifts.
  center_probability_with_undecided <- function(dem_win_prob, diff_xibar, undecided_xibar) {
    # for days after today, undecided_xibar should use today's value
    today <- as.integer(today - outputStartDate + 1)
    undecided_xibar[today:length(undecided_xibar)] <- undecided_xibar[today]

    shift_proportion <- undecided_xibar / pmax(0.0001, abs(diff_xibar)) # avoid div by 0

    # if undecided == 5x diff, move probability by 5%.
    unbounded_shift <- 0.01 * shift_proportion

    # raw_shift can reach near-infinity. Cap to 10%
    shift <- pmin(0.1, unbounded_shift)

    # shift, while guaranteeing never to flip the probability
    return(ifelse(dem_win_prob > 0.5, pmax(0.5, dem_win_prob - shift), pmin(0.5, dem_win_prob + shift)))
  }

  stub_CA_diff_curve <- function() {
    return(list(
      curve=data.frame(
        state=c('CA'),
        date=c(endDate),
        diff_xibar=NA,
        diff_stddev=NA,
        undecided_xibar=NA,
        dem_win_prob=c(1.0),
        dem_win_prob_with_undecided=c(1.0)
      ),
      samples_string=''
    ))
  }

  stub_diff_curve <- function(state_code, cook_rating) {
    cook_index <- match(cook_rating, CookPriors$rating)
    dem_win_prob <- CookPriors[cook_index,'dem_win_prob']

    return(list(
      curve=data.frame(
        state=c(state_code),
        date=c(endDate),
        diff_xibar=NA,
        diff_stddev=NA,
        undecided_xibar=NA,
        dem_win_prob=c(dem_win_prob),
        dem_win_prob_with_undecided=c(dem_win_prob)
      ),
      samples_string=''
    ))
  }

  # Outputs a string of the format we'll read in JavaScript.
  #
  # The output has NOutputSamples lines. Each line is a hex string of length
  # 4*ndays. Each 4-byte set of hexadecimal digits represents a 2-byte uint16 of
  # the fraction democrats are beating republicans: the floats [-1.0,1.0]
  # normalized to the range [0,0xffff].
  #
  # The last uint16 is for endDate; JavaScript can determine the other dates
  # by working backwards.
  calculate_diff_curve_samples_string <- function(normalized_array, dem_label, gop_label) {
    diff_array <- normalized_array[dem_label,,] - normalized_array[gop_label,,]
    n_input_samples <- dim(diff_array)[1]
    thin_factor <- floor(n_input_samples / NOutputSamples)
    thin_indexes <- seq_len(NOutputSamples) * thin_factor

    thinned_array <- diff_array[thin_indexes,]

    int_array <- round((thinned_array * 0.5 + 0.5) * Uint16Factor)
    strings <- apply(int_array, 'iteration', function(x) paste(sprintf('%04x', x), collapse=''))

    return(paste(strings, collapse='\n'))
  }

  ###############################
  # Method starts here

  suppressPackageStartupMessages(library('rjags'))

  if (chart_slug == '2016-california-senate-harris-vs-sanchez') {
    return(stub_CA_diff_curve())
  }

  if (chart_slug == '') {
    return(stub_diff_curve(state_code, cook_rating))
  }

  ## url to the pollster csv
  data <- read.csv(
    file=url(paste0("http://elections.huffingtonpost.com/pollster/api/charts/",chart_slug,".csv")),
    colClasses=c("start_date"="Date", "end_date"="Date"),
    check.names=FALSE
  )

  if (!is.null(filter_polls)) {
    data <- data[filter_polls(data), ]
  }

  # Nix out-of-range polls
  data <- data[data$start_date >= startDate & data$end_date <= endDate,]

  if (nrow(data) < MinNPollsForModel) {
    # Not enough polls: the model will be garbage
    return(stub_diff_curve(state_code, cook_rating))
  }

  if (sum(data$end_date >= outputStartDate) < MinNPollsForOutput) {
    # Not enough polls on the chart: the chart will be garbage (the model
    # will be imprecise, too)
    return(stub_diff_curve(state_code, cook_rating))
  }

  if (any(data$end_date < data$start_date)) {
    stop("found mangled start and end dates")
  }

  ## missing sample sizes?
  nobs <- data$sample_size
  nobs.bad <- is.na(nobs) | nobs <= 0
  if(any(nobs.bad)){
    cat(paste("mean imputing for", sum(nobs.bad), "bad/missing sample sizes\n"))
    nobs.bar <- tapply(nobs,data$pollster,mean,na.rm=TRUE)
    nobs.bar[is.na(nobs.bar)] <- mean(nobs,na.rm=TRUE)

    nobs[nobs.bad] <- nobs.bar[match(data$pollster[nobs.bad],names(nobs.bar))]
  }
  data$nobs <- nobs
  data$nobs_truncated <- ifelse(data$nobs > 3000, 3000, data$nobs)

  rm(nobs)

  # [adamhooper6] Value 0 makes for "Node inconsistent with parent" error. Use
  # almost-zero.
  for (label in calculate_labels(colnames(data))) {
    data[[label]] <- ifelse(data[[label]] == 0, 1E-6, data[[label]])
  }

  ## pollsters and pops
  data$pp <- paste0(data$pollster, ":", data$sample_subpopulation)
  pollsters <- sort(unique(data$pollster)) #list of pollsters
  thePollsters <- sort(unique(data$pp))    #list of pollsters w/populations

  ## FOR FORECAST MODEL, COOK RATINGS PRIORS
  cook_index <- match(cook_rating, CookPriors$rating)
  cookPrior1 <- CookPriors[cook_index,'prior1']
  cookPrior2 <- CookPriors[cook_index,'prior2']

  candidate_xis <- list()
  mcmc_params <- McmcParams[[ifelse(fast, 'fast', 'slow')]]

  #######################################
  ## loop over the responses to be modelled
  for (who in calculate_labels(colnames(data))) {
    cat(paste0('[', state_code, '] running for outcome ', who, '\n'))

    jags_data <- makeJagsObject(data, thePollsters, who)

    initFunc <- function() { return(makeInits(jags_data, cookPrior1, cookPrior2)) }
    ## call JAGS
    jags_model <- jags.model(
      file="../common/singleTarget.bug",
      data=jags_data,
      n.chains=mcmc_params$n_chains,
      inits=initFunc,
      quiet=TRUE
    )
    update(jags_model, mcmc_params$n_pre_monitor_iterations)

    out <- coda.samples(
      jags_model,
      variable.names=c("xi"),
      n.iter=mcmc_params$n_iterations,
      thin=mcmc_params$n_iterations/mcmc_params$n_samples
    )

    xi_array <- mcmc_list_to_xi_array(out)

    candidate_xis[[who]] <- xi_array
  }

  cat(paste0('[', state_code, '] combining/renormaling output\n'))
  normalized_array <- build_normalized_array(candidate_xis)

  frame <- data.frame(
    state=rep(state_code, times=endDate - outputStartDate + 1),
    date=seq.Date(from=outputStartDate, to=endDate, by='day')
  )
  undecided_frame <- build_choice_frame(
    normalized_array,
    'Undecided',
    list(undecided_xibar='mean', undecided_stddev='sd')
  )
  diff_frame <- diffSummary(normalized_array, dem_label, gop_label)

  out <- data.frame(frame, undecided_frame, diff_frame)
  out$dem_win_prob_with_undecided <- center_probability_with_undecided(out$dem_win_prob, out$diff_xibar, out$undecided_xibar)

  samples_string <- calculate_diff_curve_samples_string(normalized_array, dem_label, gop_label)

  #write.csv(out, file='out.csv')

  return(list(
    curve=out[c(
      'state',
      'date',
      'diff_xibar',
      'diff_stddev',
      'undecided_xibar',
      'dem_win_prob',
      'dem_win_prob_with_undecided'
    )],
    samples_string=samples_string
  ))
}
