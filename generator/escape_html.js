'use strict'

const Escapes = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&apos;'
}
const EscapeRegex = new RegExp(`([${Object.keys(Escapes).join('')}])`, 'g')

module.exports = function escape_html(html) {
  return html.replace(EscapeRegex, (c) => Escapes[c])
}
