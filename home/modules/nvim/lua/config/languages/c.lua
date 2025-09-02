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
    opts = function(_, opts)
      opts.lsps["clangd"] = {
        filetypes = { "c", "cpp" },
        settings = {},
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts) opts.options.formatters_by_ft.c = { "clang-format" } end,
  },
}
