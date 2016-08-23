'use strict'

const glob = require('glob')
const marko = require('marko')
const PageContext = require('./PageContext')

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

  render(template_key, data) {
    const context = new PageContext(this, data)
    return this.render_template(template_key, context)
  }

  render_all() {
    const out = this.output = {}
    const keys = Object.keys(this.config)

    for (const key of keys) {
      const object = this.config[key]
      const path = this.key_to_path(key)
      const template = object.template || key

      if (object.collection) {
        for (const model of this.database[object.collection]) {
          const out_path = path.replace(/:(\w+)/, (_, name) => model[name])
          out[out_path] = this.render(template, { model: model })
        }
      } else if (object.model) {
        const model = this.database[object.model];
        if (!model) {
          throw new Error(`There is no model for "${key}" in app/Database.js. Add one.`)
        }
        out[path] = this.render(template, { model: model })
      } else if (object.redirect) {
        out[path] = { redirect: this.key_to_path(object.redirect) }
      } else {
        out[path] = this.render(template, {})
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
