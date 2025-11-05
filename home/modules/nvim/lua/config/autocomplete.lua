return {
  {
    "zbirenbaum/copilot.lua",
    event = { "BufReadPre", "BufNewFile" },
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
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then return end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
          },
        },
      },
    },
    version = "1.*",
    opts = function()
      return {
        keymap = {
          ["<up>"] = { "select_prev", "fallback" },
          ["<down>"] = { "select_next", "fallback" },
          ["<c-up>"] = { function(cmp) cmp.scroll_documentation_up(4) end },
          ["<c-down>"] = { function(cmp) cmp.scroll_documentation_down(4) end },
          ["<cr>"] = { "accept", "fallback" },
          ["<c-x>"] = { "cancel", "fallback" },
        },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = { border = "rounded" },
          },
          list = {
            selection = { preselect = false, auto_insert = true },
          },
          menu = {
            border = "rounded",
            draw = {
              treesitter = { "lsp" },
              columns = { { "kind_icon", "label", gap = 1 } },
            },
          },
          ghost_text = { enabled = false },
        },
        cmdline = {
          keymap = {
            preset = "inherit",
            ["<cr>"] = {},
            ["<esc>"] = {},
          },
          completion = { menu = { auto_show = true } },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = {
          enabled = true,
          window = { border = "rounded" },
        },
        snippets = { preset = "luasnip" },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          providers = {
            lsp = {
              score_offset = 4,
              min_keyword_length = 0,
              fallbacks = {},
            },
            path = {
              score_offset = 3,
              min_keyword_length = 0,
            },
            snippets = {
              score_offset = 2,
              min_keyword_length = 2,
              max_items = 5,
            },
            buffer = {
              module = "blink.cmp.sources.buffer",
              min_keyword_length = 3,
              score_offset = 1,
            },
          },
        },
      }
    end,
  },
}
