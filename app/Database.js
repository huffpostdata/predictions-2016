'use strict'

const read_config = require('../generator/read_config')
const GoogleDocs = require('../generator/GoogleDocs')
const GoogleSheets = require('../generator/GoogleSheets')

const SenateCurves = require('./SenateCurves')
const SenateRace = require('./SenateRace')
const SenateRaces = require('./SenateRaces')
const SenateSeat = require('./SenateSeat')
const SenateSeats = require('./SenateSeats')

module.exports = class Database {
  constructor() {
    const google_sheets = new GoogleSheets(read_config('google-sheets'))
    const google_docs = new GoogleDocs(read_config('google-docs'))

    this.senate = Object.assign(google_docs.load('senate'), {
      races: SenateRaces.load(google_sheets.slug_to_array('senate-races'), SenateCurves.load()),
      before_election: new SenateSeats(
        google_sheets.slug_to_objects('senate-before-election', SenateSeat)
      )
    })
  }
}
