return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "json")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      table.insert(opts.mason_sources, "jq")
      opts.options.formatters_by_ft.json = { "jq" }
    end,
  },
}
