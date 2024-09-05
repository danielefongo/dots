return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "javascript")
      table.insert(opts.ensure_installed, "typescript")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["tsserver"] = {
        mason_name = "typescript-language-server",
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      table.insert(opts.mason_sources, "eslint_d")
      table.insert(opts.mason_sources, "prettier")

      opts.options.formatters_by_ft.javascript = { { "prettier", "eslint_d" } }
      opts.options.formatters_by_ft.typescript = { { "prettier", "eslint_d" } }

      opts.options.formatters.eslint_d = {
        require_cwd = true,
        cwd = require("conform.util").root_file({
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
        }),
      }
    end,
  },
}
