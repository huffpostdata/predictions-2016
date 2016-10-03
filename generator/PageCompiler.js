'use strict'

const crypto = require('crypto')
const glob = require('glob')
const marko = require('marko')

const PageContext = require('./PageContext')

function md5sum(string) {
  const hash = crypto.createHash('md5')
  hash.update(string)
  return hash.digest('hex')
}

module.exports = class PageCompiler {
  constructor(config, base_path, base_url, assets, database, helpers_ctor) {
    this.base_path = base_path
    this.base_url = base_url
    this.config = config
    this.assets = assets
    this.database = database
    this.helpers_ctor = helpers_ctor
    this.cache = new Map()
  }

  get_template(key) {
    if (!this.cache.has(key)) {
      const path = `views/${key}.marko`
      const template = marko.load(path)
      this.cache.set(key, template)
    }

    return this.cache.get(key)
  }

  render_template(template_key, context) {
    const template = this.get_template(template_key)
    return template.renderSync(context)
  }

  render(key, object, data) {
    const template_key = object.template || key

    let body

    if (Buffer.isBuffer(data.model)) {
      body = data.model
    } else {
      const context = new PageContext(this, data)
      body = this.render_template(template_key, context)
    }

    return {
      body: body,
      headers: {
        'Content-Type': object['content-type'] || 'text/html; charset=utf-8',
        'Cache-Control': 'max-age=30',
        'ETag': md5sum(body)
      }
    }
  }

  render_all() {
    const out = this.output = {}
    const keys = Object.keys(this.config)

    for (const key of keys) {
      const object = this.config[key]
      const path = this.key_to_path(key)

      if (object.collection) {
        if (!this.database.hasOwnProperty(object.collection)) {
          throw new Error(`${key} requires database property "${object.collection}" which does not exist. Add it.`)
        }
        for (const model of this.database[object.collection]) {
          const out_path = path.replace(/:(\w+)/, (_, name) => model[name])
          out[out_path] = this.render(key, object, { model: model })
        }
      } else if (object.model) {
        const model = this.database[object.model];
        if (!model) {
          throw new Error(`There is no model for "${key}" in app/Database.js. Add one.`)
        }
        out[path] = this.render(key, object, { model: model })
      } else if (object.redirect) {
        out[path] = { redirect: this.key_to_path(object.redirect) }
      } else {
        out[path] = this.render(key, object, {})
      }
    }
  }

  key_to_path(key) {
    const path_object = this.config[key]

    if (!path_object) throw new Error(`There is no path with key ${key}. Maybe check config/pages.yml?`)

    if (typeof path_object === 'string') {
      return `${this.base_path}/${path_object}`
    } else if (path_object.path === '_root') {
      return this.base_path
    } else if (!path_object.path) {
      return `${this.base_path}/${key}`
    } else {
      return `${this.base_path}/${path_object.path}`
    }
  }
}
