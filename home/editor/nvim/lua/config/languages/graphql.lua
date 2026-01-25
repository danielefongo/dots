return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "graphql") end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.options.formatters_by_ft.graphql = { "prettier" }
      opts.options.formatters.prettier = {
        ft_parsers = {
          graphql = "graphql",
        },
      }
    end,
  },
}
