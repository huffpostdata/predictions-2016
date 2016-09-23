'use strict'

class Split {
  constructor(cook_rating) {
    this.cook_rating = cook_rating
  }
}
Split.parse_all = function(comma_separated_ratings) {
  return comma_separated_ratings
    .split(',')
    .filter(s => s.length > 0)
    .map(s => new Split(s))
}

module.exports = class PresidentRace {
  constructor(hash, summary, curve) {
    this.state_code = hash.state_code
    this.national_dem_correlation = hash.national_dem_correlation
    this.state_name = hash.state_name
    this.pollster_slug = hash.pollster_slug
    this.cook_rating = hash.cook_rating
    this.n_electoral_votes = hash.n_electoral_votes
    this.splits = Split.parse_all(hash.split_cook_ratings_by_cd)

    this.dem_win_prob = summary.dem_win_prob
    this.national_dem_win_prob = summary.national_dem_win_prob
    this.national_delta = summary.national_delta
    this.national_adjustment = summary.national_adjustment
    this.national_adjustment_100 = (100 * this.national_adjustment).toFixed(1)
    this.dem_win_prob_with_adjustment = summary.dem_win_prob_with_adjustment
    this.undecided_margin = summary.undecided_margin
    this.undecided_margin_100 = (100 * this.undecided_margin).toFixed(1)
    this.dem_win_prob_with_adjustment_and_undecided = summary.dem_win_prob_with_adjustment_and_undecided

    this.curve = curve
    this.toss_up = this.dem_win_prob_with_adjustment_and_undecided === 0.5
    this.updated_at = curve.updated_at

    const p = this.dem_win_prob_with_adjustment_and_undecided
    this.lean_html_class = p > 0.5 ? 'lean-clinton' : (p < 0.5 ? 'lean-trump' : 'toss-up')
    this.call_html_class = p > 0.9 ? 'probably-clinton' : (p < 0.9 ? 'probably-trump' : 'no-call')

    this.raw_win_prob_100 = (100 * Math.max(this.dem_win_prob, 1 - this.dem_win_prob)).toFixed(1)
    this.win_prob = Math.max(p, 1 - p)
    this.win_prob_100 = (this.win_prob * 100).toFixed(1)
    this.winner_name = p > 0.5 ? 'Clinton' : (p < 0.5 ? 'Trump' : '')
    this.winner = this.winner_name.toLowerCase()
    this.loser_name = p < 0.5 ? 'Clinton' : (p > 0.5 ? 'Trump' : '')
    this.loser = this.loser_name.toLowerCase()
  }

  /**
   * Returns this.dem_win_prob_with_adjustment_and_undecided ... scaled so that
   * it's the fraction along range scale[0] to scale[1] (two Numbers).
   */
  scale_final_win_prob_100(scale) {
    const min = scale[0]
    const max = scale[1]

    const x = this.dem_win_prob_with_adjustment_and_undecided

    return (x - min) / (max - min)
  }
}
