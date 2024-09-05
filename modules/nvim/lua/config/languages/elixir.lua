return {
  { "elixir-editors/vim-elixir", event = "BufReadPre" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "elixir")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["elixirls"] = {
        mason_name = "elixir-ls",
        cmd = { fn.glob(fn.stdpath("data") .. "/lsp/bin/" .. "elixir-ls") },
        settings = {
          elixirLS = {
            fetchDeps = false,
            mixEnv = "dev",
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.options.formatters_by_ft.elixir = { "mix" }
    end,
  },
}
