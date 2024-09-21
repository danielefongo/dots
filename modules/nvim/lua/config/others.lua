return {
  {
    "gregorias/coerce.nvim",
    tag = "v3.0.0",
    config = true,
    event = "BufReadPost",
  },
  {
    "tpope/vim-commentary",
    cmd = "Commentary",
    keys = {
      { "<leader>;", ":Commentary<cr>", desc = "comment", mode = { "n", "v" }, silent = true },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { { "nvim-lua/plenary.nvim", version = "~0.1.3" } },
    opts = true,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    keys = {
      { "<leader>cc", ":lua require('nvim-highlight-colors').toggle()<cr>", desc = "colors", silent = true },
    },
  },
  { "windwp/nvim-autopairs", opts = {}, event = "InsertEnter" },
  {
    "kazhala/close-buffers.nvim",
    keys = {
      {
        "<leader>bH",
        ":lua require('close_buffers').delete({ type = 'other' })<cr>",
        desc = "close all",
        silent = true,
      },
      { "<leader>bk", ":lua require('close_buffers').delete({ type = 'this' })<cr>", desc = "close", silent = true },
      { "<leader>bK", ":lua require('close_buffers').delete({ type = 'all' })<cr>", desc = "close all", silent = true },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<M-m>", ":TmuxNavigateLeft<cr>", desc = "left", silent = true },
      { "<M-n>", ":TmuxNavigateDown<cr>", desc = "down", silent = true },
      { "<M-e>", ":TmuxNavigateUp<cr>", desc = "up", silent = true },
      { "<M-i>", ":TmuxNavigateRight<cr>", desc = "right", silent = true },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = { "imports", "comment" },
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    keys = {
      { "<c-f>", "za", desc = "toggle fold", silent = true },
    },
  },
}
