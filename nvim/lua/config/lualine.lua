local theme = require("config.theme")
local colors = theme.colors

local scheme = {
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
}
require("lualine").setup({
  options = {
    theme = scheme,
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
})
