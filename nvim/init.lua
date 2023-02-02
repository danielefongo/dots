require("utils")

opt.autoindent = true
opt.cc = "120"
opt.completeopt = "menuone,noinsert,noselect"
opt.cursorline = true
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

vim.g.mapleader = " "

require("plugins")
require("autocmd")
