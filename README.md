Shows readers who's most likely to win in senate and presidential elections.

# URLs

| Path | Description |
| --- | --- |
| `forecast/senate` | Senate-prediction dashboard |
| `forecast/sidebar` | Predictions sidebar |
| `forecast/senate-curves.tsv` | Prediction CSV for all states |
| `forecast/senate-seat-counts.tsv` | Seat-count distribution CSV for senate |
| `forecast/senate-before-election.tsv` | Information about every senate seat |
| `forecast/senate-races.tsv` | Information about every 2016 senate race |

# Data pipeline

Our R models crunch numbers for a long time. We save some data partway through.

We also let end-users download the final data in TSV form.

Here are the TSVs we publish:

## senate-curves.tsv

We run lots and lots of simulations to model how people would vote were the
election held on `date` (for lots of dates) -- within a probability
distribution.

| Column | Example values | Meaning |
| --- | --- | --- |
| `state_code` | `AL`, `NY` | Two-letter, capitalized state code |
| `date` | `2016-10-10` | Date of the prediction (past, today, or future) in YYYY-MM-DD format |
| `diff_xibar` | `0.2`, `0.8` | ![equation](http://latex.codecogs.com/gif.latex?%5Cbar%7B%5Cxi%7D) -- Out of lots of simulated elections, the Dem candidate's share of the vote minus the GOP candidate's (`1.0` means everybody voted for the Democrat) |
| `diff_low` | `0.1`, `0.7` | the spread the Dem candidate exceeds 97.5% of the time |
| `diff_high` | `0.3`, `0.9` | the spread the Dem candidate misses 97.5% of the time |
| `undecided_xibar` | `0.2`, `0.8` | ![equation](http://latex.codecogs.com/gif.latex?%5Cbar%7B%5Cxi%7D) -- Out of lots of simulated elections, the mean fraction of votes for the Undecided candidate (that is, assuming elections are like polls and "Undecided" is a choice) |
| `dem_win_prob` | `0.4` | Out of lots of simulated elections, the fraction times the Dem candidate beats the GOP candidate (we don't model ties) |
| `dem_win_prob_counting_undecided` | `0.45` | Like `dem_win_prob`, but nudged closer towards `0.5`, depending on how large `undecided_xibar` is |

All numbers are between `0.0000` and `1.0000` (inclusive).

For charts that don't have enough polling data, we may assign a `dem_win_prob`
while leaving `dem_xibar` and company blank.

## senate-seat-counts.tsv

After we calculate predictions for each state, we simulate lots of elections to
calculate how probable each distribution of seat counts is.

| Column | Example values | Meaning |
| --- | --- | --- |
| `date` | `2016-11-08` | Date of the election |
| `n_dem` | `10` | Event: Democrats win exactly `n_dem` races |
| `n` | `300` | Number of times that event happened (`sum(n)` is the total number of Monte Carlo simulations) |
| `p` | `0.0300` | Probability of that event |

## senate-before-election.tsv

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

## senate-races.tsv

We need more information about Class 3 seats, since those are up for reelection.

It just so happens that this year, the only major players are Democrats and
Republicans.

| Column | Example values | Meaning |
| --- | --- | --- |
| `state` | `AL`, `NY` | Two-letter, capitalized state code |
| `pollster_slug` | `2016-indiana-senate-young-vs-bayh` | Pollster chart for this race |
| `cook_rating` | `D-Solid`, `D-Likely`, `R-Lean`, `Toss Up` | Latest Cook Political Report [ratings](http://cookpolitical.com/senate/charts/race-ratings) |
| `dem_name` | `Michael Bennet` | Full name of Democratic nominee |
| `dem_label` | `Bennet` | Brief name we assign the Democratic nominee on Pollster charts |
| `gop_name` | `Darryl Glenn` | Full name of Republican nominee |
| `gop_label` | `Glenn` | Brief name we assign the Republican nominee on Pollster charts |

# Deployment

Deploy with a single command:

```sh
BASE_URL=http://example.org S3_BUCKET=example.org ./rebuild.sh fast
```

This will:

1. `rm -rf R/interim-results/`
2. Download the latest poll data
3. Run the R model
4. Construct a new `data/sheets/output/` directory, and copy a timestamped
   version in `data/sheets/output-archives/`
5. Build and upload the website

The intent is to run all this on a loop. In fact, that's what
`rebuild-continually.js` does. Run that one like this:

```sh
AIRBRAKE_PROJECT_ID=101010 \
AIRBRAKE_PROJECT_KEY=1f1f1ff... \
BASE_URL=http://example.org \
S3_BUCKET=example.org \
./rebuild-continually.js`
```

... You can even keep it running while in a GitHub repo; just update the repo
and it'll work with the new files.
