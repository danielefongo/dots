return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "rust") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.lsps["rust_analyzer"] = {
        filetypes = { "rust" },
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
      local util = require("conform.util")

      opts.options.formatters_by_ft.rust = { "rust" }
      opts.options.formatters.rust = {
        command = "rustfmt",
        options = {
          default_edition = "2024",
        },
        cwd = require("conform.util").root_file({ "rustfmt.toml", ".rustfmt.toml" }),
        args = function(self, ctx)
          local args = { "--emit=stdout" }
          local edition = util.parse_rust_edition(ctx.dirname) or self.options.default_edition
          table.insert(args, "--edition=" .. edition)

          return args
        end,
      }
    end,
  },
}
