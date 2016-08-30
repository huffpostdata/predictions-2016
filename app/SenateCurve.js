'use strict'

const ElectionDayS = '2016-11-08'
const TodayS = new Date().toISOString().slice(0, 10) // FIXME pass as parameter

const ChartHeight = 600
const ChartWidth = 1000

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
  constructor(points) {
    this.points = points
    this.today_point = this.points.find(p => p.date_s === TodayS)
    this.election_day_point = this.points[this.points.length - 1]

    this.is_plottable = this.points[0].dem_xibar !== null

    if (this.is_plottable) {
      const max_diff = points.reduce(((a, p) => Math.max(a, Math.abs(p.diff_low), Math.abs(p.diff_high))), 0.01)
      this.y_max = [ 0.03, 0.05, 0.10, 0.15, 0.20, 0.30, 0.40, 0.50 ].find(i => i > max_diff)
      this.x_min = this.points.findIndex(p => p.date_s >= '2016-07-01')
      this.x_max = this.points.length // 1 past end of chart
    }
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
