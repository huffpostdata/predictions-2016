'use strict'

const fs = require('fs')
const csv_parse = require('csv-parse/lib/sync')

const ThisYearSeatClass = 3

function is_seat_existing_dem(seat) {
  if (seat.seat_class == ThisYearSeatClass) return false
  return seat.party_code != 'gop'
}

function is_seat_existing_gop(seat) {
  if (seat.seat_class == ThisYearSeatClass) return false
  return seat.party_code == 'gop'
}

class SenateSeatCounts {
  constructor(seats, dem_count_probs, dem_counts) {
    this.n_existing_dem = seats.all.filter(is_seat_existing_dem).length
    this.n_existing_gop = seats.all.filter(is_seat_existing_gop).length

    this.dem_count_probs = dem_count_probs
    this.dem_counts = dem_counts

    this.max_n = Math.max.apply(null, dem_counts)
    this.max_p = Math.max.apply(null, dem_count_probs)

    this.n = this.dem_counts.reduce(((a, s) => a + s), 0)

    let x_min = null
    let x_max = null
    for (let e = 0; e < dem_counts.length; e++) {
      const p = dem_count_probs[e]
      if (x_min === null && p > 0.0001) x_min = e
      if (p > 0.0001) x_max = e
    }
    this.bars = []
    for (let e = x_min; e <= x_max; e++) {
      this.bars.push({
        n_seats: e + this.n_existing_dem,
        n: dem_counts[e],
        n_million: dem_counts[e] / 1e6,
        p: dem_count_probs[e],
        fraction: dem_counts[e] / this.max_n
      })
    }

    this.prob_dem = dem_count_probs
      .slice(51 - this.n_existing_dem)
      .reduce(((a, s) => a + s), 0)

    this.prob_tie = dem_count_probs[50 - this.n_existing_dem]

    this.prob_gop = 1.0 - this.prob_dem - this.prob_tie

    this.summary_chart_data = [
      {
        result: 'dem',
        party_name: 'Democrats',
        percent: 100 * this.prob_dem,
        is_most_probable: this.prob_dem > Math.max(this.prob_tie, this.prob_gop),
        sentence_html: `Democrats gain control of the Senate in <strong>${Math.round(100 * this.prob_dem)}%</strong> of our simulations.`,
        sentence_left: '0',
        sentence_width: `${100 / this.prob_dem}%`
      },
      {
        result: 'tie',
        party_name: 'Tie',
        percent: 100 * this.prob_tie,
        is_most_probable: this.prob_tie > Math.max(this.prob_dem, this.prob_gop),
        sentence_html: `The Senate splits 50-50 in <strong>${Math.round(100 * this.prob_tie)}%</strong> of our simulations. <small>The vice-president decides the balance of power in that case.</small>`,
        sentence_left: `-${100 * this.prob_dem / this.prob_tie}%`,
        sentence_width: `${100 / this.prob_tie}%`
      },
      {
        result: 'gop',
        party_name: 'Republicans',
        percent: 100 * this.prob_gop,
        is_most_probable: this.prob_gop > Math.max(this.prob_tie, this.prob_dem),
        sentence_html: `Republicans keep control of the Senate in <strong>${Math.round(100 * this.prob_gop)}%</strong> of our simulations.`,
        sentence_left: `-${100 * (this.prob_dem + this.prob_tie) / this.prob_gop}%`,
        sentence_width: `${100 / this.prob_gop}%`
      }
    ]
  }
}

SenateSeatCounts.load = function(senate_seats) {
  const input_path = `${__dirname}/../data/sheets/output/senate-seat-counts.tsv`
  const tsv = fs.readFileSync(input_path)
  const array = csv_parse(tsv, { delimiter: '\t', columns: true })
  const dem_counts = array.map(h => +h.n) // 0 => 0, 1 => ....
  const dem_count_probs = array.map(h => +h.p) // 0 => 0.0000, 1 => ....

  return new SenateSeatCounts(senate_seats, dem_count_probs, dem_counts);
}

module.exports = SenateSeatCounts
