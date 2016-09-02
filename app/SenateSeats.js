'use strict'

module.exports = class SenateSeats {
  constructor(all) {
    this.all = all

    this.class_3_by_state_code = new Map()
    all.forEach(seat => {
      if (seat.seat_class == 3) {
        this.class_3_by_state_code.set(seat.state_code, seat)
      }
    })
  }

  get_class_3(state_code) {
    return this.class_3_by_state_code.get(state_code)
  }
}
