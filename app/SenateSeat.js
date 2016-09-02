'use strict'

module.exports = class SenateSeat {
  constructor(hash) {
    this.bio_id = hash.bio_id
    this.seat_class = +hash['class']
    this.label = hash.label
    this.name = hash.name
    this.party_code = hash.party.toLowerCase()
    this.state_code = hash.state
  }
}
