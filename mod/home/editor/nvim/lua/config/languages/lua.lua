return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "lua") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.lsps["lua_ls"] = {
        filetypes = { "lua" },
        settings = {
          Lua = {
            callSnippet = "Replace",
            diagnostics = { globals = { "vim" } },
            format = { enable = false },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
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
