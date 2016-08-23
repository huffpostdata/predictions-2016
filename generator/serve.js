'use strict'

const compression = require('compression')
const express = require('express')
const http = require('http')
const morgan = require('morgan')

const App = require('./App')

const output = App.build_output_from_scratch()

if (output.error) {
  console.log('Serving this error:', output.error.stack)
} else {
  //console.log('Serving these assets and pages', Object.keys(output.assets), Object.keys(output.pages))
}

function render_404(output) {
  const page_paths = Object.keys(output.pages).sort()
  const page_items = page_paths.map((s) => `<li><a href="${s}">${s}</a></li>`)

  const asset_paths = Object.keys(output.assets).sort()
  const asset_items = asset_paths.map((s) => `<li><a href="${s}">${s}</a></li>`)

  return `<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>404</title></head><body><h1>404</h1><p>This is a friendly 404 error.</p><p>The path you requested does not exist. As this is a development environment, we list all possible paths here.</p><h2>Pages</h2><ul>${page_items.join('')}</ul><h2>Assets</h2><ul>${asset_items.join('')}</ul></body></html>`
}

const app = express()
app.use(morgan('short'))
app.use(compression())
app.get(/.*/, (req, res) => {
  if (output.error) {
    res.set('Content-Type', 'text/plain; charset=utf-8')
    res.status(500).send(output.error.stack)
  } else {
    const key = req.url.split('?', 1)[0] // Behave like S3. S3 ignores query params.
    const data = output.get(key)

    if (data === null) {
      res.set('Content-Type', 'text/html; charset=utf-8')
      res.status(404).send(render_404(output))
    } else if (data.hasOwnProperty('redirect')) {
      res.set('Location', data.redirect)
      res.status(302).send()
    } else {
      res.set(data.headers)
      res.status(200).send(data.body)
    }
  }
})

if (process.argv.indexOf('--child') != -1) {
  const server = http.createServer(app)

  process.on('message', (m, socket) => {
    if (m === 'socket') {
      socket.resume()
      server.emit('connection', socket)
    }
  })

  console.log('Ready for connections...')
} else {
  app.listen(3000)
}
