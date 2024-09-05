return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "css")
      table.insert(opts.ensure_installed, "scss")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["cssls"] = {
        mason_name = "css-lsp",
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      table.insert(opts.mason_sources, "prettier")
      opts.options.formatters_by_ft.css = { "prettier" }
      opts.options.formatters_by_ft.scss = { "prettier" }
    end,
  },
}
