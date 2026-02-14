vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.h",
  callback = function() vim.bo.filetype = "c" end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "c")
      table.insert(opts.ensure_installed, "cpp")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.lsps["clangd"] = {
        filetypes = { "c", "cpp" },
        settings = {},
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.options.formatters_by_ft.c = { "clang_format" }
      opts.options.formatters_by_ft.cpp = { "clang_format" }
      opts.options.formatters.clang_format = {
        command = "clang-format",
        args = { "-assume-filename", "$FILENAME" },
        stdin = true,
      }
    end,
  },
}
