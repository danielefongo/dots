return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "elm")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["elmls"] = {}
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.options.formatters_by_ft.elm = { "elm_format" }
    end,
  },
}
