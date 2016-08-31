'use strict'

/** Returns `null` if s is the empty string; otherwise parses it as a Float */
function parse_float_or_null(s) {
  if (s == '') {
    return null
  } else {
    return parseFloat(s)
  }
}

module.exports = class SenateCurvePoint {
  constructor(hash) {
    const n = parse_float_or_null

    this.state_code = hash.state
    this.date_s = hash.date
    this.diff_xibar = n(hash.diff_xibar)
    this.diff_low = n(hash.diff_low)
    this.diff_high = n(hash.diff_high)
    this.undecided_xibar = n(hash.undecided_xibar)
    this.dem_win_prob = n(hash.dem_win_prob_with_undecided)
  }
}
