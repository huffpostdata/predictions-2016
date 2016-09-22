'use strict'

const fs = require('fs')
const csv_parse = require('csv-parse/lib/sync')

const NToTie = 269;
const NToWin = 270;

function sum(array) {
  return array.reduce(((s, n) => s + n), 0)
}

class PresidentVoteCounts {
  constructor(vote_count_to_n) {
    this.vote_count_to_n = vote_count_to_n

    this.n = sum(vote_count_to_n)
    this.n_clinton = sum(vote_count_to_n.slice(NToWin))
    this.n_tie = vote_count_to_n[NToTie]
    this.n_trump = this.n - this.n_clinton - this.n_tie

    this.max = Math.max.apply(null, vote_count_to_n)

    this.percent_clinton = 100 * this.n_clinton / this.n
    this.percent_tie = 100 * this.n_tie / this.n
    this.percent_trump = 100 * this.n_trump / this.n

    this.n_clinton_millions = this.n_clinton / 1e6

    this.one_percent = 100 * 0.01 / (this.max / this.n)
    this.point_five_percent = 100 * .005 / (this.max / this.n)
  }
}

PresidentVoteCounts.load = function() {
  const input_path = `${__dirname}/../data/sheets/output/president-vote-counts.tsv`
  const tsv = fs.readFileSync(input_path)
  const array = csv_parse(tsv, { delimiter: '\t', columns: true })

  const counts = array.map(o => +o.n) // [ 0, 0, 0, ... ]: index is vote count
  return new PresidentVoteCounts(counts)
}

module.exports = PresidentVoteCounts
