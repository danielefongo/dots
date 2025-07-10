return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "gdscript") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, lsps) lsps["gdscript"] = {} end,
  },
  {
    "stevearc/conform.nvim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "gdscript",
        callback = function()
          vim.bo.expandtab = false
          vim.bo.shiftwidth = 4
          vim.bo.tabstop = 4
        end,
      })
    end,
    opts = function(_, opts) opts.options.formatters_by_ft.gdscript = { "gdformat" } end,
  },
}
