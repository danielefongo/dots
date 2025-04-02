return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "lua") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["lua_ls"] = {
        settings = {
          Lua = {
            callSnippet = "Replace",
            diagnostics = { globals = { "vim" } },
            format = { enable = false },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.options.formatters_by_ft.lua = { "stylua" }
      opts.options.formatters.stylua = {
        prepend_args = function(_, _)
          return {
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
          }
        end,
      }
    end,
  },
}
