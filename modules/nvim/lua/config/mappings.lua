return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 100
  end,
  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>b", group = "buffer" },
      { "<leader>bs", ":lua scratch()<cr>", desc = "scratch", silent = true },

      { "<leader>c", group = "code" },

      { "<leader>d", group = "diagnostic" },

      { "<leader>f", group = "find" },
      { "<leader>fs", group = "symbol" },

      { "<leader>g", group = "git" },

      { "<leader>o", group = "open" },

      { "<leader>s", group = "session" },

      { "<leader>t", group = "tab" },

      { "<leader>v", group = "vim" },
      { "<leader>vq", ":qa<cr>", desc = "quit", silent = true },

      { "<leader>w", "<C-w>", desc = "windows" },
    })

    wk.add({
      mode = { "n", "v" },
      { "<a-q>", ":lua close_win()<cr>", desc = "close buffer", silent = true },
      { "<c-e>", "<c-y>", desc = "scroll up", silent = true },
      { "<c-n>", "<c-e>", desc = "scroll down", silent = true },
    })

    -- colemak remap
    wk.add({
      mode = { "n", "v", "o" },
      { "E", "K", desc = "-" },
      { "H", "I", desc = "insert beginning" },
      { "I", "L", desc = "-" },
      { "J", "E", desc = "end WORD" },
      { "K", "N", desc = "find previous" },
      { "N", "J", desc = "join lines" },
      { "e", "k", desc = "up" },
      { "h", "i", desc = "insert" },
      { "i", "l", desc = "right" },
      { "j", "e", desc = "end word" },
      { "k", "n", desc = "find next" },
      { "m", "h", desc = "left" },
      { "n", "j", desc = "down" },
    })
  end,
}
