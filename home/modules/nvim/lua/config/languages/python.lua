return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "python") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps) lsps["pylsp"] = {} end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts) opts.options.formatters_by_ft.python = { "black" } end,
  },
}
