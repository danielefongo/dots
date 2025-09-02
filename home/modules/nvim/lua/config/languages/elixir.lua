return {
  { "elixir-editors/vim-elixir", event = "LspAttach" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "elixir") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.lsps["elixirls"] = {
        cmd = { fn.stdpath("data") .. "/lsp/bin/" .. "elixir-ls" },
        filetypes = { "elixir", "eelixir", "heex" },
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
    opts = function(_, opts) opts.options.formatters_by_ft.elixir = { "mix" } end,
  },
}
