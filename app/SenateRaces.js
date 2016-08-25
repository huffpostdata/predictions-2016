'use strict'

const SenateRace = require('./SenateRace')

const SortFunctions = {
  'dem-win-probability': function(a, b) {
    return (b.dem_win_probability - a.dem_win_probability) || a.state_code.localeCompare(b.state_code)
  }
}

class SenateRaces {
  constructor(all) {
    this.all = all
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

SenateRaces.load = function(hashes, curves) {
  const all = hashes.map(hash => {
    const curve = curves.get(hash.state)
    if (!curve) throw new Error(`Missing prediction data for state "${hash.state}"`)

    return new SenateRace(hash, curve)
  })

  return new SenateRaces(all)
}

module.exports = SenateRaces
