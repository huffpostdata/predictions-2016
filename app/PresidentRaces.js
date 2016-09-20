'use strict'

class PresidentRaces {
  constructor() {
    this.updated_at_s = 'TKupdated_at_s'
    this.all = []
  }
}

PresidentRaces.load = function() {
  return new PresidentRaces()
}

module.exports = PresidentRaces
