return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      panel = { enabled = true },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<c-j>",
          next = "<c-l>",
          prev = "<c-u>",
          dismiss = "<c-y>",
        },
      },
      server_opts_overrides = {},
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      "folke/snacks.nvim",
    },
    opts = {
      interactions = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
        inline = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
      },
      display = {
        action_palette = {
          provider = "snacks",
          opts = {
            show_default_actions = true,
          },
        },
      },
    },
    keys = {
      lkey("ac", function() require("codecompanion").chat({}) end, "chat"),
      lkey("aa", function() require("codecompanion").chat({ params = { adapter = "opencode" } }) end, "agentic"),
      lkey("aA", function() require("codecompanion").actions({}) end, "actions"),
      lkey("ai", function()
        local companion = require("codecompanion")
        local input = vim.fn.input("Enter your message: ")
        companion.inline({ message = input })
      end, "inline", { "n", "v" }),
    },
  },
}
