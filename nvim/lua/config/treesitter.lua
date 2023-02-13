require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "elixir",
    "elm",
    "html",
    "javascript",
    "json",
    "markdown",
    "python",
    "rust",
    "lua",
    "toml",
    "typescript",
    "vim",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})
