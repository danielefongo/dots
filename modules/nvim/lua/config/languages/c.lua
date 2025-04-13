return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "c")
      table.insert(opts.ensure_installed, "cpp")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps) lsps["clangd"] = { settings = {} } end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts) opts.options.formatters_by_ft.c = { "clang-format" } end,
  },
}
