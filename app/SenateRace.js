'use strict'

module.exports = class SenateRace {
  constructor(hash, seat, curve) {
    this.state_code = hash.state
    this.pollster_slug = hash.pollster_slug
    this.cook_rating = hash.cook_rating
    this.dem_name = hash.dem_name
    this.dem_label = hash.dem_label
    this.gop_name = hash.gop_name
    this.gop_label = hash.gop_label

    this.seat = seat
    this.curve = curve

    this.dem_win_prob = curve.election_day_point.dem_win_prob
    this.dem_win_prob_with_undecided = curve.election_day_point.dem_win_prob_with_undecided

    this.flip_prob = this.seat.party_code === 'dem' ? (1 - this.dem_win_prob_with_undecided) : this.dem_win_prob_with_undecided
    this.seat_party_code = this.seat.party_code
    this.flip_party_code = this.seat_party_code === 'dem' ? 'gop' : 'dem'

    const winner = this.dem_win_prob > 0.5 ? 'dem' : 'gop'
    const loser = this.dem_win_prob > 0.5 ? 'gop' : 'dem'

    this.calculations = {
      tie: this.dem_win_prob === 0.5,
      winner_name: this[winner + '_name'],
      loser_name: this[loser + '_name'],
      winner_party: winner,
      winner_party_letter: winner === 'dem' ? 'D' : 'R',
      winner_party_full: winner === 'dem' ? 'Democrat' : 'Republican',
      loser_party: loser,
      loser_party_letter: loser === 'dem' ? 'D' : 'R',
      raw_prob: (100 * Math.max(this.dem_win_prob, 1 - this.dem_win_prob)).toFixed(1),
      undecided: (100 * curve.election_day_point.undecided_xibar).toFixed(1),
      undecided_penalty: (100 * Math.abs(this.dem_win_prob_with_undecided - this.dem_win_prob)).toFixed(1),
      prob_with_undecided: (100 * Math.max(this.dem_win_prob_with_undecided, 1 - this.dem_win_prob_with_undecided)).toFixed(1)
    }
  }
}
