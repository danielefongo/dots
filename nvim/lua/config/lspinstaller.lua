require("nvim-lsp-installer").setup({
  automatic_installation = true,
  install_root_dir = fn.stdpath("data") .. "/lsp/"
})
