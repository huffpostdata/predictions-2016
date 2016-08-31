'use strict'

const fs = require('fs')
const csv_parse = require('csv-parse/lib/sync')

const SenateCurve = require('./SenateCurve')
const SenateCurvePoint = require('./SenateCurvePoint')

const ElectionDayS = '2016-11-08'

class SenateCurves {
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

function load_state_samples(state_code) {
  const input_path = `${__dirname}/../data/sheets/output/senate-samples-${state_code}`
  const one_big_string = fs.readFileSync(input_path, 'binary')

  return one_big_string.split('\n')
    .filter(s => s.length > 0) // remove empty lines
    .map(string_to_sample)
}

SenateCurves.load = function() {
  const input_path = `${__dirname}/../data/sheets/output/senate-curves.tsv`
  const tsv = fs.readFileSync(input_path)
  const array = csv_parse(tsv, { delimiter: '\t', columns: true })

  const curve_points = array.map(hash => new SenateCurvePoint(hash))

  const state_code_to_points = new Map()
  curve_points.forEach(p => {
    if (!state_code_to_points.has(p.state_code)) {
      state_code_to_points.set(p.state_code, [])
    }
    state_code_to_points.get(p.state_code).push(p)
  })

  const state_code_to_curve = new Map()
  state_code_to_points.forEach((points, state_code) => {
    const samples = load_state_samples(state_code)
    state_code_to_curve.set(state_code, new SenateCurve(points, samples))
  })

  return new SenateCurves(state_code_to_curve)
}

module.exports = SenateCurves
