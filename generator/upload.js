#!/usr/bin/env node

'use strict'

const App = require('./App')
const AWS = require('./AWS')

const output = App.build_output_from_scratch()

if (output.error) throw output.error

AWS.upload_assets_and_pages(output.assets, output.pages)
  .then(null, console.warn) // or throw the error asynchronously
