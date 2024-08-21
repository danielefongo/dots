return {
  {
    "themercorp/themer.lua",
    event = "VeryLazy",
    opts = { colorscheme = theme.themer },
  },
  {
    "utilyre/barbecue.nvim",
    lazy = false,
    name = "barbecue",
    dependencies = { "SmiteshP/nvim-navic" },
    opts = { theme = theme.barbecue },
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
      extensions = { "oil" },
    },
  },
  {
    "gelguy/wilder.nvim",
    event = "VeryLazy",
    config = function()
      local wilder = require("wilder")
      vim.opt.showcmd = false

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
          highlights = { border = "Normal" },
          border = "rounded",
        }))
      )

      wilder.setup({
        modes = { ":", "/" },
        previous_key = "<C-e>",
        next_key = "<C-n>",
        accept_key = "<Tab>",
      })
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { " %s" }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
        },
      })
    end,
  },
  {
    "danielefongo/tile.nvim",
    event = "BufReadPre",
    opts = { horizontal = 4, vertical = 2 },
  },
}
