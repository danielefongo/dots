module.exports = {
  data: {
    contrast: 0,
    zen: false,
    focus: 6,
    font: "FiraCode Nerd Font",
    gap: 0,
    round: 0,
    border: 4,
    fontSize: 12,
    transparency: 0,
    colors: {
      unknown: "#ff0000",
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
      // :h treesitter<cr>
      "@variable": { fg: "{{ colors.foreground }}" },
      "@variable.builtin": { fg: "{{ colors.foreground }}" },
      "@variable.parameter": { fg: "{{ colors.magenta }}" },
      "@variable.parameter.builtin": { fg: "{{ colors.magenta }}" },
      "@variable.member": { fg: "{{ colors.cyan }}" },

      "@constant": { fg: "{{ colors.orange }}" },
      "@constant.builtin": { fg: "{{ colors.orange }}" },
      "@constant.macro": { fg: "{{ colors.orange }}" },

      "@module": { fg: "{{ colors.blue }}" },
      "@module.builtin": { fg: "{{ colors.blue }}" },
      "@label": { fg: "{{ colors.orange }}" },

      "@string": { fg: "{{ colors.green }}" },
      "@string.documentation": { fg: "{{ colors.green }}" },
      "@string.regexp": { fg: "{{ colors.cyan }}" },
      "@string.escape": { fg: "{{ colors.magenta }}" },
      "@string.special": { fg: "{{ colors.magenta }}" },

      "@character": { fg: "{{ colors.green }}" },
      "@character.special": { fg: "{{ colors.magenta }}" },

      "@boolean": { fg: "{{ colors.orange }}" },
      "@number": { fg: "{{ colors.orange }}" },
      "@number.float": { fg: "{{ colors.orange }}" },

      "@type": { fg: "{{ colors.yellow }}", gui: "bold" },
      "@type.builtin": { fg: "{{ colors.yellow }}", gui: "bold" },
      "@type.definition": { fg: "{{ colors.yellow }}", gui: "bold" },

      "@attribute": { fg: "{{ colors.cyan }}" },
      "@attribute.builtin": { fg: "{{ colors.cyan }}" },
      "@property": { fg: "{{ colors.blue }}" },

      "@function": { fg: "{{ colors.blue }}" },
      "@function.builtin": { fg: "{{ colors.blue }}" },
      "@function.call": { fg: "{{ colors.blue }}" },
      "@function.macro": { fg: "{{ colors.blue }}" },

      "@function.method": { fg: "{{ colors.blue }}" },
      "@function.method.call": { fg: "{{ colors.blue }}" },

      "@constructor": { fg: "{{ colors.cyan }}" },
      "@operator": { fg: "{{ colors.grey8 }}" },

      "@keyword": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.coroutine": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.function": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.operator": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.import": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.type": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.modifier": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.repeat": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.return": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.debug": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.exception": { fg: "{{ colors.red }}", gui: "italic" },

      "@keyword.conditional": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.conditional.ternary": { fg: "{{ colors.red }}", gui: "italic" },

      "@keyword.directive": { fg: "{{ colors.red }}", gui: "italic" },
      "@keyword.directive.define": { fg: "{{ colors.red }}", gui: "italic" },

      "@punctuation.delimiter": { fg: "{{ colors.foreground }}" },
      "@punctuation.bracket": { fg: "{{ colors.foreground }}" },
      "@punctuation.special": { fg: "{{ colors.foreground }}" },

      "@comment": { fg: "{{ colors.grey4 }}" },
      "@comment.documentation": { fg: "{{ colors.grey4 }}" },

      "@tag": { fg: "{{ colors.red }}" },
      "@tag.builtin": { fg: "{{ colors.red }}" },
      "@tag.attribute": { fg: "{{ colors.yellow }}" },
      "@tag.delimiter": { fg: "{{ colors.red }}" },
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
