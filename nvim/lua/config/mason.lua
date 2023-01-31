local mason = require("mason")
local mason_null_ls = require("mason-null-ls")
local mason_lsp_config = require("mason-lspconfig")

mason.setup({
  install_root_dir = fn.stdpath("data") .. "/lsp/",
})

mason_lsp_config.setup({
  automatic_installation = true
})

mason_null_ls.setup({
  automatic_installation = true,
  automatic_setup = true
})
mason_null_ls.setup_handlers()
