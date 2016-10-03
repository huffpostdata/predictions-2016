'use strict'

const fs = require('fs')
const moment = require('moment-timezone')

const read_config = require('../generator/read_config')
const GoogleDocs = require('../generator/GoogleDocs')
const GoogleSheets = require('../generator/GoogleSheets')

const Curves = require('./Curves')
const PresidentRaces = require('./PresidentRaces')
const PresidentVoteCounts = require('./PresidentVoteCounts')
const SenateRace = require('./SenateRace')
const SenateRaces = require('./SenateRaces')
const SenateSeat = require('./SenateSeat')
const SenateSeatCounts = require('./SenateSeatCounts')
const SenateSeats = require('./SenateSeats')

function format_date_full(date) {
  const m = moment(date).tz('America/New_York')

  const month = [
    'Jan.',
    'Feb.',
    'March',
    'April',
    'May',
    'June',
    'July',
    'Aug.',
    'Sept.',
    'Oct.',
    'Nov.',
    'Dec.'
  ][m.month()]

  return m
    .format(`dddd, [${month}] D, YYYY, h:mm A z`)
    .replace(/([AP])M/, '$1.M.') // 'AM' => 'A.M.'
}

module.exports = class Database {
  constructor() {
    const google_sheets = new GoogleSheets(read_config('google-sheets'))
    const google_docs = new GoogleDocs(read_config('google-docs'))

    const senate_seats = new SenateSeats(google_sheets.slug_to_objects('senate-before-election', SenateSeat))

    this.senate = Object.assign(google_docs.load('senate'), {
      races: SenateRaces.load(google_sheets.slug_to_array('senate-races'), senate_seats, Curves.load('senate')),
      seat_counts: SenateSeatCounts.load(senate_seats),
      senate_seats: senate_seats
    })
    this.senate.metadata.suggested_tweet = `Latest HuffPost Senate forecast: ${this.senate.seat_counts.prob_dem_percent.toFixed(1)}% chance Dem control / ${this.senate.seat_counts.prob_gop_percent.toFixed(1)}% GOP / ${this.senate.seat_counts.prob_tie_percent.toFixed(1)}% tie.`
    this.senate.metadata.date_updated = format_date_full(this.senate.races.updated_at)

    this.senate_races = this.senate.races.all

    this.senate_races_for_tsv = [{
      date: this.senate.races.updated_at_s,
      races: this.senate_races,
      seat_counts: this.senate.seat_counts.all
    }]

    const president_curves = Curves.load('president')

    this.president = Object.assign(google_docs.load('president'), {
      vote_counts: PresidentVoteCounts.load(),
      races: PresidentRaces.load(president_curves)
    })
    this.president.metadata.date_updated = format_date_full(this.president.races.updated_at)
    this.president.metadata.suggested_tweet = `HuffPost presidential forecast: Clinton has ${this.president.vote_counts.percent_clinton.toFixed(1)}% chance of winning.`

    this.president_races = this.president.races.all

    this.president_races_for_tsv = [{
      date: this.president.races.updated_at_s,
      races: this.president.races.all,
      vote_counts: this.president.vote_counts
    }]

    this.sidebar = {
      senate_races: this.senate.races.sorted_by('flip-probability').slice(0, 5).sort((a, b) => a.state_name.localeCompare(b.state_name)), 
      senate_seat_counts: this.senate.seat_counts,
      president_races: this.president.races.battlegrounds.slice(0).sort((a, b) => b.n_electoral_votes - a.n_electoral_votes).slice(0, 5).sort((a, b) => b.diff_xibar - a.diff_xibar),
      president_vote_counts: this.president.vote_counts
    }

    this.mobile_ad = {
      senate_seat_counts: this.senate.seat_counts,
      president_vote_counts: this.president.vote_counts
    }

    this.tiny_mobile_ad = fs.readFileSync(`${__dirname}/../tiny-mobile-ad/output/${this.president.vote_counts.percent_clinton.toFixed(0)}.png`)
    this.tiny_mobile_ad_landscape = fs.readFileSync(`${__dirname}/../tiny-mobile-ad/output/${this.president.vote_counts.percent_clinton.toFixed(0)}-landscape.png`)
  }
}
