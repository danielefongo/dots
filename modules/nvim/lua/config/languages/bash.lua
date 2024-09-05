return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "bash")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["bashls"] = {
        mason_name = "bash-language-server",
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      table.insert(opts.mason_sources, "shfmt")
      opts.options.formatters_by_ft.sh = { "shfmt" }
      opts.options.formatters_by_ft.bash = { "shfmt" }
    end,
  },
}
