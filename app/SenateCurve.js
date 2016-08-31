'use strict'

const ElectionDayS = '2016-11-08'
const TodayS = new Date().toISOString().slice(0, 10) // FIXME pass as parameter

const ChartHeight = 600
const ChartWidth = 1000

const UInt16Max = 0xffff

function calculate_sample_path_d(n_dates, date_width, y_max, uint16s) {
  const sized_uint16s = new Array(n_dates.length)
  for (let i = 0, j = uint16s.length - n_dates - 1; i < n_dates; i++, j++) {
    sized_uint16s[i] = j < 0 ? (UInt16Max >> 1) : uint16s[j]
  }

  let last_y = 0
  let last_x = 0

  const step = function(y_uint16, i) {
    const x = Math.round(date_width * i)
    const y = Math.round(ChartHeight / 2 - ChartHeight / 2 * (y_uint16 / UInt16Max * 2 - 1) / y_max)
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

  return sized_uint16s.map(step).join('')
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

  return `${last_x},${last_y}` + values.slice(1).map(step).join('')
}

module.exports = class SenateCurve {
  constructor(points, uint16_samples) {
    this.points = points
    this.uint16_samples = uint16_samples
    this.today_point = this.points.find(p => p.date_s === TodayS)
    this.election_day_point = this.points[this.points.length - 1]

    this.is_plottable = this.uint16_samples.length > 0

    if (this.is_plottable) {
      const max_diff = points.reduce(((a, p) => Math.max(a, Math.abs(p.diff_low), Math.abs(p.diff_high))), 0.01)
      this.y_max = [ 0.03, 0.05, 0.10, 0.15, 0.20, 0.30, 0.40, 0.50 ].find(y => y > max_diff)
      this.x_min = this.points.findIndex(p => p.date_s >= '2016-07-01')
      this.x_max = this.points.length // 1 past end of chart
    }
  }

  calculate_sample_svg_paths() {
    const n_dates = this.x_max - this.x_min
    const date_width = ChartWidth / (n_dates - 1)
    //const y_max_scaled_to_uint16 = (0.5 + this.y_max) * 0.5 * UInt16Max
    const y_height = (ChartHeight * 2 * this.y_max) / UInt16Max // height of any "1" of a uint16 (65535)

    return this.uint16_samples.map(uint16s => calculate_sample_path_d(n_dates, date_width, this.y_max, uint16s))
  }

  /**
   * Calculates "M0,0..." -- a line
   *
   * Assumes a 1000*600 chart size. The top 300 are positive spread; the bottom
   * 300 are negative spread. All values are integers (to save space).
   */
  svg_path(key) {
    const values = this.points.slice(this.x_min, this.x_max).map(p => p[key])
    return 'M' + values_to_path_d(values, { y_max: this.y_max })
  }

  /**
   * Calculate "M0,0..." -- a polygon of the area between key1 and key2
   *
   * Assumes a 1000*600 chart size. The top 300 are positive spread; the bottom
   * 300 are negative spread. All values are integers (to save space).
   */
  svg_polygon(key1, key2) {
    const points = this.points.slice(this.x_min, this.x_max);

    return 'M' +
      values_to_path_d(points.map(p => p[key1]), { y_max: this.y_max }) +
      'L' +
      values_to_path_d(points.map(p => p[key2]), { y_max: this.y_max, reverse: true }) +
      'Z'
  }
}
