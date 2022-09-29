require("utils")

opt.autoindent = true
opt.cc = "120"
opt.clipboard = vim.o.clipboard .. "unnamedplus"
opt.completeopt = "menuone,noinsert,noselect"
opt.cursorline = true
opt.expandtab = true
opt.hidden = true
opt.mouse = "a"
opt.number = true
opt.preserveindent = true
opt.shiftwidth = 2
opt.smarttab = true
opt.softtabstop = 2
opt.softtabstop = 4
opt.syntax = "on"
opt.tabstop = 2

vim.g.mapleader = " "

require("bindings")
require("plugins")
require("autocmd")
