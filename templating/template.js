const tinycolor = require('tinycolor2')
const Nunjucks = require('nunjucks')

const env = Nunjucks.configure('.', {
  trimBlocks: true,
  throwOnUndefined: true
})

function generateComputed (computed, full) {
  Object.entries(computed).forEach(([key, value]) => {
    try {
      if (typeof value === 'string' && value.includes('{{')) {
        computed[key] = env.renderString(value, full)
      } else if (isObject(value)) {
        computed[key] = generateComputed(value, full)
      }
    } catch (_) { }
  })

  return computed
}

function isObject (item) {
  return item && typeof item === 'object' && !Array.isArray(item)
}

module.exports = function (content, template) {
  Object.entries(template.filters || {}).forEach(([key, value]) => {
    env.addFilter(key, (...args) => value(tinycolor, ...args))
  })

  let stringifiedData = JSON.stringify(template.data)
  while (true) {
    generateComputed(template.data, template.data)

    if (stringifiedData == JSON.stringify(template.data)) {
      if (stringifiedData.includes('{{')) {
        throw `Invalid template, actual data: ${JSON.stringify(template.data, null, 2)}`
      }
      break
    }
    stringifiedData = JSON.stringify(template.data)
  }

  return env.renderString(content, template.data)
}
