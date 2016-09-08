'use strict'

const GoogleDocs = require('./GoogleDocs')

const google_docs = new GoogleDocs({ code_path: 'app/google-docs' }) // TODO don't hard-code code_path

module.exports = class PageContext {
  constructor(compiler, locals) {
    this.compiler = compiler
    this.base_path = compiler.base_path
    this.base_url = compiler.base_url
    this.db = compiler.database
    this.assets = compiler.assets
    this.helpers = new compiler.helpers_ctor(this)
    this.render_template = (key, data) => compiler.render_template(key, data)

    for (const key of Object.keys(locals)) {
      this[key] = locals[key]
    }
  }

  render_google_doc(slug) {
    return google_docs.render(slug, this)
  }

  path_to_asset(type, key) {
    return `${this.base_path}/${this.assets.asset_path(type, key)}`
  }

  asset_contents(type, key) {
    return this.assets.data(type, key)
  }

  /**
   * Builds a URL to a page.
   *
   *   // Given a route `my-thing: my-things/:arg1/:arg2` in config/pages.yml
   *   ctx.path_to('my-thing', 'foo', 'bar') // '/base/my-things/foo/bar'
   */
  path_to(key) {
    const path = this.compiler.key_to_path(key)

    const n_path_params = (/:/g.exec(path) || []).length
    const params = Array.prototype.slice.call(arguments, 1)

    if (n_path_params != params.length) throw new Error(`The path ${key} has ${n_path_params} params, but you supplied ${params.length} (${JSON.stringify(params)}). Maybe adjust the params to path_to()?`)

    const interpolated_path = path.replace(/:(\w+)/g, () => params.shift())

    return `${interpolated_path}`
  }

  url_to_asset(type, key) {
    return `${this.base_url}${this.path_to_asset(type, key)}`
  }

  url_to(key) {
    let params
    if (Array.isArray(key)) {
      params = key.slice(1)
      key = key[0]
    } else {
      params = Array.prototype.slice.call(arguments, 1)
    }
    return `${this.base_url}${this.path_to(key, ...params)}`
  }
}
