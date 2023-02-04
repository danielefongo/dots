const tinycolor = require('tinycolor2')
const fs = require('fs')

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
  todo_bg: 'dark_grey1',
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
  'theme/configs/vim': 'nvim/lua/config/theme.lua'
}

const template = require(`../theme/scheme/${process.argv.slice(2)[0]}.json`)
const mapping = {}

Object.entries(template.palette).forEach(([key, color]) => {
  mapping[`strong_${key}`] = tinycolor(color)
    .darken(5)
    .saturate(50)
    .toHexString()
  mapping[`dark_${key}`] = tinycolor(color)
    .darken(10)
    .desaturate(15)
    .toHexString()
  mapping[`${key}`] = color
  mapping[`light_${key}`] = tinycolor(color)
    .lighten(10)
    .saturate(15)
    .toHexString()
})

const black = template.black
const white = template.white

mapping.dark_black = tinycolor(black).darken(3).toHexString()
mapping.black = black
mapping.light_black = tinycolor(black).lighten(3).toHexString()
Array.from({ length: 10 }, (x, i) => i)
  .slice(1)
  .forEach((greyScale) => {
    mapping[`grey${greyScale}`] = tinycolor
      .mix(black, white, ((100 - 100 / 9) / 9) * greyScale)
      .toHexString()
  })
mapping.white = white

const customSyntax = template.syntax || {}
const syntax = { ...defaultSyntax, ...customSyntax }
Object.entries(syntax).forEach(([key, value]) => {
  syntax[key] = mapping[value]
})

Object.entries(files).forEach(([from, to]) => {
  fs.readFile(from, 'utf8', (err, data) => {
    if (err) return console.log(err)

    Object.entries(mapping).forEach(([key, value]) => {
      data = data.replaceAll(`$COLOR_${key.toUpperCase()}`, value)
    })

    Object.entries(syntax).forEach(([key, value]) => {
      data = data.replaceAll(`$SYNTAX_${key.toUpperCase()}`, value)
    })

    fs.writeFile(to, data, 'utf8', () => { })
  })
})
