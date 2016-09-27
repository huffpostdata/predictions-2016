'use strict'

const fs = require('fs')

const Curve = require('./Curve')
const CurvePoint = require('./CurvePoint')
const parseTsv = require('../generator/parseTsv')

const ElectionDayS = '2016-11-08'

class Curves {
  constructor(state_code_to_curve) {
    this.state_code_to_curve = state_code_to_curve
  }

  get(key) {
    return this.state_code_to_curve.get(key)
  }
}

/**
 * Assumes uint8 is the byte [0-9a-f] and returns 0x0-0xf.
 */
function dehex8(uint8) {
  if (uint8 >= 0x61) {
    return uint8 - 0x57
  } else {
    return uint8 & 0xf
  }
}

/**
 * Assumes uint32 is [0-9a-f]{4} and returns 0x0000-0xffff.
 */
function dehex32(uint32) {
  return (dehex8((uint32 & 0xff000000) >> 24) << 12)
    | (dehex8((uint32 & 0x00ff0000) >> 16) << 8)
    | (dehex8((uint32 & 0x0000ff00) >> 8) << 4)
    | dehex8(uint32 & 0xff)
}

function buf_to_sample(buf) {
  const n_ints = buf.length >> 2
  const uint16s = new Array(n_ints)

  for (let i = 0; i < n_ints; i++) {
    const uint32 = buf.readUInt32BE(i * 4)
    uint16s[i] = dehex32(uint32)
  }

  return uint16s
}

function load_state_samples(senate_or_president, state_code) {
  const input_path = `${__dirname}/../data/sheets/output/${senate_or_president}-samples-${state_code}`
  const buf = fs.readFileSync(input_path)

  const lineLength = buf.indexOf('\n'.codePointAt(0))
  if (lineLength === 0) return []

  const n = Math.floor(buf.length / lineLength)

  const ret = new Array(n)
  for (let i = 0; i < n; i++) {
    const slice = buf.slice(i * (lineLength + 1), i * (lineLength + 1) + lineLength)
    ret[i] = buf_to_sample(slice)
  }

  return ret
}

/**
 * Returns a Map from state_code to [ { end_date_s: '2016-XX-XX', diff: -3 }, ... ]
 *
 * Args:
 *   senate_or_president: "senate" or "president"
 */
function load_all_state_polls(senate_or_president) {
  const array = parseTsv.fromPath(`data/sheets/output/${senate_or_president}-polls.tsv`)

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
  const tsv = fs.readFileSync(input_path, 'utf8')
  const array = parseTsv(tsv)
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
