const tinycolor = require("tinycolor2");
const nunjucks = require("nunjucks");
const fs = require("fs");

nunjucks.configure(".", {
  trimBlocks: true,
});

const defaultSyntax = {
  statement: "orange",
  function: "blue",
  variable: "foreground",
  include: "magenta",
  keyword: "magenta",
  struct: "red",
  string: "green",
  identifier: "cyan",
  field: "cyan",
  parameter: "red",
  property: "orange",
  punctuation: "foreground",
  constructor: "cyan",
  operator: "grey8",
  preproc: "cyan",
  constant: "orange",
  tag: "red",
  todo_fg: "cyan",
  todo_bg: "grey1",
  number: "orange",
  comment: "grey4",
  type: "yellow",
  conditional: "red",
};

const files = {
  "theme/configs/alacritty": "alacritty/alacritty.yml",
  "theme/configs/tmux": "tmux/tmux.conf",
  "theme/configs/delta": ".delta",
  "theme/configs/dunst": "dunst/dunstrc",
  "theme/configs/i3": "i3/config",
  "theme/configs/kitty": "kitty/kitty.conf",
  "theme/configs/polybar": "polybar/config",
  "theme/configs/picom": "picom/picom.conf",
  "theme/configs/rofi": "rofi/theme.rasi",
  "theme/configs/vim": "nvim/lua/theme.lua",
};

const template = require(`../theme/scheme/${process.argv.slice(2)[0]}.json`);

let colors = generateColors(template.palette);
let scaleRatio = getOrDefault(template.scaleRatio, 1.0)

let data = {
  colors,
  scaleRatio,
  syntax: generateSyntax(template.syntax, colors),
  gap: scale(getOrDefault(template.gap, 0), scaleRatio),
  transparency: getOrDefault(template.transparency, false),
  round: scale(getOrDefault(template.round, 0), scaleRatio),
  border: scale(getOrDefault(template.border, 1), scaleRatio),
  fontSize: scale(getOrDefault(template.fontSize, 12), scaleRatio),
};

Object.entries(files).forEach(([from, to]) => {
  const renderedTemplate = nunjucks.render(from, data);

  fs.writeFileSync(to, renderedTemplate);
});

function getOrDefault(value, fallback) {
  if (value == undefined) {
    return fallback;
  }
  return value;
}

function generateColors(palette) {
  let colors = {};

  Object.entries(palette.colors).forEach(([key, color]) => {
    colors[`strong_${key}`] = tinycolor(color)
      .darken(5)
      .saturate(50)
      .toHexString();
    colors[`dark_${key}`] = tinycolor(color)
      .darken(10)
      .desaturate(15)
      .toHexString();
    colors[`${key}`] = color;
    colors[`light_${key}`] = tinycolor(color)
      .lighten(10)
      .saturate(15)
      .toHexString();
  });

  const background = palette.background;
  const foreground = palette.foreground;

  colors.background = background;
  colors.background_alt1 = tinycolor(background).darken(3).toHexString();
  colors.background_alt2 = tinycolor(background).lighten(3).toHexString();
  Array.from({ length: 10 }, (x, i) => i)
    .slice(1)
    .forEach((greyScale) => {
      colors[`grey${greyScale}`] = tinycolor
        .mix(background, foreground, ((100 - 100 / 9) / 9) * greyScale)
        .toHexString();
    });
  colors.foreground = foreground;

  return colors;
}

function generateSyntax(customSyntax, colors) {
  let syntax = { ...defaultSyntax, ...customSyntax };

  Object.entries(syntax).forEach(([key, value]) => {
    syntax[key] = colors[value];
  });

  return syntax;
}

function scale(value, ratio) {
  return Math.floor(value * ratio)
}
