local theme = require("theme")

return {
  {
    "themercorp/themer.lua",
    event = "VeryLazy",
    opts = { colorscheme = theme.themer },
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      highlight = {
        groups = {
          InclineNormal = {
            default = true,
            group = "ThemerSearchResult",
          },
          InclineNormalNC = {
            default = true,
            group = "ThemerSelected",
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = theme.lualine,
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "filename", path = 1 } },
        lualine_c = { "branch" },
        lualine_x = { "diagnostics" },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
  {
    "gelguy/wilder.nvim",
    event = "VeryLazy",
    config = function()
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
    end,
  },
}
