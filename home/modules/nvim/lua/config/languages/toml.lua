return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "toml") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps) lsps["taplo"] = {} end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts) opts.options.formatters_by_ft.toml = { "taplo" } end,
  },
}
