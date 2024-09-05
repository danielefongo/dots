return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "rust")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["rust_analyzer"] = {
        mason_name = "rust-analyzer",
        settings = {
          ["rust-analyzer"] = {
            assist = {
              importEnforceGranularity = true,
              importPrefix = "crate",
            },
            cargo = {
              features = "all",
            },
            check = {
              features = "all",
              command = "clippy",
            },
            completion = {
              limit = 100,
            },
            rust = {
              analyzerTargetDir = true,
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      table.insert(opts.mason_sources, "rustfmt")
      opts.options.formatters_by_ft.rust = { "rustfmt" }
    end,
  },
}
