const zen = false
const scaleRatio = 1
function scale (value) {
  return Math.floor(value * scaleRatio)
}

module.exports = {
  data: {
    zen,
    font: 'JetBrainsMono NF',
    gap: scale(0),
    round: scale(0),
    border: scale(4),
    fontSize: scale(10),
    scaleRatio,
    transparency: false,
    colors: {
      background: '#1f2430',
      background_alt1: '{{ colors.background | light_darken(3) }}',
      background_alt2: '{{ colors.background | light_lighten(3) }}',
      magic_background:
        '{{ colors.background if transparency else colors.background_alt1 }}',
      grey1: '{{ colors.background | between(colors.foreground, 1, 10) }}',
      grey2: '{{ colors.background | between(colors.foreground, 2, 10) }}',
      grey3: '{{ colors.background | between(colors.foreground, 3, 10) }}',
      grey4: '{{ colors.background | between(colors.foreground, 4, 10) }}',
      grey5: '{{ colors.background | between(colors.foreground, 5, 10) }}',
      grey6: '{{ colors.background | between(colors.foreground, 6, 10) }}',
      grey7: '{{ colors.background | between(colors.foreground, 7, 10) }}',
      grey8: '{{ colors.background | between(colors.foreground, 8, 10) }}',
      grey9: '{{ colors.background | between(colors.foreground, 9, 10) }}',
      foreground: '#e9ebf0',
      red: '#f45c7f',
      orange: '#f78c6c',
      yellow: '#ecc48d',
      green: '#addb67',
      cyan: '#9fd4ff',
      blue: '#6cbeff',
      magenta: '#c792ea'
    },
    theme: {
      primary: '{{ colors.yellow }}',
      secondary: '{{ colors.blue }}',
      info: '{{ colors.green }}',
      warn: '{{ colors.orange }}',
      alert: '{{ colors.red }}'
    }
  },
  filters: {
    darken: (tc, color) => tc(color).darken(10).desaturate(15).toHexString(),
    lighten: (tc, color) => tc(color).lighten(10).saturate(15).toHexString(),
    stronger: (tc, color) => tc(color).darken(5).saturate(10).toHexString(),
    light_darken: (tc, color, qty) => tc(color).darken(qty).toHexString(),
    light_lighten: (tc, color, qty) => tc(color).lighten(qty).toHexString(),
    between: (tc, color, secondColor, step, maxStep) => {
      const gradient = ((100 - 100 / (maxStep - 1)) / (maxStep - 1)) * step
      return tc.mix(color, secondColor, gradient).toHexString()
    }
  }
}
