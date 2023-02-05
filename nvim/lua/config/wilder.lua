local wilder = require("wilder")

wilder.set_option(
  "renderer",
  wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
    highlights = { border = "Normal" },
    border = "rounded",
  }))
)

wilder.setup({
  modes = { ":", "/" },
  previous_key = "<C-k>",
  next_key = "<C-j>",
  accept_key = "<Tab>",
})
