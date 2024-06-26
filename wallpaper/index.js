const { createCanvas } = require("canvas");
const fs = require("fs");
const path = require("path");
const input = toAbsolute(process.argv[2]);
const output = toAbsolute(process.argv[3]);

const settings = require(input);

function toAbsolute(filename) {
  if (path.isAbsolute(filename)) {
    return filename;
  } else return path.resolve(process.cwd(), filename);
}

function equidistantPoints(N, min, max) {
  return [...Array(N).keys()].map((i) =>
    Math.round(min + ((max - min) / (N - 1)) * i),
  );
}

function drawWave(context, frameSize, waveRect) {
  const curvesNumber = waveRect.waves * 2;
  const startX = waveRect.x;
  const startY = waveRect.y + waveRect.height / 2;

  var xs = equidistantPoints(curvesNumber, 0, waveRect.width);

  let randX = () => Math.random() * 2 + 2;
  let randY = () => Math.random() * 4 + 2;
  let randomForX1 = randX();
  let randomForX2 = randX();
  let randomForY1 = randY();
  let randomForY2 = randY();

  let curves = [];

  for (let i = 1; i < curvesNumber; i++) {
    const startX = xs[i - 1];
    const startY = waveRect.y + waveRect.height / 2;
    const endX = xs[i];
    const endY = waveRect.y + waveRect.height / 2;
    const even = i % 2 ? 1 : -1;
    const control1X = startX + (endX - startX) / randomForX1;
    const control1Y = startY + (waveRect.height / randomForY1) * even;
    const control2X = endX - (endX - startX) / randomForX2;
    const control2Y = startY + (waveRect.height / randomForY2) * even;

    curves.push([control1X, control1Y, control2X, control2Y, endX, endY]);

    randomForX1 = randomForX2;
    randomForY1 = randomForY2;
    randomForX2 = randX();
    randomForY2 = randY();
  }

  context.beginPath();
  context.moveTo(startX, startY);
  for (i = 0; i < curves.length; i++) {
    c = curves[i];
    context.bezierCurveTo(c[0], c[1], c[2], c[3], c[4], c[5]);
    context.moveTo(c[4], c[5]);
  }
  context.lineTo(curves.at(-1)[4], frameSize.height);
  context.lineTo(startX, frameSize.height);
  context.lineTo(startX, startY);
  context.closePath();
  context.fillStyle = waveRect.color;
  context.fill();
}

function drawWaves({ width, height, waves, colors }) {
  const layers = colors.length - 1;
  const waveHeight = height / layers;

  const canvas = createCanvas(width, height, "svg");
  const context = canvas.getContext("2d");
  context.fillStyle = colors[0];
  context.fillRect(0, 0, width, height);

  for (let i = 0; i < layers; i++) {
    drawWave(
      context,
      { height, width },
      {
        y: i * waveHeight,
        x: 0,
        height: waveHeight,
        width,
        waves,
        color: colors[i + 1],
      },
    );
  }

  fs.writeFileSync(output, canvas.toBuffer());
}

drawWaves(settings);
