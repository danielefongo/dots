return {
  { "uga-rosa/ccc.nvim", event = "VeryLazy" },
  { "tpope/vim-commentary", cmd = "Commentary" },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { { "nvim-lua/plenary.nvim", version = "~0.1.3" } },
    opts = true,
  },
  { "gabrielpoca/replacer.nvim" },
  { "brenoprata10/nvim-highlight-colors", event = "VeryLazy" },
  { "windwp/nvim-autopairs", opts = {}, event = "BufReadPre" },
  { "kazhala/close-buffers.nvim", event = "VeryLazy" },
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1

      vim.keymap.set("n", "<M-m>", ":TmuxNavigateLeft<cr>", { silent = true })
      vim.keymap.set("n", "<M-n>", ":TmuxNavigateDown<cr>", { silent = true })
      vim.keymap.set("n", "<M-e>", ":TmuxNavigateUp<cr>", { silent = true })
      vim.keymap.set("n", "<M-i>", ":TmuxNavigateRight<cr>", { silent = true })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    config = function()
      local ufo = require("ufo")

      ufo.setup({
        open_fold_hl_timeout = 150,
        close_fold_kinds = { "imports", "comment" },
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
}
