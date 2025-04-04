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
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<up>"] = cmp.mapping.select_prev_item(),
          ["<down>"] = cmp.mapping.select_next_item(),
          ["<c-down>"] = cmp.mapping.scroll_docs(4),
          ["<c-up>"] = cmp.mapping.scroll_docs(-4),
          ["<cr>"] = cmp.mapping.confirm({ select = false }),
          ["<c-x>"] = cmp.mapping.abort(),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer", keyword_length = 2, max_item_count = 8 },
        },
        completion = {
          autocomplete = {
            cmp.TriggerEvent.TextChanged,
            cmp.TriggerEvent.InsertEnter,
          },
        },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "garymjr/nvim-snippets",
        opts = { friendly_snippets = true },
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item) return vim.snippet.expand(item.body) end,
      }
      table.insert(opts.sources, { name = "snippets" })
    end,
    keys = {
      {
        "<Tab>",
        function() return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>" end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function() return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>" end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "onsails/lspkind.nvim" },
    opts = function(_, opts)
      local lspkind = require("lspkind")
      opts.formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 40,
          ellipsis_char = "...",
          before = function(_, vim_item)
            vim_item.menu = ""
            return vim_item
          end,
          symbol_map = {
            Array = " ",
            Boolean = "󰨙 ",
            Class = " ",
            Color = " ",
            Control = " ",
            Collapsed = " ",
            Constant = "󰏿 ",
            Constructor = " ",
            Copilot = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = " ",
            Folder = " ",
            Function = "󰊕 ",
            Interface = " ",
            Key = " ",
            Keyword = " ",
            Method = "󰊕 ",
            Module = " ",
            Namespace = "󰦮 ",
            Null = " ",
            Number = "󰎠 ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            Reference = " ",
            Snippet = " ",
            String = " ",
            Struct = "󰆼 ",
            Text = " ",
            TypeParameter = " ",
            Unit = " ",
            Value = " ",
            Variable = "󰀫 ",
          },
        }),
      }
    end,
  },
  {
    "hrsh7th/cmp-cmdline",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    event = "CmdlineEnter",
    config = function()
      local cmp = require("cmp")

      local mapping = vim.tbl_deep_extend("force", cmp.mapping.preset.cmdline(), {
        ["<c-down>"] = {
          c = function()
            local fn = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, false, true), "n", true)
            end
            if cmp.visible() then fn = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) end
            fn()
          end,
        },
        ["<c-up>"] = {
          c = function()
            local fn = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, false, true), "n", true)
            end
            if cmp.visible() then fn = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) end
            fn()
          end,
        },
      })

      cmp.setup.cmdline(":", {
        mapping = mapping,
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
      cmp.setup.cmdline("/", {
        mapping = mapping,
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
}
