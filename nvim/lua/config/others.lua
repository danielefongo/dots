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
}
