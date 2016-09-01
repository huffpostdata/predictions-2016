'use strict'

const ElectionDayS = '2016-11-08'
const StartDayS = '2016-07-01'
const NDays = Math.round((new Date(ElectionDayS) - new Date(StartDayS)) / 86400000) + 1

const ChartHeight = 600
const ChartWidth = 1000
const DateWidth = ChartWidth / (NDays - 1)

const UInt16Max = 0xffff

/**
 * Given an Array of values per day that ends on 2016-11-08 (inclusive), make an
 * Array of the constant length that we want, so the first day is StartDayS
 * (inclusive).
 *
 * If `array` is too short, we create a new Array that starts with `null`s.
 *
 * If `array` is too long, we return only the last values.
 */
function make_array_fill_our_date_range(array) {

  if (array.length < NDays) {
    const nulls = new Array()
    nulls.fill(null, 0, NDays - array.length)
    return nulls.concat(array)
  } else if (array.length > NDays) {
    return array.slice(array.length - NDays)
  } else {
    return array
  }
}

/**
 * Returns a fraction in the range [ -1.0, 1.0 ]
 */
function uint16_to_fraction(uint16) {
  return (uint16 / UInt16Max) * 2 - 1
}

/**
 * Calls `f` (Math.max or Math.min) on all uint16_samples -- each being a curve
 * of uint16 values.
 */
function simple_reduce_samples(uint16_samples, f) {
  const one_per_sample = uint16_samples.map(u16s => f.apply(null, u16s))
  return f.apply(null, one_per_sample)
}

function calculate_sample_path_d(y_max, uint16s) {
  let last_y = 0
  let last_x = 0

  const step = function(y_uint16, i) {
    const x = Math.round(DateWidth * i)
    const y = Math.round(ChartHeight / 2 - ChartHeight / 2 * uint16_to_fraction(y_uint16) / y_max)
    const dx = x - last_x
    const dy = y - last_y
    last_x = x
    last_y = y

    if (i === 0) {
      return `M${dx},${dy} l`
    } else {
      return ` ${dx},${dy}`
    }
  }

  return uint16s.map(step).join('')
}

function values_to_path_d(raw_values, options) {
  const convert_y = ChartHeight / 2 / options.y_max;
  const convert_x = ChartWidth / (raw_values.length - 1);
  const reverse = options.reverse === true

  const values = raw_values.map(v => Math.round(ChartHeight / 2 - convert_y * v))

  if (reverse) values.reverse()

  let last_y = values[0]
  let last_x = reverse ? ChartWidth : 0

  const v = function(dy) { return dy === 0 ? '' : `v${dy}` }

  const step = function(y, i) {
    const raw_x = Math.round(convert_x * (i + 1))
    const x = reverse ? ChartWidth - raw_x : raw_x
    const dx = x - last_x
    const dy = y - last_y
    last_y = y
    last_x = x
    if (reverse) {
      return `${v(dy)}h${dx}`
    } else {
      return `h${dx}${v(dy)}`
    }
  }

  return `M${last_x},${last_y}` + values.slice(1).map(step).join('')
}

module.exports = class SenateCurve {
  constructor(updated_at, points, uint16_samples) {
    this.election_day_point = points[points.length - 1]

    this.is_plottable = uint16_samples.length > 0

    if (this.is_plottable) {
      const max_y_uint16 = simple_reduce_samples(uint16_samples, Math.max)
      const min_y_uint16 = simple_reduce_samples(uint16_samples, Math.min)
      const max_diff = Math.max(Math.abs(uint16_to_fraction(max_y_uint16)), Math.abs(uint16_to_fraction(min_y_uint16)))
      console.log(max_y_uint16, min_y_uint16, max_diff)

      this.y_max = [ 0.03, 0.05, 0.10, 0.15, 0.20, 0.30, 0.40, 0.50 ].find(y => y > max_diff)
      this.date_width = DateWidth

      // Today is `updated_at_x` days from the start of this chart
      this.updated_at_x = Math.round((new Date(updated_at.toISOString().slice(0, 10)) - new Date(StartDayS)) / 86400000)

      this.points = make_array_fill_our_date_range(points)
      this.uint16_samples = make_array_fill_our_date_range(uint16_samples)
    }
  }

  calculate_sample_svg_paths() {
    //const y_max_scaled_to_uint16 = (0.5 + this.y_max) * 0.5 * UInt16Max
    const y_height = (ChartHeight * 2 * this.y_max) / UInt16Max // height of any "1" of a uint16 (65535)

    return this.uint16_samples.map(uint16s => calculate_sample_path_d(this.y_max, uint16s))
  }

  /**
   * Calculates "M0,0..." -- a line
   *
   * Assumes a 1000*600 chart size. The top 300 are positive spread; the bottom
   * 300 are negative spread. All values are integers (to save space).
   */
  svg_path(key) {
    return values_to_path_d(this.points, { y_max: this.y_max })
  }
}
