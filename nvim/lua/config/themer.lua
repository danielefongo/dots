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
    alt = colors.light_black,
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
    bg = colors.dark_black,
    sbar = colors.light_black,
    thumb = colors.blue,
    sel = { bg = colors.grey2, fg = colors.white },
  },
  heading = {
    h1 = colors.blue,
    h2 = colors.blue,
  },
}
cp.remaps = {
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
