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
    } catch (_) {}
  })

  return computed
}

function isObject (item) {
  return item && typeof item === 'object' && !Array.isArray(item)
}

function mergeDeep (target, ...sources) {
  if (!sources.length) return target
  const source = sources.shift()

  if (isObject(target) && isObject(source)) {
    for (const key in source) {
      if (isObject(source[key])) {
        if (!target[key]) Object.assign(target, { [key]: {} })
        mergeDeep(target[key], source[key])
      } else {
        Object.assign(target, { [key]: source[key] })
      }
    }
  }

  return mergeDeep(target, ...sources)
}

module.exports = function (content, template) {
  Object.entries(template.filters || {}).forEach(([key, value]) => {
    env.addFilter(key, (...args) => value(tinycolor, ...args))
  })

  let stringifiedData = JSON.stringify(template.data)
  while (true) {
    generateComputed(template.computed, template.data)
    template.data = mergeDeep(template.data, template.computed)

    if (stringifiedData == JSON.stringify(template.data)) {
      if (stringifiedData.includes('{{')) {
        throw `Cyclic dependency found, actual computed data: ${JSON.stringify(template.computed, null, 2)}`
      }
      break
    }
    stringifiedData = JSON.stringify(template.data)
  }

  return env.renderString(content, template.data)
}
