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
  constructor(seats, dem_count_probs) {
    this.seats = seats
    this.dem_count_probs = dem_count_probs
    this.max_dem_count_prob = Math.max.apply(null, this.dem_count_probs)

    this.n_existing_dem = seats.all.filter(is_seat_existing_dem).length
    this.n_existing_gop = seats.all.filter(is_seat_existing_gop).length

    console.log(this.n_existing_dem, this.n_existing_gop)

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
  const dem_count_probs = array.map(h => +h.p) // 0 => 0.0000, 1 => ....

  return new SenateSeatCounts(senate_seats, dem_count_probs);
}

module.exports = SenateSeatCounts
