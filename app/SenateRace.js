'use strict'

const moment = require('moment-timezone')

const StateCodeToStateName = {
	AL: 'Alabama',
	AK: 'Alaska',
	AZ: 'Arizona',
	AR: 'Arkansas',
	CA: 'California',
	CO: 'Colorado',
	CT: 'Connecticut',
	DE: 'Delaware',
	DC: 'District of Columbia',
	FL: 'Florida',
	GA: 'Georgia',
	HI: 'Hawaii',
	ID: 'Idaho',
	IL: 'Illinois',
	IN: 'Indiana',
	IA: 'Iowa',
	KS: 'Kansas',
	KY: 'Kentucky',
	LA: 'Louisiana',
	ME: 'Maine',
	MD: 'Maryland',
	MA: 'Massachusetts',
	MI: 'Michigan',
	MN: 'Minnesota',
	MS: 'Mississippi',
	MO: 'Missouri',
	MT: 'Montana',
	NE: 'Nebraska',
	NV: 'Nevada',
	NH: 'New Hampshire',
	NJ: 'New Jersey',
	NM: 'New Mexico',
	NY: 'New York',
	NC: 'North Carolina',
	ND: 'North Dakota',
	OH: 'Ohio',
	OK: 'Oklahoma',
	OR: 'Oregon',
	PA: 'Pennsylvania',
	RI: 'Rhode Island',
	SC: 'South Carolina',
	SD: 'South Dakota',
	TN: 'Tennessee',
	TX: 'Texas',
	UT: 'Utah',
	VT: 'Vermont',
	VA: 'Virginia',
	WA: 'Washington',
	WV: 'West Virginia',
	WI: 'Wisconsin',
	WY: 'Wyoming'
}

const CookRatingToCookName = {
  'R-Solid': 'solidly Republican',
  'R-Likely': 'likely Republican',
  'R-Lean': 'leaning Republican',
  'Toss Up': 'toss-up',
  'D-Lean': 'leaning Democrat',
  'D-Likely': 'likely Democrat',
  'D-Solid': 'solidly Democrat'
}

module.exports = class SenateRace {
  constructor(hash, seat, curve) {
    this.state_code = hash.state
    this.state_name = StateCodeToStateName[hash.state]
    this.pollster_slug = hash.pollster_slug
    this.cook_rating = hash.cook_rating
    this.cook_rating_name = CookRatingToCookName[hash.cook_rating]
    this.dem_name = hash.dem_name
    this.dem_label = hash.dem_label
    this.gop_name = hash.gop_name
    this.gop_label = hash.gop_label

    this.seat = seat
    this.curve = curve
    this.updated_at = curve.updated_at

    this.dem_win_prob = curve.election_day_point.dem_win_prob
    this.dem_win_prob_with_undecided = curve.election_day_point.dem_win_prob_with_undecided

    this.flip_prob = this.seat.party_code === 'dem' ? (1 - this.dem_win_prob_with_undecided) : this.dem_win_prob_with_undecided

    this.lean_html_class = (this.dem_win_prob_with_undecided === 0.5) ? 'toss-up' : (this.dem_win_prob_with_undecided > 0.5 ? 'lean-dem' : 'lean-gop')

    this.seat_party_code = this.seat.party_code
    this.seat_party_name = this.seat_party_code === 'dem' ? 'Democratic' : 'Republican'
    this.flip_party_code = this.seat_party_code === 'dem' ? 'gop' : 'dem'

    const winner = this.dem_win_prob > 0.5 ? 'dem' : 'gop'
    const loser = this.dem_win_prob > 0.5 ? 'gop' : 'dem'

    const build_candidate = (party) => {
      const ret = {
        name: this[party + '_name'],
        label: this[party + '_label'],
        party: party,
        party_letter: party === 'dem' ? 'D' : 'R',
        party_full: party === 'dem' ? 'Democrat' : 'Republican'
      };
      ret.incumbent_ = ret.label === this.seat.label ? 'incumbent ' : ''
      ret.Incumbent_ = ret.label === this.seat.label ? 'Incumbent ' : ''

      return ret;
    }

    this.calculations = {
      tie: Math.round(this.dem_win_prob_with_undecided * 1000) === 500,
      winner: build_candidate(winner),
      loser: build_candidate(loser),
      raw_prob: (100 * Math.max(this.dem_win_prob, 1 - this.dem_win_prob)).toFixed(1),
      undecided: (100 * curve.election_day_point.undecided_xibar).toFixed(1),
      undecided_penalty: (100 * Math.abs(this.dem_win_prob_with_undecided - this.dem_win_prob)).toFixed(1),
      prob_with_undecided: (100 * Math.max(this.dem_win_prob_with_undecided, 1 - this.dem_win_prob_with_undecided)).toFixed(1)
    }

    this.calculations.winner_party_letter_and_incumbent = this.calculations.winner_party_letter + (this[winner + '_label'] === this.seat.label ? ' incumbent' : '')
    this.calculations.loser_party_letter_and_incumbent = this.calculations.loser_party_letter + (this[loser + '_label'] === this.seat.label ? ' incumbent' : '')
  }
}
