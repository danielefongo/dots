const tinycolor = require('tinycolor2')
const nunjucks = require('nunjucks')
const fs = require('fs')

nunjucks.configure('.')

const defaultSyntax = {
  statement: 'orange',
  function: 'blue',
  variable: 'white',
  include: 'magenta',
  keyword: 'magenta',
  struct: 'red',
  string: 'green',
  identifier: 'cyan',
  field: 'cyan',
  parameter: 'red',
  property: 'orange',
  punctuation: 'white',
  constructor: 'cyan',
  operator: 'grey8',
  preproc: 'cyan',
  constant: 'orange',
  tag: 'red',
  todo_fg: 'cyan',
  todo_bg: 'grey1',
  number: 'orange',
  comment: 'grey4',
  type: 'yellow',
  conditional: 'red'
}

const files = {
  'theme/configs/delta': '.delta',
  'theme/configs/dunst': 'dunst/dunstrc',
  'theme/configs/i3': 'i3/theme.conf',
  'theme/configs/kitty': 'kitty/colors.conf',
  'theme/configs/polybar': 'polybar/colors.polybar',
  'theme/configs/rofi': 'rofi/theme.rasi',
  'theme/configs/vim': 'nvim/lua/theme.lua'
}

const template = require(`../theme/scheme/${process.argv.slice(2)[0]}.json`)
const colors = {}

Object.entries(template.palette).forEach(([key, color]) => {
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

const black = template.black
const white = template.white

colors.dark_black = tinycolor(black).darken(3).toHexString()
colors.black = black
colors.light_black = tinycolor(black).lighten(3).toHexString()
Array.from({ length: 10 }, (x, i) => i)
  .slice(1)
  .forEach((greyScale) => {
    colors[`grey${greyScale}`] = tinycolor
      .mix(black, white, ((100 - 100 / 9) / 9) * greyScale)
      .toHexString()
  })
colors.white = white

const customSyntax = template.syntax || {}
const syntax = { ...defaultSyntax, ...customSyntax }
Object.entries(syntax).forEach(([key, value]) => {
  syntax[key] = colors[value]
})

Object.entries(files).forEach(([from, to]) => {
  const renderedTemplate = nunjucks.render(from, {
    colors,
    syntax
  })

  fs.writeFileSync(to, renderedTemplate)
})
