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
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      open_fold_hl_timeout = 150,
    },
    keys = {
      { "<c-f>", "za", desc = "toggle fold", silent = true },
    },
  },
  {
    "danielefongo/tile.nvim",
    opts = { horizontal = 4, vertical = 2 },
    keys = {
      { "<a-c-Down>", ":lua require('tile').resize_down()<cr>", desc = "resize down", silent = true },
      { "<a-c-Left>", ":lua require('tile').resize_left()<cr>", desc = "resize left", silent = true },
      { "<a-c-Right>", ":lua require('tile').resize_right()<cr>", desc = "resize right", silent = true },
      { "<a-c-Up>", ":lua require('tile').resize_up()<cr>", desc = "resize up", silent = true },
      { "<a-s-Down>", ":lua require('tile').shift_down()<cr>", desc = "shift down", silent = true },
      { "<a-s-Left>", ":lua require('tile').shift_left()<cr>", desc = "shift left", silent = true },
      { "<a-s-Right>", ":lua require('tile').shift_right()<cr>", desc = "shift right", silent = true },
      { "<a-s-Up>", ":lua require('tile').shift_up()<cr>", desc = "shift up", silent = true },
    },
  },
}
