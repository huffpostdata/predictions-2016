'use strict'

const fs = require('fs')
const csv_parse = require('csv-parse/lib/sync')

const SenateCurve = require('./SenateCurve')
const SenateCurvePoint = require('./SenateCurvePoint')

const ElectionDayS = '2016-11-08'
const TodayS = new Date().toISOString().slice(0, 10) // FIXME pass as parameter

class SenateCurves {
  constructor(state_code_to_curve) {
    this.state_code_to_curve = state_code_to_curve
  }

  get(key) {
    return this.state_code_to_curve.get(key)
  }
}

SenateCurves.load = function() {
  const input_path = `${__dirname}/../data/sheets/output/senate-curves-${TodayS}.tsv`
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
    state_code_to_curve.set(state_code, new SenateCurve(points))
  })

  return new SenateCurves(state_code_to_curve)
}

module.exports = SenateCurves
