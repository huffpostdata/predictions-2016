'use strict'

const ElectionDayS = '2016-11-08'
const TodayS = new Date().toISOString().slice(0, 10) // FIXME pass as parameter

module.exports = class SenateCurve {
  constructor(points) {
    this.points = points
    this.today_point = this.points.find(p => p.date_s === TodayS)
    this.election_day_point = this.points[this.points.length - 1]
  }
}
