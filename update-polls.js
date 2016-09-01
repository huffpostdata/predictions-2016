#!/usr/bin/env node

'use strict'

const fs = require('fs')
const csv_parse = require('csv-parse/lib/sync')
const sync_request = require('sync-request')

const read_config = require('./generator/read_config')
const GoogleSheets = require('./generator/GoogleSheets')

function get_race_tsv_lines(race) {
  const url = `http://elections.huffingtonpost.com/pollster/api/charts/${race.pollster_slug}.csv`
  console.log(`GET ${url}`)
  const text = sync_request('GET', url).getBody()
  const rows = csv_parse(text, { columns: true })
  return rows.map(row => `${race.state}\t${row.end_date}\t${parseFloat(row[race.dem_label]) - parseFloat(row[race.gop_label])}`)
}

function get_all_race_tsv_lines(races) {
  const lines_per_race = races
    .filter(r => r.pollster_slug !== '')
    .map(get_race_tsv_lines)
  return Array.prototype.concat.apply([], lines_per_race)
}

function refresh_polls_tsv() {
  const google_sheets = new GoogleSheets(read_config('google-sheets'))
  const races = google_sheets.slug_to_array('senate-races')
  const lines = get_all_race_tsv_lines(races)
  const text = `state\tend_date\tdem_lead\n${lines.join('\n')}`

  const filename = `${__dirname}/data/sheets/output/senate-polls.tsv`
  console.log(`WRITE ${filename}`)
  fs.writeFileSync(filename, text)
}

refresh_polls_tsv()
