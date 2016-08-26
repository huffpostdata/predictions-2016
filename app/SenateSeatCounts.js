'use strict'

const fs = require('fs')
const csv_parse = require('csv-parse/lib/sync')

const TodayS = new Date().toISOString().slice(0, 10) // FIXME pass as parameter
const ThisYearSeatClass = 3

function is_seat_existing_dem(seat) {
  if (seat.seat_class == ThisYearSeatClass) return false
  return seat.party_code != 'GOP'
}

function is_seat_existing_gop(seat) {
  if (seat.seat_class == ThisYearSeatClass) return false
  return seat.party_code == 'GOP'
}

class SenateSeatCounts {
  constructor(seats, dem_count_probs, dem_counts) {
    this.seats = seats
    this.dem_count_probs = dem_count_probs
    this.dem_counts = dem_counts

    this.max_n = Math.max.apply(null, dem_counts)
    this.max_p = Math.max.apply(null, dem_count_probs)

    this.n_existing_dem = seats.all.filter(is_seat_existing_dem).length
    this.n_existing_gop = seats.all.filter(is_seat_existing_gop).length

    this.n = this.dem_counts.reduce(((a, s) => a + s), 0)

    // Assume max_n will be lower than ~5e7 and higher than ~1e7.
    const max_tick = Math.ceil(this.max_n / 1e7) * 1e7
    this.y_ticks = []
    for (let tick = 0; tick <= max_tick; tick += 1e7) {
      this.y_ticks.push(tick)
    }

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
        fraction: dem_counts[e] / max_tick
      })
    }

    this.prob_dem = dem_count_probs
      .slice(51 - this.n_existing_dem)
      .reduce(((a, s) => a + s), 0)

    this.prob_tie = dem_count_probs[50 - this.n_existing_dem]

    this.prob_gop = 1.0 - this.prob_dem - this.prob_tie
  }
}

SenateSeatCounts.load = function(senate_seats) {
  const input_path = `${__dirname}/../data/sheets/output/senate-seat-counts-${TodayS}.tsv`
  const tsv = fs.readFileSync(input_path)
  const array = csv_parse(tsv, { delimiter: '\t', columns: true })
  const dem_counts = array.map(h => +h.n) // 0 => 0, 1 => ....
  const dem_count_probs = array.map(h => +h.p) // 0 => 0.0000, 1 => ....

  return new SenateSeatCounts(senate_seats, dem_count_probs, dem_counts);
}

module.exports = SenateSeatCounts
