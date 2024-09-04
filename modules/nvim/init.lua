theme = require("theme")

require("utils")

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.ruler = false
opt.autoindent = true
opt.completeopt = "menuone,noinsert,noselect"
opt.expandtab = true
opt.hidden = true
opt.mouse = "a"
opt.number = true
opt.preserveindent = true
opt.shiftwidth = 2
opt.smarttab = true
opt.softtabstop = 4
opt.syntax = "on"
opt.tabstop = 2
opt.clipboard = "unnamed,unnamedplus"
opt.undofile = true
opt.pumheight = 12
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.ignorecase = true
opt.smartcase = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.tmux_navigator_no_mappings = true

require("plugins")
require("reload_theme")
