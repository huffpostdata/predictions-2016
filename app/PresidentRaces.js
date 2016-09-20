'use strict'

const fs = require('fs')
const csv_parse = require('csv-parse/lib/sync')

const moment = require('moment-timezone')

const PresidentRace = require('./PresidentRace')

class PresidentRaces {
  constructor(all) {
    this.updated_at = new Date(Math.max.apply(null, all.map(race => race.updated_at)))
    this.updated_at_s = moment(this.updated_at).tz('UTC').format('YYYY-MM-DDThh-mm-ss[Z]'),
    this.all = all.slice()
    this.all.sort((a, b) => {
      const d = b.dem_win_prob_with_adjustment_and_undecided - a.dem_win_prob_with_adjustment_and_undecided
      if (d != 0) return d
      return a.state_name.localeCompare(b.state_name)
    })
  }
}

function load_array_from_tsv_path(relative_path) {
  const input_path = `${__dirname}/../data/sheets/${relative_path}`
  const tsv = fs.readFileSync(input_path)
  return csv_parse(tsv, { delimiter: '\t', columns: true })
}

PresidentRaces.load = function(curves) {
  const updated_at = fs.statSync(`${__dirname}/../data/sheets/output/president-summaries.tsv`).mtime

  const race_hashes = load_array_from_tsv_path('input/president-races.tsv')
  const state_code_to_race_hash = {}
  race_hashes.forEach(h => state_code_to_race_hash[h.state_code] = h)

  const summaries = load_array_from_tsv_path('output/president-summaries.tsv')
  const state_code_to_summary = {}
  summaries.forEach(h => state_code_to_summary[h.state_code] = h)

  const all = []
  for (const [ state_code, curve ] of curves.state_code_to_curve) {
    all.push(new PresidentRace(
      state_code_to_race_hash[state_code],
      state_code_to_summary[state_code],
      curve
    ))
  }

  return new PresidentRaces(all)
}

module.exports = PresidentRaces
