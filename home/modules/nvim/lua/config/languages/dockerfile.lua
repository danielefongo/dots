return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "dockerfile") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.lsps["dockerls"] = {
        filetypes = { "dockerfile" },
        settings = {},
      }
    end,
  },
}
