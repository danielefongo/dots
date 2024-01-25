const tinycolor = require('tinycolor2')
const Nunjucks = require('nunjucks')
const path = require('path')
const fs = require('fs')
const childProcess = require('child_process')
const { globSync } = require('glob')

const exec = childProcess.exec

const env = Nunjucks.configure('.', { trimBlocks: true })

function getOrDefault (value, fallback) {
  if (value == undefined) {
    return fallback
  }
  return value
}

function generateColors (palette) {
  const colors = {}

  Object.entries(palette.colors).forEach(([key, color]) => {
    colors[`strong_${key}`] = tinycolor(color)
      .darken(5)
      .saturate(50)
      .toHexString()
    colors[`dark_${key}`] = tinycolor(color)
      .darken(10)
      .desaturate(15)
      .toHexString()
    colors[`${key}`] = color
    colors[`light_${key}`] = tinycolor(color)
      .lighten(10)
      .saturate(15)
      .toHexString()
  })

  const background = palette.background
  const foreground = palette.foreground

  colors.background = background
  colors.background_alt1 = tinycolor(background).darken(3).toHexString()
  colors.background_alt2 = tinycolor(background).lighten(3).toHexString()
  Array.from({ length: 10 }, (_, i) => i)
    .slice(1)
    .forEach((greyScale) => {
      colors[`grey${greyScale}`] = tinycolor
        .mix(background, foreground, ((100 - 100 / 9) / 9) * greyScale)
        .toHexString()
    })
  colors.foreground = foreground

  return colors
}

function scale (value, ratio) {
  return Math.floor(value * ratio)
}

function generateTheme (themeData, colors) {
  Object.entries(themeData).forEach(([key, value]) => {
    if (typeof value === 'object' && !Array.isArray(value) && value !== null) {
      themeData[key] = generateTheme(value, colors)
    } else if (colors[value]) {
      themeData[key] = colors[value]
    }
  })

  return themeData
}

module.exports = (file) => {
  delete require.cache[require.resolve('./theme.js')]
  const template = require('./theme.js')

  const colors = generateColors(template.palette)
  const scaleRatio = getOrDefault(template.scaleRatio, 1.0)

  const data = {
    colors,
    scaleRatio,
    font: getOrDefault(template.font, 'Hasklug Nerd Font'),
    gap: scale(getOrDefault(template.gap, 0), scaleRatio),
    transparency: getOrDefault(template.transparency, false),
    round: scale(getOrDefault(template.round, 0), scaleRatio),
    border: scale(getOrDefault(template.border, 1), scaleRatio),
    fontSize: scale(getOrDefault(template.fontSize, 12), scaleRatio),
    theme: generateTheme(template.theme, colors)
  }

  const destinationFile = path.join('output', file)
  const destinationFileFolder = path.dirname(destinationFile)

  if (!fs.existsSync(destinationFileFolder)) {
    fs.mkdirSync(destinationFileFolder, { recursive: true })
  }

  const content = fs.readFileSync(path.resolve(file), 'utf8')
  const oldContent = fs.existsSync(destinationFile)
    ? fs.readFileSync(destinationFile, 'utf8')
    : {}

  let newContent
  try {
    newContent = env.renderString(content, data)
  } catch (e) {
    console.log(`Failed to render template for file ${file}`)
    return
  }

  if (newContent != oldContent) {
    fs.writeFileSync(destinationFile, newContent)

    return destinationFile
  }
}
