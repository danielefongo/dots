return {
  {
    "2kabhishek/nerdy.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = "Nerdy",
    opts = {
      max_recents = 30,
      copy_to_clipboard = false,
    },
    keys = {
      lkey("on", function() vim.cmd("Nerdy") end, "nerd fonts"),
    },
  },
  {
    "gregorias/coerce.nvim",
    tag = "v3.0.0",
    config = true,
    event = "BufReadPost",
  },
  {
    "uga-rosa/ccc.nvim",
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
    "folke/snacks.nvim",
    keys = {
      lkey("bH", function()
        local current = vim.api.nvim_get_current_buf()
        Snacks.bufdelete.other()
      end, "close others"),
      lkey("bk", function() Snacks.bufdelete.delete(0) end, "close"),
      lkey("bK", function() Snacks.bufdelete.all() end, "close all"),
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
    ft = { "c" },
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
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "BufReadPost",
    keys = {
      lkey("mm", function() require("multicursor-nvim").matchCursors() end, "match", { "v" }),
      lkey("mr", function() require("multicursor-nvim").restoreCursors() end, "restore", { "n" }),

      key("I", function() require("multicursor-nvim").insertVisual() end, "insert", { "x" }),
      key("A", function() require("multicursor-nvim").appendVisual() end, "append", { "x" }),

      lkey("ma", function() require("multicursor-nvim").matchAllAddCursors() end, "add all cursors", { "n", "v" }),
      key("<c-n>", function() require("multicursor-nvim").matchAddCursor(1) end, "add cursor", { "n", "v" }),
      key("<c-p>", function() require("multicursor-nvim").matchAddCursor(-1) end, "add cursor prev", { "n", "v" }),
      key("<c-s-n>", function() require("multicursor-nvim").matchSkipCursor(1) end, "skip cursor", { "n", "v" }),
      key("<c-s-p>", function() require("multicursor-nvim").matchSkipCursor(-1) end, "skip cursor prev", { "n", "v" }),

      lkey("mc", function() require("multicursor-nvim").addCursorOperator() end, "cursor", { "n", "v" }),
      key("<c-pageup>", function() require("multicursor-nvim").lineAddCursor(-1) end, "up", { "n", "v" }),
      key("<c-pagedown>", function() require("multicursor-nvim").lineAddCursor(1) end, "down", { "n", "v" }),
      key("<c-s-pageup>", function() require("multicursor-nvim").lineSkipCursor(-1) end, "skip up", { "n", "v" }),
      key("<c-s-pagedown>", function() require("multicursor-nvim").lineSkipCursor(1) end, "skip down", { "n", "v" }),
    },
    config = function()
      mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set
      vim.g.visual_cursors_toggle = false

      mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<c-q>", function()
          mc.disableCursors()
          if vim.g.visual_cursors_toggle then mc.enableCursors() end
          vim.g.visual_cursors_toggle = not vim.g.visual_cursors_toggle
        end)

        layerSet({ "n", "x" }, "<c-x>", mc.deleteCursor)
        layerSet({ "n", "x" }, "<c-a>", mc.addCursorOperator)

        layerSet({ "n", "x" }, "<c-left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<c-right>", mc.nextCursor)
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.disableCursors()
            mc.enableCursors()
          else
            mc.clearCursors()
          end
          vim.g.visual_cursors_toggle = false
        end)
      end)
    end,
  },
}
