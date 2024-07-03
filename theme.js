const zen = false;
const scaleRatio = 1;
const scale = (value) => Math.floor(value * scaleRatio);

module.exports = {
  data: {
    contrast: 0,
    zen,
    font: "JetBrainsMono Nerd Font",
    gap: scale(0),
    round: scale(0),
    border: scale(4),
    fontSize: scale(11),
    scaleRatio,
    transparency: false,
    colors: {
      background: '{{ "#1f2430" | contrasted(contrast) }}',
      background_alt1: "{{ colors.background | light_darken(3) }}",
      background_alt2: "{{ colors.background | light_lighten(3) }}",
      magic_background:
        "{{ colors.background if transparency else colors.background_alt1 }}",
      grey1: "{{ colors.background | between(colors.foreground, 1, 10) }}",
      grey2: "{{ colors.background | between(colors.foreground, 2, 10) }}",
      grey3: "{{ colors.background | between(colors.foreground, 3, 10) }}",
      grey4: "{{ colors.background | between(colors.foreground, 4, 10) }}",
      grey5: "{{ colors.background | between(colors.foreground, 5, 10) }}",
      grey6: "{{ colors.background | between(colors.foreground, 6, 10) }}",
      grey7: "{{ colors.background | between(colors.foreground, 7, 10) }}",
      grey8: "{{ colors.background | between(colors.foreground, 8, 10) }}",
      grey9: "{{ colors.background | between(colors.foreground, 9, 10) }}",
      foreground: "#e9ebf0",
      red: '{{ "#f45c7f" | contrasted(contrast) }}',
      orange: '{{ "#f78c6c" | contrasted(contrast) }}',
      yellow: '{{ "#ecc48d" | contrasted(contrast) }}',
      green: '{{ "#addb67" | contrasted(contrast) }}',
      cyan: '{{ "#9fd4ff" | contrasted(contrast) }}',
      blue: '{{ "#6cbeff" | contrasted(contrast) }}',
      magenta: '{{ "#c792ea" | contrasted(contrast) }}',
    },
    theme: {
      primary: "{{ colors.yellow }}",
      secondary: "{{ colors.blue }}",
      info: "{{ colors.green }}",
      warn: "{{ colors.orange }}",
      hint: "{{ colors.magenta }}",
      error: "{{ colors.red }}",
    },
    syntax: {
      statement: "{{ colors.orange }}",
      function: "{{ colors.blue }}",
      variable: "{{ colors.foreground }}",
      include: "{{ colors.red }}",
      keyword: "{{ colors.red }}",
      struct: "{{ colors.red }}",
      string: "{{ colors.green }}",
      identifier: "{{ colors.blue }}",
      field: "{{ colors.cyan }}",
      parameter: "{{ colors.magenta }}",
      property: "{{ colors.cyan }}",
      punctuation: "{{ colors.foreground }}",
      constructor: "{{ colors.cyan }}",
      operator: "{{ colors.grey8 }}",
      preproc: "{{ colors.blue }}",
      constant: "{{ colors.orange }}",
      tag: "{{ colors.red }}",
      todo: "{{ colors.cyan }}",
      number: "{{ colors.orange }}",
      comment: "{{ colors.grey4 }}",
      type: "{{ colors.yellow }}",
      conditional: "{{ colors.red }}",
    },
  },
  filters: {
    darken: (tc, color) => tc(color).darken(10).desaturate(15).toHexString(),
    contrasted: (tc, color, contrast) =>
      tc(color).darken(contrast).saturate(contrast).toHexString(),
    lighten: (tc, color) => tc(color).lighten(10).saturate(15).toHexString(),
    stronger: (tc, color) => tc(color).darken(5).saturate(10).toHexString(),
    light_darken: (tc, color, qty) => tc(color).darken(qty).toHexString(),
    light_lighten: (tc, color, qty) => tc(color).lighten(qty).toHexString(),
    between: (tc, color, secondColor, step, maxStep) => {
      const gradient = ((100 - 100 / (maxStep - 1)) / (maxStep - 1)) * step;
      return tc.mix(color, secondColor, gradient).toHexString();
    },
  },
};
