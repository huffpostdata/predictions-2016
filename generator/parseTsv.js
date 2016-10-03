const fs = require('fs')

function parseTsv(string) {
  const rows = string.split(/\r?\n/)
  const header = rows[0].split(/\t/)
  const ret = []

  for (let i = 1; i < rows.length; i++) {
    const row = rows[i].split(/\t/)
    if (row.length === 1 && row[0].length === 0) continue

    const h = {}
    for (let j = 0; j < header.length; j++) {
      h[header[j]] = row[j]
    }
    ret.push(h)
  }

  return ret
}

parseTsv.fromPath = function(relative_path) {
  const path = `${__dirname}/../${relative_path}`
  const tsv = fs.readFileSync(path, 'utf8')
  return parseTsv(tsv)
}

module.exports = parseTsv
