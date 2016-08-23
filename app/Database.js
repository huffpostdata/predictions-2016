'use strict'

const read_config = require('../generator/read_config')
const GoogleDocs = require('../generator/GoogleDocs')
const GoogleSheets = require('../generator/GoogleSheets')

const SenateRace = require('./SenateRace')
const SenateSeat = require('./SenateSeat')

module.exports = class Database {
  constructor() {
    const google_sheets = new GoogleSheets(read_config('google-sheets'))
    const google_docs = new GoogleDocs(read_config('google-docs'))

    this.senate = Object.assign(google_docs.load('senate'), {
      races: google_sheets.slug_to_objects('senate-races', SenateRace),
      before_election: google_sheets.slug_to_objects('senate-before-election', SenateSeat),
    })
  }
}
