'use strict'

const PageContext = require('../generator/PageContext')
const escape_html = require('../generator/escape_html')

const Months = [ 'Jan.', 'Feb.', 'March', 'April', 'May', 'June', 'July', 'Aug.', 'Sept.', 'Oct.', 'Nov.', 'Dec.' ];

function extend_context(context, locals) {
  const new_locals = Object.assign({ model: context.model }, context.locals, locals)
  return new PageContext(context.compiler, new_locals)
}

class Helpers {
  constructor(context) {
    this.context = context
  }

  partial(name, options) {
    const context = extend_context(this.context, options || {})
    return this.context.render_template(name, context)
  }

  link_to(name, ...route) {
    return `<a href="${escape_html(this.context.path_to(...route))}">${escape_html(name)}</a>`
  }

  // Changes 'Written by [Adam Hooper]' to 'Written by <a href="..."></a>'
  format_authors(author) {
    function name_to_href(name) {
      // No idea if this permalinking function is correct.
      const slug = name.toLowerCase().replace(/[^\w]+/g, '-')
      return `//www.huffingtonpost.com/${slug}`
    }

    // Not HTML-safe. That should be fine.
    return author
      .replace(/\[([^\]]+)\]/g, (_, name) => `<a rel="author" href="${name_to_href(name)}">${name}</a>`)
  }

  format_date(date) {
    return `${Months[date.getMonth()]} ${date.getDate()}`
  }
}

module.exports = Helpers
