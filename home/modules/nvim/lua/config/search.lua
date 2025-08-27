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
      { "<leader>cd", function() Snacks.picker.lsp_definitions() end, desc = "definitions", silent = true },
      { "<leader>ci", function() Snacks.picker.lsp_implementations() end, desc = "implementations", silent = true },
      { "<leader>cr", function() Snacks.picker.lsp_references() end, desc = "references", silent = true },
      { "<leader>ct", function() Snacks.picker.lsp_type_definitions() end, desc = "type definitions", silent = true },

      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "blame line", silent = true },

      { "<leader>fb", function() Snacks.picker.lines() end, desc = "buffer text", silent = true },
      { "<leader>fsb", function() Snacks.picker.lsp_symbols() end, desc = "buffer", silent = true },
      { "<leader>fsw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "workspace", silent = true },
      { "<leader>fw", function() Snacks.picker.grep() end, desc = "workspace text", silent = true },

      { "<leader>ob", function() Snacks.picker.buffers() end, desc = "buffer", silent = true },
      { "<leader>of", function() Snacks.picker.files() end, desc = "file", silent = true },
      { "<leader>op", function() Snacks.picker.pickers() end, desc = "pickers", silent = true },
      { "<leader>or", function() Snacks.picker.resume() end, desc = "resume", silent = true },
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
      { "s", function() require("flash").jump() end, desc = "seek", mode = { "n", "x" } },
      {
        "S",
        function()
          require("flash").jump({ search = { mode = function(str) return "\\<" .. str end } })
        end,
        desc = "seek",
        mode = { "n", "x" },
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      history = {
        autoSave = { enabled = false },
      },
    },
    keys = {
      {
        "<leader>fr",
        function() require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } }) end,
        desc = "find and replace",
        mode = { "n", "v" },
      },
      {
        "<leader>fR",
        function() require("grug-far").open({ transient = true }) end,
        desc = "find and replace (workspace)",
        mode = { "n", "v" },
      },
    },
  },
}
