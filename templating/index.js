const tinycolor = require("tinycolor2");
const nunjucks = require("nunjucks");
const path = require("path");
const fs = require("fs");
const childProcess = require("child_process");

const exec = childProcess.exec;

nunjucks.configure(".", {
  trimBlocks: true,
});

const template = require("./theme.js");

const colors = generateColors(template.palette);
const scaleRatio = getOrDefault(template.scaleRatio, 1.0);

const data = {
  colors,
  scaleRatio,
  font: getOrDefault(template.font, "Hasklug Nerd Font"),
  gap: scale(getOrDefault(template.gap, 0), scaleRatio),
  transparency: getOrDefault(template.transparency, false),
  round: scale(getOrDefault(template.round, 0), scaleRatio),
  border: scale(getOrDefault(template.border, 1), scaleRatio),
  fontSize: scale(getOrDefault(template.fontSize, 12), scaleRatio),
};

exec(
  `find . -type f -name "*.template" -mindepth 1 -printf "%P\n"`,
  function (_, stdout, _) {
    stdout
      .split("\n")
      .filter((it) => it !== "")
      .forEach((it) => {
        const content = fs.readFileSync(path.resolve(it), "utf8");
        const oldContent = fs.readFileSync(it.replace(".template", ""), "utf8");
        const renderedTemplate = nunjucks.renderString(content, data);

        if (renderedTemplate != oldContent) {
          fs.writeFileSync(it.replace(".template", ""), renderedTemplate);
        }
      });
  },
);

function getOrDefault(value, fallback) {
  if (value == undefined) {
    return fallback;
  }
  return value;
}

function generateColors(palette) {
  const colors = {};

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
  Array.from({ length: 10 }, (_, i) => i)
    .slice(1)
    .forEach((greyScale) => {
      colors[`grey${greyScale}`] = tinycolor
        .mix(background, foreground, ((100 - 100 / 9) / 9) * greyScale)
        .toHexString();
    });
  colors.foreground = foreground;

  return colors;
}

function scale(value, ratio) {
  return Math.floor(value * ratio);
}
