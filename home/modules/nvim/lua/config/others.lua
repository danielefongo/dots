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
      lkey(";", ":Commentary<cr>", "comment", { "n", "v" }),
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
      lkey("ccp", function() vim.cmd("CccPick") end, "color pick"),
      lkey("cct", function() vim.cmd("CccHighlighterToggle") end, "color highlight toggle"),
    },
  },
  { "windwp/nvim-autopairs", opts = {}, event = "InsertEnter" },
  {
    "kazhala/close-buffers.nvim",
    keys = {
      lkey("bH", function() require("close_buffers").delete({ type = "other" }) end, "close other"),
      lkey("bk", function() require("close_buffers").delete({ type = "this" }) end, "close"),
      lkey("bK", function() require("close_buffers").delete({ type = "all" }) end, "close all"),
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    init = function() vim.g.tmux_navigator_no_mappings = 1 end,
    keys = {
      key("<M-left>", function() vim.cmd("TmuxNavigateLeft") end, "left"),
      key("<M-down>", function() vim.cmd("TmuxNavigateDown") end, "down"),
      key("<M-up>", function() vim.cmd("TmuxNavigateUp") end, "up"),
      key("<M-right>", function() vim.cmd("TmuxNavigateRight") end, "right"),
    },
  },
  {
    "danielefongo/tile.nvim",
    opts = { horizontal = 4, vertical = 2 },
    keys = {
      key("<c-Down>", function() require("tile").resize_down() end, "resize down"),
      key("<c-Left>", function() require("tile").resize_left() end, "resize left"),
      key("<c-Right>", function() require("tile").resize_right() end, "resize right"),
      key("<c-Up>", function() require("tile").resize_up() end, "resize up"),
      key("<s-Down>", function() require("tile").shift_down() end, "shift down"),
      key("<s-Left>", function() require("tile").shift_left() end, "shift left"),
      key("<s-Right>", function() require("tile").shift_right() end, "shift right"),
      key("<s-Up>", function() require("tile").shift_up() end, "shift up"),
    },
  },
  {
    "codethread/qmk.nvim",
    event = "BufReadPost",
    opts = {
      name = "LAYOUT",
      layout = {
        "_ x x x x x x _ x x x x x x",
        "_ x x x x x x _ x x x x x x",
        "_ x x x x x x _ x x x x x x",
        "_ x x x x x x _ x x x x x x",
        "_ _ _ _ _ x x _ x x _ _ _ _",
      },
      comment_preview = { position = "none" },
    },
  },
}
