return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        enabled = true,
        matcher = {
          frecency = true,
        },
        show_empty = true,
        win = {
          input = {
            keys = {
              ["<esc>"] = "cancel",
              ["<cr>"] = { "confirm", mode = { "n", "i" } },
              ["<c-q>"] = { "qflist", mode = { "i", "n" } },
              ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
              ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["q"] = "close",
              ["?"] = "toggle_help_input",
              ["<c-n>"] = { "cycle_win", mode = { "n", "i" } },
              ["<c-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete_word" },

              ["<s-down>"] = { "history_forward", mode = { "i", "n" } },
              ["<s-up>"] = { "history_back", mode = { "i", "n" } },

              ["<down>"] = { "list_down", mode = { "i", "n" } },
              ["<up>"] = { "list_up", mode = { "i", "n" } },
              ["<tab>"] = { "select_and_next", mode = { "i", "n" } },
              ["<s-tab>"] = { "select_and_prev", mode = { "i", "n" } },
              ["G"] = "list_bottom",
              ["gg"] = "list_top",
              ["<c-a>"] = { "select_all", mode = { "n", "i" } },

              ["<c-down>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-up>"] = { "preview_scroll_up", mode = { "i", "n" } },

              ["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<c-i>"] = { "toggle_ignored", mode = { "i", "n" } },
              ["<c-f>"] = { "toggle_maximize", mode = { "i", "n" } },
              ["<c-p>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<esc>"] = "cancel",
              ["<cr>"] = "confirm",
              ["<c-q>"] = "qflist",
              ["<c-s>"] = "edit_split",
              ["<c-v>"] = "edit_vsplit",
              ["i"] = "focus_input",
              ["q"] = "close",
              ["?"] = "toggle_help_list",
              ["<c-n>"] = "cycle_win",

              ["<down>"] = "list_down",
              ["<up>"] = "list_up",

              ["<down>"] = { "list_down", mode = { "n", "x" } },
              ["<up>"] = { "list_up", mode = { "n", "x" } },
              ["<tab>"] = { "select_and_next", mode = { "n", "x" } },
              ["<s-tab>"] = { "select_and_prev", mode = { "n", "x" } },
              ["<c-a>"] = "select_all",
              ["G"] = "list_bottom",
              ["gg"] = "list_top",

              ["<c-down>"] = "preview_scroll_down",
              ["<c-up>"] = "preview_scroll_up",

              ["<c-h>"] = "toggle_hidden",
              ["<c-i>"] = "toggle_ignored",
              ["<c-f>"] = "toggle_maximize",
              ["<c-p>"] = "toggle_preview",
            },
          },
          preview = {
            keys = {
              ["<esc>"] = "cancel",
              ["i"] = "focus_input",
              ["q"] = "close",
              ["<c-n>"] = "cycle_win",
            },
          },
        },
      },
    },
    keys = {
      lkey("cd", function() Snacks.picker.lsp_definitions() end, "definitions"),
      lkey("ci", function() Snacks.picker.lsp_implementations() end, "implementations"),
      lkey("cr", function() Snacks.picker.lsp_references() end, "references"),
      lkey("ct", function() Snacks.picker.lsp_type_definitions() end, "type definitions"),

      lkey("gb", function() Snacks.git.blame_line() end, "blame line"),

      lkey("fb", function() Snacks.picker.lines() end, "buffer text"),
      lkey("fsb", function() Snacks.picker.lsp_symbols() end, "buffer"),
      lkey("fsw", function() Snacks.picker.lsp_workspace_symbols() end, "workspace"),
      lkey("fw", function() Snacks.picker.grep() end, "workspace text"),

      lkey("ob", function() Snacks.picker.buffers() end, "buffer"),
      lkey("of", function() Snacks.picker.files() end, "file"),
      lkey("op", function() Snacks.picker.pickers() end, "pickers"),
      lkey("or", function() Snacks.picker.resume() end, "resume"),
    },
  },
  {
    "folke/flash.nvim",
    config = true,
    opts = {
      labels = "arstgmneioqwfpbjluyzxcdvkh",
      highlight = {
        matches = false,
      },
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      key("s", function() require("flash").jump() end, "seek", { "n", "x" }),
      key("S", function()
        require("flash").jump({ search = { mode = function(str) return "\\<" .. str end } })
      end, "seek", { "n", "x" }),
    },
  },
}
