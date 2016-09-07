#!/usr/bin/env node

'use strict'

const child_process = require('child_process')
const readline = require('readline')
const stream = require('stream')

const MinRebuildTime = 10 * 60 * 1000 // 10min, in ms

for (const key of [ 'AIRBRAKE_PROJECT_ID', 'AIRBRAKE_PROJECT_KEY', 'BASE_URL', 'S3_BUCKET' ]) {
  if (!process.env[key]) {
    console.error(`You must set the ${key} environment variable`)
    process.exit(1)
  }
}

const airbrake = require('airbrake').createClient(
  process.env.AIRBRAKE_PROJECT_ID,
  process.env.AIRBRAKE_PROJECT_KEY,
  'production' // because anything else disables Airbrake?
)
airbrake.handleExceptions() // for uncaught exceptions

function timestamp() {
  return new Date().toISOString()
}

function log_with_timestamp(message) {
  console.log(`${timestamp()} ${message}`)
}

function log_stream(s, prefix) {
  readline.createInterface({ input: s })
    .on('line', line => log_with_timestamp(`${prefix} ${line}`))
}

function call_callback_ensuring_duration(callback, beginTime, minDuration) {
  const duration = new Date() - beginTime
  if (duration <= minDuration) {
    setTimeout(callback, minDuration - duration)
  } else {
    process.nextTick(callback)
  }
}

/** Tries to notify Airbrake of a problem ... but doesn't die if it fails. */
function handleError(err) {
  airbrake.notify(err, (err) => {
    log_with_timestamp(`Airbrake says: "${err}"`)
  })
}

/**
 * Runs ./rebuild.sh and then calls callback().
 *
 * If the `./rebuild.sh` invocation fails, informs Airbrake.
 *
 * Throttles so `callback()` will never be called too frequently.
 */
function rebuild(callback) {
  const beginTime = new Date()

  function done() { call_callback_ensuring_duration(callback, beginTime, MinRebuildTime) }

  const env = {
    BASE_URL: process.env.BASE_URL,
    S3_BUCKET: process.env.S3_BUCKET,
    PATH: process.env.PATH // "/usr/bin/env node" --> "node" must be in PATH
  }

  const args = process.argv.slice(2) // Might be "fast" -- i.e., "./rebuild.sh fast"

  const child = child_process.spawn(`${__dirname}/rebuild.sh`, args, {
    env: env,
    cwd: __dirname
  })

  log_stream(child.stdout, '[stdout]')
  log_stream(child.stderr, '[stderr]')

  child.on('close', (code) => {
    if (code != 0) {
      log_with_timestamp(`ERROR: ./rebuild.sh returned error code ${code}`)
      handleError(new Error(`./rebuild.sh returned error code ${code}`))
    }
    done()
  })

  child.on('error', (err) => {
    log_with_timestamp(`ERROR: failed to start ./rebuild.sh: ${err.toString()}`)
    handleError(err)
    done()
  })
}

function rebuild_forever() {
  rebuild(rebuild_forever)
}

rebuild_forever()
