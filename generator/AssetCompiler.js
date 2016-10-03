'use strict'

const crypto = require('crypto')
const glob = require('glob')
const fs = require('fs')
const sass = require('node-sass')

function md5sum(string) {
  const hash = crypto.createHash('md5')
  hash.update(string)
  return hash.digest('hex')
}

function detect_content_type(path) {
  const m = /\.(\w+)$/.exec(path)
  if (!m) throw new Error(`Expected ${path} to have a file extension. Maybe add one?`)

  switch (m[1]) {
    case 'css': return 'text/css; charset=utf-8'
    case 'csv': return 'text/csv; charset=utf-8'
    case 'gif': return 'image/gif'
    case 'jpg': return 'image/jpeg'
    case 'js': return 'application/javascript; charset=utf-8'
    case 'png': return 'image/png'
    case 'svg': return 'image/svg+xml'
    case 'ico': return 'image/x-icon'
    case 'txt': return 'text/plain; charset=utf-8'
    default: throw new Error(`We do not understand the file extension ".${ext}". Maybe code logic for it?`)
  }
}

class Asset {
  constructor(key, data, options) {
    this.data = data

    if (!options) options = {}

    const digest = md5sum(data).substring(0, 8)

    if (options.calculate_digest !== false) {
      const m = /(.*)\.(\w+)/.exec(key)
      if (!m) throw new Error(`Asset with key ${key} has no file extension. Maybe add one?`)

      const basename = m[1]
      const extension = m[2]
      this.path = `${basename}-${digest}.${extension}`
    } else {
      this.path = key;
    }

    if (options.content_type) {
      this.content_type = options.content_type
    } else {
      this.content_type = detect_content_type(key)
    }

    this.max_age = parseInt(options.max_age || 0, 10)
  }
}

module.exports = class AssetCompiler {
  constructor(config) {
    this.config = config
  }

  get_asset(type, key) {
    if (!this.assets[type]) throw new Error(`No assets of type "${type}". Check assets.yml?`)

    const asset = this.assets[type][key]
    if (!asset) throw new Error(`Unknown asset "${type}/${key}". Maybe add it to assets.yml?`)

    return asset
  }

  asset_path(type, key) {
    const asset = this.get_asset(type, key)
    return asset.path
  }

  full_asset_path(type, key) {
    return `${this.config.base_path}/${this.asset_path(type, key)}`
  }

  data(type, key) {
    const asset = this.get_asset(type, key)
    return asset.data
  }

  build_all() {
    this.assets = {}

    this.build_digest()
    this.build_plain()
    this.build_scss()
  }

  build_plain() {
    const out = this.assets.plain = {}
    if(Object.keys(this.config).indexOf("plain") !== -1){
      for (const key of Object.keys(this.config.plain)) {
        const source = this.config.plain[key]
        const data = fs.readFileSync(source)
        out[key] = new Asset(key, data, { max_age: 500000, calculate_digest: false })
      }
    }
  }

  build_digest() {
    const out = this.assets.digest = {}

    for (const object of this.config.digest) {
      const pattern = object.pattern
      const paths = glob.sync(`assets/${pattern}`)

      for (const path of paths) {
        const key = path.substring(7)
        const data = fs.readFileSync(path)
        out[key] = new Asset(key, data, { content_type: object.content_type, max_age: object.max_age })
      }
    }
  }

  build_scss() {
    const out = this.assets.scss = {}

    const bundles = Object.keys(this.config.scss)

    for (const bundle of bundles) {
      const filename = `assets/${this.config.scss[bundle]}`
      const key = `stylesheets/${bundle}`

      let css;
      
      try {
        css = sass.renderSync({
          file: filename,
          outputStyle: 'compact',
          functions: {
            'asset-as-url($type, $key)': (type, key) => {
              const asset = this.get_asset(type.getValue(), key.getValue())
              switch (asset.content_type) {
                case 'image/svg+xml':
                  return new sass.types.String(`url('data:image/svg+xml;base64,${asset.data.toString('base64')}')`)
                  break
                default:
                  throw new Error(`Don't know how to encode a ${asset.content_type} as a CSS URL. Write code here?`)
              }
            },
            'asset-url($type, $key)': (type, key) => {
              return new sass.types.String(`url(${this.full_asset_path(type.getValue(), key.getValue())})`)
            }
          }
        }).css
      } catch (e) {
        // node-sass errors are weird
        e.message = e.formatted
        throw e
      }

      out[key] = new Asset(key, css, { content_type: 'text/css; charset=utf-8', max_age: 8640000000 }) // far-future expires
    }
  }
}
