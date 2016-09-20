'use strict'

const fs = require('fs')
const csv_parse = require('csv-parse/lib/sync')

const Curve = require('./Curve')
const CurvePoint = require('./CurvePoint')

const ElectionDayS = '2016-11-08'

class Curves {
  constructor(state_code_to_curve) {
    this.state_code_to_curve = state_code_to_curve
  }

  get(key) {
    return this.state_code_to_curve.get(key)
  }
}

function string_to_sample(string) {
  const buf = Buffer.from(string, 'hex')
  const n_ints = buf.length >> 1
  const uint16s = new Array(n_ints)

  for (let i = 0; i < n_ints; i++) {
    uint16s[i] = buf.readUInt16BE(i << 1, true)
  }

  return uint16s
}

function load_state_samples(senate_or_president, state_code) {
  const input_path = `${__dirname}/../data/sheets/output/${senate_or_president}-samples-${state_code}`
  const one_big_string = fs.readFileSync(input_path, 'binary')

  return one_big_string.split('\n')
    .filter(s => s.length > 0) // remove empty lines
    .map(string_to_sample)
}

/**
 * Returns a Map from state_code to [ { end_date_s: '2016-XX-XX', diff: -3 }, ... ]
 *
 * Args:
 *   senate_or_president: "senate" or "president"
 */
function load_all_state_polls(senate_or_president) {
  const input_path = `${__dirname}/../data/sheets/output/${senate_or_president}-polls.tsv`
  const tsv = fs.readFileSync(input_path)
  const array = csv_parse(tsv, { delimiter: '\t', columns: true })

  const ret = new Map()
  array.forEach(o => {
    if (!ret.has(o.state)) {
      ret.set(o.state, [])
    }
    ret.get(o.state).push({ end_date: o.end_date, diff: parseFloat(o.dem_lead) })
  })

  return ret
}

/**
 * Return a Curves: a collection with every curve.
 *
 * Args:
 *   senate_or_president: "senate" or "president"
 */
Curves.load = function(senate_or_president) {
  const input_path = `${__dirname}/../data/sheets/output/${senate_or_president}-curves.tsv`
  const tsv = fs.readFileSync(input_path)
  const array = csv_parse(tsv, { delimiter: '\t', columns: true })
  const updated_at = fs.statSync(input_path).mtime

  const curve_points = array.map(hash => new CurvePoint(hash))

  const state_code_to_points = new Map()
  curve_points.forEach(p => {
    if (!state_code_to_points.has(p.state_code)) {
      state_code_to_points.set(p.state_code, [])
    }
    state_code_to_points.get(p.state_code).push(p)
  })

  const state_code_to_polls = load_all_state_polls(senate_or_president)

  const state_code_to_curve = new Map()
  state_code_to_points.forEach((points, state_code) => {
    const samples = load_state_samples(senate_or_president, state_code)
    const polls = state_code_to_polls.get(state_code) || []
    state_code_to_curve.set(state_code, new Curve(updated_at, points, polls, samples))
  })

  return new Curves(state_code_to_curve)
}

module.exports = Curves
