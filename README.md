Shows readers who's most likely to win in senate and presidential elections.

# URLs

| Path | Description |
| --- | --- |
| `senate` | Senate-prediction dashboard |
| `senate/:state` | Senate prediction for _state_ (two-letter capitalized postal code) |
| `senate/curves.tsv` | Prediction CSV for all states |
| `senate/house-effects.tsv` | House-effects CSV for all states |
| `senate/seat-counts.tsv` | Seat-count distribution CSV for senate |
| `senate/before-election.tsv` | Information about every senate seat |
| `senate/races.tsv` | Information about every 2016 senate race |

# Data pipeline

Our R models crunch numbers for a long time. We save some data partway through.

We also let end-users download the final data in TSV form.

Here are the TSVs we publish:

## senate/curves.tsv

We run lots and lots of simulations to model how people would vote were the
election held on `date` (for lots of dates) -- within a probability
distribution.

| Column | Example values | Meaning |
| --- | --- | --- |
| `state_code` | `AL`, `NY` | Two-letter, capitalized state code |
| `date` | `2016-10-10` | Date of the prediction (past, today, or future) in YYYY-MM-DD format |
| `dem_xibar` | `0.2`, `0.8` | ![equation](http://latex.codecogs.com/gif.latex?\bar{x_i}) -- the mean (FIXME median?) for the Dem candidate |
| `dem_low` | `0.1`, `0.7` | the value the Dem candidate exceeds 97.5% of the time (FIXME exactly 97.5?) |
| `dem_high` | `0.3`, `0.9` |the value the Dem candidate misses 97.5% of the time (FIXME exactly 97.5?) |
| `gop_xibar` | `0.2`, `0.8` | ![equation](http://latex.codecogs.com/gif.latex?\bar{x_i}) -- the mean (FIXME median?) for the GOP candidate |
| `gop_low` | `0.1`, `0.7` | the value the GOP candidate exceeds 97.5% of the time (FIXME exactly 97.5?) |
| `gop_high` | `0.3`, `0.9` | the value the GOP candidate misses 97.5% of the time (FIXME exactly 97.5?) |
| `dem_win_prob` | `0.4` | the fraction of the time the Dem candidate beats the GOP candidate (there are no ties) |

All values are rounded to four decimal points and truncated so they are between
`0.0000` and `1.0000` (inclusive).

## senate/house-effects.tsv

Different pollsters end up having biases. Each Senate race is treated
individually; we publish the biases in a CSV with the following columns:

| Column | Example values | Meaning |
| --- | --- | --- |
| `state_code` | `AL`, `NY` | Two-letter, capitalized state code |
| `pollster` | `ARG` | Pollster name |
| `sample_subpopulation` | `Adults`, `Registered Voters` or `Likely Voters` | Subpopulation |
| `estimate` | `0.001`, `-0.03` | Amount that we'd need to skew the outcome of this pollster's polls in _favor_ of the _Democratic_ candidate to meet the average among all pollsters (`0.01` means "one percentage point") (FIXME is this right?) |
| `estimate_low` | `-0.002`, `-0.0303` | The `estimate` we would need so our results favor the _Dem_ candidate 97.5% of the time (FIXME Democratic? FIXME 97.5%?) |
| `estimate_high` | `0.004`, `-0.0297` | The `estimate` we would need so our results favor the _GOP_ candidate 97.5% of the time (FIXME Democratic? FIXME 97.5%?) |

## senate/seat-counts.tsv

After we calculate predictions for each state, we simulate lots of elections to
calculate how probable each distribution of seat counts is.

| Column | Example values | Meaning |
| --- | --- | --- |
| `date` | `2016-09-08` | Date of the election |
| `n_dem` | `10` | Event: Democrats win exactly `n_dem` races |
| `p` | `0.0300` | Probability of that event |

## senate/before-election.tsv

Our user interface can display all senate seats. So we need some basic
information about them.

| Column | Example values | Meaning |
| --- | --- | --- |
| `state` | `AL`, `NY` | Two-letter, capitalized state code |
| `class` | `1`, `2`, `3` | Class of senate seat: class `3` means the seat is up for re-election in 2016 |
| `bio_id` | `B001230` | ID for `http://bioguide.congress.gov/`. [example URL](http://bioguide.congress.gov/scripts/biodisplay.pl?index=B001230) |
| `name` | `Tammy Baldwin` | Full name of incumbent senator |
| `label` | `Baldwin` | Brief name we assign to the incumbent senator on Pollster charts |
| `party` | `Dem`, `GOP`, `Ind` | Party of incumbent senator |

## senate/races.tsv

We need more information about Class 3 seats, since those are up for reelection.

It just so happens that this year, the only major players are Democrats and
Republicans.

| Column | Example values | Meaning |
| --- | --- | --- |
| `state` | `AL`, `NY` | Two-letter, capitalized state code |
| `pollster_slug` | `2016-indiana-senate-young-vs-bayh` | Pollster chart for this race |
| `dem_name` | `Michael Bennet` | Full name of Democratic nominee |
| `dem_label` | `Bennet` | Brief name we assign the Democratic nominee on Pollster charts |
| `gop_name` | `Darryl Glenn` | Full name of Republican nominee |
| `gop_label` | `Glenn` | Brief name we assign the Republican nominee on Pollster charts |
