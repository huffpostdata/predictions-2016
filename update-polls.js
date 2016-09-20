#!/usr/bin/env node

'use strict'

const csv_parse = require('csv-parse/lib/sync')
const sync_request = require('sync-request')

const read_config = require('./generator/read_config')
const GoogleSheets = require('./generator/GoogleSheets')

function get_race_tsv_lines(race) {
  const url = `http://elections.huffingtonpost.com/pollster/api/charts/${race.pollster_slug}.csv`
  console.warn(`GET ${url}`)
  const text = sync_request('GET', url).getBody()
  const rows = csv_parse(text, { columns: true })

  function rowDelta(row) {
    if (race.hasOwnProperty('dem_label')) {
      return parseFloat(row[race.dem_label]) - parseFloat(row[race.gop_label])
    } else {
      return parseFloat(row.Clinton) - parseFloat(row.Trump)
    }
  }

  function rowToLine(row) {
    return [
      race.state || race.state_code,
      row.end_date,
      rowDelta(row)
    ].join('\t')
  }

  return rows.map(rowToLine)
}

function get_all_race_tsv_lines(races) {
  const lines_per_race = races
    .filter(r => r.pollster_slug !== '')
    .map(get_race_tsv_lines)
  return Array.prototype.concat.apply([], lines_per_race)
}

function refresh_polls_tsv(senate_or_president) {
  const google_sheets = new GoogleSheets(read_config('google-sheets'))
  const races = google_sheets.slug_to_array(`${senate_or_president}-races`)
  const lines = get_all_race_tsv_lines(races)
  const text = `state\tend_date\tdem_lead\n${lines.join('\n')}`

  console.log(text)
}

if (process.argv.length != 3 || [ 'senate', 'president' ].indexOf(process.argv[2]) == -1) {
  console.error(`Usage: ${process.argv[0]} ${process.argv[1]} (senate|president)`)
  process.exit(1)
}

refresh_polls_tsv(process.argv[2])
