local theme = require("config.theme")
local colors = theme.colors
local syntax = theme.syntax

local cp = {
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
    alt = colors.grey1,
    selected = colors.grey2,
  },
  border = colors.blue,
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
    bg = colors.grey1,
    sbar = colors.grey2,
    thumb = colors.blue,
    sel = { bg = colors.blue, fg = colors.dark_black },
  },
  heading = {
    h1 = colors.blue,
    h2 = colors.blue,
  },
}

require("themer").setup({ colorscheme = cp })

function _G.last_theme_update()
  local f = io.popen("stat -c %Y ~/dotfiles/dots/nvim/lua/config/theme.lua")
  if f then
    local last_modified = f:read()
    f:close()
    return last_modified
  else
    return 0
  end
end

LAST_THEME_UPDATE = last_theme_update()
function _G.update_theme()
  local timer = vim.loop.new_timer()
  timer:start(
    1000,
    500,
    vim.schedule_wrap(function()
      if LAST_THEME_UPDATE < last_theme_update() then
        LAST_THEME_UPDATE = last_theme_update()
        reload_config()
      end
    end)
  )
end

vim.cmd([[ au VimEnter * nested lua update_theme() ]])
