return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "nix") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps)
      lsps["nixd"] = {
        cmd = { "nixd" },
        settings = {
          nixd = {
            nixpkgs = {
              expr = 'import (builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs { }',
            },
            options = {
              home_manager = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."danielefongo".options',
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
      opts.options.formatters_by_ft.nix = { "nixpkgs_fmt" }
      opts.options.formatters.nixpkgs_fmt = { command = "nixfmt" }
    end,
  },
}
