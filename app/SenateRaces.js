'use strict'

const SenateRace = require('./SenateRace')

const SortFunctions = {
  'dem-win-probability': function(a, b) {
    return (Math.round(1000 * b.dem_win_probability) - Math.round(1000 * a.dem_win_probability)) || a.state_name.localeCompare(b.state_name)
  },
  'flip-probability': function(a, b) {
    return (Math.round(1000 * b.flip_prob) - Math.round(1000 * a.flip_prob)) || a.state_code.localeCompare(b.state_code)
  }
}

class SenateRaces {
  constructor(all) {
    this.all = all
    this.updated_at = new Date(Math.max.apply(null, all.map(race => race.updated_at)))
    this._by = {}
  }

  sorted_by(key) {
    if (this._by.hasOwnProperty(key)) return this._by[key]

    if (!SortFunctions.hasOwnProperty(key)) {
      throw new Error(`Invalid sort key ${key}; possible values are ${Object.keys(SortFunctions).join(', ')}`)
    }

    return this._by[key] = this.all.slice().sort(SortFunctions[key])
  }
}

SenateRaces.load = function(hashes, seats, curves) {
  const all = hashes.map(hash => {
    const seat = seats.get_class_3(hash.state)
    if (!seat) throw new Error(`Missing seat data for state "${hash.state}"`)

    const curve = curves.get(hash.state)
    if (!curve) throw new Error(`Missing prediction data for state "${hash.state}"`)

    return new SenateRace(hash, seat, curve)
  })

  return new SenateRaces(all)
}

module.exports = SenateRaces
