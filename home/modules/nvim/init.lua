_G.theme = require("theme")

require("utils")

opt.autoindent = true
opt.backup = false
opt.completeopt = "menuone,noinsert,noselect"
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldcolumn = "1"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.hidden = true
opt.ignorecase = true
opt.iskeyword:append("-")
opt.jumpoptions = "stack"
opt.mouse = "a"
opt.number = true
opt.preserveindent = true
opt.pumheight = 12
opt.ruler = false
opt.shiftwidth = 2
opt.showmode = false
opt.smartcase = true
opt.smarttab = true
opt.softtabstop = 4
opt.swapfile = false
opt.syntax = "on"
opt.tabstop = 2
opt.clipboard = "unnamed,unnamedplus"
opt.undofile = true
opt.writebackup = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.tmux_navigator_no_mappings = true

require("reload_theme")
require("autocommands")

if vim.uv.fs_stat(".nvim.lua") then
  -- Example of how to load a local configuration file
  -- require("plugins")({
  --   {
  --     "plugin_name",
  --     opts = { ... },
  --   },
  -- })
  vim.opt.exrc = true
  return
end

require("plugins")()
