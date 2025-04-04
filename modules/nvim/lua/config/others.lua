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
    dependencies = { { "nvim-lua/plenary.nvim" } },
    opts = true,
  },
  {
    "uga-rosa/ccc.nvim",
    event = "BufReadPost",
    opts = function()
      local ccc = require("ccc")
      return {
        bar_len = 40,
        max_prev_colors = 10,
        alpha_show = "auto",
        inputs = {
          ccc.input.rgb,
          ccc.input.hsl,
          ccc.input.lab,
        },
        highlighter = {
          auto_enable = true,
        },
        mappings = {
          ["<cr>"] = ccc.mapping.complete,
          ["q"] = ccc.mapping.quit,
          ["<esc>"] = ccc.mapping.quit,
          ["i"] = ccc.mapping.increase1,
          ["I"] = ccc.mapping.increase5,
          ["m"] = ccc.mapping.decrease1,
          ["M"] = ccc.mapping.decrease5,
          ["N"] = ccc.mapping.cycle_input_mode,
          ["E"] = ccc.mapping.cycle_output_mode,
        },
        disable_default_mappings = true,
      }
    end,
    keys = {
      { "<leader>ccp", ":CccPick<cr>", desc = "color pick" },
      { "<leader>cct", ":CccHighlighterToggle<cr>", desc = "color highlight toggle" },
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
    init = function() vim.g.tmux_navigator_no_mappings = 1 end,
    keys = {
      { "<M-left>", ":TmuxNavigateLeft<cr>", desc = "left", silent = true },
      { "<M-down>", ":TmuxNavigateDown<cr>", desc = "down", silent = true },
      { "<M-up>", ":TmuxNavigateUp<cr>", desc = "up", silent = true },
      { "<M-right>", ":TmuxNavigateRight<cr>", desc = "right", silent = true },
    },
  },
  {
    "danielefongo/tile.nvim",
    opts = { horizontal = 4, vertical = 2 },
    keys = {
      { "<c-Down>", ":lua require('tile').resize_down()<cr>", desc = "resize down", silent = true },
      { "<c-Left>", ":lua require('tile').resize_left()<cr>", desc = "resize left", silent = true },
      { "<c-Right>", ":lua require('tile').resize_right()<cr>", desc = "resize right", silent = true },
      { "<c-Up>", ":lua require('tile').resize_up()<cr>", desc = "resize up", silent = true },
      { "<s-Down>", ":lua require('tile').shift_down()<cr>", desc = "shift down", silent = true },
      { "<s-Left>", ":lua require('tile').shift_left()<cr>", desc = "shift left", silent = true },
      { "<s-Right>", ":lua require('tile').shift_right()<cr>", desc = "shift right", silent = true },
      { "<s-Up>", ":lua require('tile').shift_up()<cr>", desc = "shift up", silent = true },
    },
  },
}
