return {
  { "norcalli/nvim-colorizer.lua" },
  { "tpope/vim-commentary", cmd = "Commentary" },
  { "gabrielpoca/replacer.nvim", cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" } },
  { "windwp/nvim-autopairs", opts = {}, event = "BufReadPre" },
  { "kazhala/close-buffers.nvim", event = "VeryLazy" },
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1

      vim.keymap.set("n", "<M-h>", ":TmuxNavigateLeft<cr>")
      vim.keymap.set("n", "<M-j>", ":TmuxNavigateDown<cr>")
      vim.keymap.set("n", "<M-k>", ":TmuxNavigateUp<cr>")
      vim.keymap.set("n", "<M-l>", ":TmuxNavigateRight<cr>")
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
