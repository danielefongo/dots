return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "html") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps) lsps["html"] = {} end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts) opts.options.formatters_by_ft.html = { "prettier" } end,
  },
}
