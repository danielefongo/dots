return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 100
  end,
  opts_extends = { "spec" },
  opts = {
    preset = "helix",
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>bs", ":lua scratch()<cr>", desc = "scratch", silent = true },

      { "<leader>c", group = "code" },
      { "<leader>cc", group = "colors" },
      { "<leader>cp", group = "package" },

      { "<leader>d", group = "diagnostic" },

      { "<leader>f", group = "find" },
      { "<leader>fs", group = "symbol" },

      { "<leader>g", group = "git" },

      { "<leader>l", group = "lazy" },
      { "<leader>lp", ":Lazy profile<cr>", desc = "profile" },

      { "<leader>o", group = "open" },

      { "<leader>s", group = "session" },

      { "<leader>t", group = "tab" },

      { "<leader>v", group = "vim" },
      { "<leader>vq", ":qa<cr>", desc = "quit", silent = true },

      { "<leader>w", "<C-w>", desc = "windows" },

      -- others
      {
        mode = { "n", "v" },
        { "<a-q>", ":lua close_win()<cr>", desc = "close buffer", silent = true },
        { "<c-up>", "<c-y>", desc = "scroll up", silent = true },
        { "<c-down>", "<c-e>", desc = "scroll down", silent = true },
        { "<c-g>", "gg0vG$", desc = "select all", noremap = true, silent = true },
        { ">", ">gv", desc = "indent right", noremap = true, silent = true },
        { "<", "<gv", desc = "indent left", noremap = true, silent = true },
      },
    },
  },
}
