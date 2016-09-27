'use strict'

const fs = require('fs')

const moment = require('moment-timezone')

const PresidentRace = require('./PresidentRace')
const parseTsv = require('../generator/parseTsv')

function countElectoralVotes(races) {
  return races
    .map(x => +x.n_electoral_votes)
    .reduce(((s, n) => s + n), 0)
}

function compareRaces(a, b, demToGop) {
  var cmp = a.final_diff_xibar - b.final_diff_xibar
  if (cmp !== 0) {
    return demToGop ? -cmp : cmp
  }

  return a.state_name.localeCompare(b.state_name)
}

class PresidentRaces {
  constructor(all) {
    this.updated_at = new Date(Math.max.apply(null, all.map(race => race.updated_at)))
    this.updated_at_s = moment(this.updated_at).tz('UTC').format('YYYY-MM-DDThh-mm-ss[Z]'),
    this.all = all.slice()

    this.likely_clinton = this.all
      .filter(x => x.diff_xibar > 0 && !x.zero_within_90)
      .sort((a, b) => compareRaces(a, b, false))

    this.likely_trump = this.all
      .filter(x => x.diff_xibar < 0 && !x.zero_within_90)
      .sort((a, b) => compareRaces(a, b, true))

    this.battlegrounds = this.all
      .filter(x => x.zero_within_90)
      .sort((a, b) => compareRaces(a, b, true))

    this.likely_clinton_n_votes = countElectoralVotes(this.likely_clinton)
    this.battlegrounds_n_votes = countElectoralVotes(this.battlegrounds)
    this.likely_trump_n_votes = countElectoralVotes(this.likely_trump)
  }
}

PresidentRaces.load = function(curves) {
  const updated_at = fs.statSync(`${__dirname}/../data/sheets/output/president-summaries.tsv`).mtime

  const race_hashes = parseTsv.fromPath('data/sheets/input/president-races.tsv')
  const state_code_to_race_hash = {}
  race_hashes.forEach(h => state_code_to_race_hash[h.state_code] = h)

  const summaries = parseTsv.fromPath('data/sheets/output/president-summaries.tsv')
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
