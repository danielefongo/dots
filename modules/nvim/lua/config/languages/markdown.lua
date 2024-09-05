return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "markdown")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      table.insert(opts.mason_sources, "markdownlint")
      opts.options.formatters_by_ft.markdown = { "markdownlint" }
    end,
  },
}
