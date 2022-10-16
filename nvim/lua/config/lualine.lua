local theme = require("config.theme")
local colors = theme.colors

local scheme = {
  normal = {
    a = { fg = colors.black, bg = colors.green, gui = 'bold' },
    b = { fg = colors.white, bg = colors.grey3 },
    c = { fg = colors.white, bg = colors.grey1 }
  },
  command = { a = { fg = colors.black, bg = colors.yellow, gui = 'bold' } },
  insert = { a = { fg = colors.black, bg = colors.blue, gui = 'bold' } },
  visual = { a = { fg = colors.black, bg = colors.magenta, gui = 'bold' } },
  terminal = { a = { fg = colors.black, bg = colors.cyan, gui = 'bold' } },
  replace = { a = { fg = colors.black, bg = colors.red, gui = 'bold' } },
  inactive = {
    a = { fg = colors.grey5, bg = colors.black, gui = 'bold' },
    b = { fg = colors.grey5, bg = colors.black },
    c = { fg = colors.grey5, bg = colors.black }
  }
}

require('lualine').setup({
  options = {
    theme = scheme,
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { { 'filename', path = 1 } },
    lualine_c = { 'branch' },
    lualine_x = { 'filetype' },
    lualine_y = { 'diagnostics' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})
