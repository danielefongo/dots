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
    opts = function(_, opts)
      opts.lsps["cssls"] = {
        filetypes = { "css", "scss" },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.options.formatters_by_ft.css = { "prettier" }
      opts.options.formatters_by_ft.scss = { "prettier" }
    end,
  },
}
