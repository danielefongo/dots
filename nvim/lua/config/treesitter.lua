require('nvim-treesitter.configs').setup({
  ensure_installed = { "elixir", "elm", "javascript", "json", "python", "rust", "lua", "typescript" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  }
})
