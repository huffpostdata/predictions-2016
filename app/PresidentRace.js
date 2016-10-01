'use strict'

const CookRatingToCookName = {
  'R-Solid': 'solidly Republican',
  'R-Likely': 'likely Republican',
  'R-Lean': 'leaning Republican',
  'Toss Up': 'toss-up',
  'D-Lean': 'leaning Democrat',
  'D-Likely': 'likely Democrat',
  'D-Solid': 'solidly Democrat'
}

class Split {
  constructor(cook_rating) {
    this.cook_rating = cook_rating
    this.cook_rating_name = CookRatingToCookName[cook_rating]
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
    this.state_name = hash.state_name
    this.pollster_slug = hash.pollster_slug
    this.cook_rating = hash.cook_rating
    this.cook_rating_name = CookRatingToCookName[hash.cook_rating]
    this.n_electoral_votes = +hash.n_electoral_votes
    this.splits = Split.parse_all(hash.split_cook_ratings_by_cd)

    this.diff_xibar = 100 * (+summary.diff_xibar)
    this.diff_stddev = 100 * (+summary.diff_stddev)
    this.diff_margin = this.diff_stddev * 1.96
    this.undecided_xibar_100 = 100 * (+summary.undecided_xibar)
    this.undecided_stddev_boost = 100 * (+summary.undecided_stddev_boost)
    this.undecided_margin_boost = this.undecided_stddev_boost * 1.96
    this.clinton_win_prob = +summary.clinton_win_prob
    this.leader_win_prob_100 = 100 * Math.max(this.clinton_win_prob, 1.0 - this.clinton_win_prob)

    this.final_diff_xibar = this.diff_xibar
    this.final_diff_leader = this.final_diff_xibar > 0 ? 'clinton' : 'trump'
    this.final_diff_leader_name = this.final_diff_xibar > 0 ? 'Clinton' : 'Trump'
    this.final_diff_party_adjective = this.final_diff_xibar > 0 ? 'Democratic' : 'Republican'
    this.final_diff_stddev = this.diff_stddev + this.undecided_stddev_boost
    this.final_diff_margin = this.final_diff_stddev * 1.96

    this.curve = curve
    this.updated_at = curve.updated_at

    const p = this.dem_win_prob_with_adjustment_and_undecided
    this.lean_html_class = this.final_diff_xibar > 0 ? 'lean-clinton' : (this.final_diff_xibar < 0.5 ? 'lean-trump' : 'toss-up')
    this.call_html_class = p > 0.9 ? 'probably-clinton' : (p < 0.9 ? 'probably-trump' : 'no-call')
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

  /**
   * Returns something like
   * "<strong>solidly Democrat</strong>, <strong>toss-up</strong> and <strong>toss-up</strong>."
   */
  splits_phrase_html() {
    switch (this.splits.length) {
      case 2: return `<strong>${this.splits[0].cook_rating_name}</strong> and <strong>${this.splits[1].cook_rating_name}</strong>`
      case 3: return `<strong>${this.splits[0].cook_rating_name}</strong>, <strong>${this.splits[1].cook_rating_name}</strong> and <strong>${this.splits[2].cook_rating_name}</strong>`
      default: throw new Error(`Wrong number of splits in ${this.state_name}: ${this.splits.length}`)
    }
  }
}
