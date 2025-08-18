return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "rust") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["rust_analyzer"] = {
        settings = {
          ["rust-analyzer"] = {
            assist = {
              importEnforceGranularity = true,
              importPrefix = "crate",
            },
            cargo = {
              features = "all",
              targetDir = "target/rust-analyzer",
            },
            check = {
              features = "all",
              command = "check",
            },
            diagnostics = {
              disabled = { "inactive-code" },
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.options.formatters_by_ft.rust = { "rust" }
      opts.options.formatters.rust = {
        command = "rustfmt",
        options = {
          default_edition = "2024",
        },
        cwd = require("conform.util").root_file({ "rustfmt.toml", ".rustfmt.toml" }),
      }
    end,
  },
}
