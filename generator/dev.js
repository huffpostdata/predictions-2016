#!/usr/bin/env node

'use strict'

const chokidar = require('chokidar')
const read_config = require('./read_config')
const fork = require('child_process').fork

let need_rebuild = null
let child = null

function queue_rebuild() {
  if (!need_rebuild) {
    need_rebuild = true
    setTimeout(rebuild, 100)
  }
}

chokidar.watch('app assets config data generator views'.split(' '), {
  ignored: /([\/\\]\.|.*.marko.js$)/
})
  .on('change', queue_rebuild)
  .on('add', queue_rebuild)
  .on('unlink', queue_rebuild)

function rebuild() {
  if (child) child.kill() // move along; NodeJS will reap the child soon

  child = fork(`${__dirname}/serve.js`, [ '--child' ])

  need_rebuild = false
}

const server = require('net').createServer({ pauseOnConnect: true })
server.listen(3000, () => {
  server.removeAllListeners('connection') // the child will handle them

  server.on('connection', (socket) => {
    child.send('socket', socket)
  })

  console.log('Listening on http://localhost:3000')
  console.log('')
  console.log('If you change a file, all will be reloaded.')
  console.log('')
  console.log('Edit code in app/ and assets/')
  console.log('')
  console.log('Tweak configuration in config/')
  console.log('')
  console.log('Use Ctrl+C to kill the server. Do it after git pull to be safe, too.')
  console.log('')
})

rebuild()
