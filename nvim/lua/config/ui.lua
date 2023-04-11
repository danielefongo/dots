local theme = require("theme")
local colors = theme.colors
local syntax = theme.syntax

return {
  {
    "themercorp/themer.lua",
    opts = {
      colorscheme = {
        red = colors.dark_red,
        yellow = colors.yellow,
        orange = colors.dark_yellow,
        magenta = colors.magenta,
        blue = colors.blue,
        green = colors.green,
        cyan = colors.cyan,

        directory = colors.blue,
        fg = colors.white,
        diff = {
          add = colors.dark_green,
          remove = colors.dark_red,
          text = colors.dark_blue,
          change = colors.dark_yellow,
        },
        accent = colors.cyan,
        search_result = { fg = colors.dark_black, bg = colors.blue, telescope = colors.blue },
        match = colors.grey9,
        dimmed = { bg = colors.grey4, fg = colors.grey4 },
        bg = {
          base = colors.black,
          alt = colors.light_black,
          selected = colors.grey2,
        },
        border = colors.white,
        syntax = syntax,
        built_in = syntax,
        diagnostic = {
          error = colors.strong_red,
          warn = colors.strong_yellow,
          info = colors.strong_green,
          hint = colors.magenta,
        },
        inc_search = { fg = colors.dark_black, bg = colors.blue },
        uri = colors.dark_yellow,
        pum = {
          fg = colors.grey9,
          bg = colors.dark_black,
          sbar = colors.light_black,
          thumb = colors.blue,
          sel = { bg = colors.grey2, fg = colors.white },
        },
        heading = {
          h1 = colors.blue,
          h2 = colors.blue,
        },
        remaps = {
          base = {
            WinSeparator = { fg = colors.grey2, bg = colors.black },
            DiffAdd = { fg = colors.dark_green, bg = colors.black },
            DiffChange = { fg = colors.dark_yellow, bg = colors.black },
            DiffDelete = { fg = colors.dark_red, bg = colors.black },
          },
          plugins = {
            nvim_tree = {
              NVimTreeNormal = { fg = colors.white, bg = colors.dark_black },
              NvimTreeGitDeleted = { fg = colors.red },
              NvimTreeGitDirty = { fg = colors.yellow },
              NvimTreeGitStaged = { fg = colors.green },
              NvimTreeGitMerge = { fg = colors.yellow },
              NvimTreeGitNew = { fg = colors.red },
              NvimTreeGitRenamed = { fg = colors.white },
              NvimTreeSpecialFile = { fg = colors.white },
              NvimTreeImageFile = { fg = colors.white },
              NvimTreeOpenedFile = { fg = colors.white },
              NvimTreeModifiedFile = { fg = colors.white },
              NvimTreeIndentMarker = { fg = colors.white },
              NvimTreeSymlink = { fg = colors.white },
              NvimTreeExecFile = { fg = colors.white },
            },
          },
        },
      },
    },
  },
  {
    "b0o/incline.nvim",
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
    opts = {
      options = {
        theme = {
          normal = {
            a = { fg = colors.black, bg = colors.green, gui = "bold" },
            b = { fg = colors.white, bg = colors.grey3 },
            c = { fg = colors.white, bg = colors.light_black },
          },
          command = { a = { fg = colors.black, bg = colors.yellow, gui = "bold" } },
          insert = { a = { fg = colors.black, bg = colors.blue, gui = "bold" } },
          visual = { a = { fg = colors.black, bg = colors.magenta, gui = "bold" } },
          terminal = { a = { fg = colors.black, bg = colors.cyan, gui = "bold" } },
          replace = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },
        },
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
