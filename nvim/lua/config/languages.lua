return {
  { "elixir-editors/vim-elixir", event = "BufReadPre" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "elixir",
          "elm",
          "html",
          "javascript",
          "json",
          "markdown",
          "python",
          "rust",
          "lua",
          "toml",
          "typescript",
          "vim",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    opts = { window = { relative = "editor" } },
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "ray-x/lsp_signature.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = "VeryLazy",
    config = function()
      local lsp = require("lspconfig")
      local cmp = require("cmp_nvim_lsp")
      local signature = require("lsp_signature")
      local inlay = require("lsp-inlayhints")
      require("neodev").setup({})

      local mason = require("mason")
      local mason_lsp_config = require("mason-lspconfig")

      local flags = { debounce_text_changes = 150 }
      local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function cmd_path(server)
        return fn.glob(fn.stdpath("data") .. "/lsp/bin/" .. server)
      end

      local function on_attach(client, bufnr)
        signature.on_attach({ bind = true }, bufnr)
        inlay.on_attach(client, bufnr, true)
      end

      local lsps = {
        bashls = {},
        cssls = {},
        dockerls = {},
        elixirls = {
          cmd = { cmd_path("elixir-ls") },
          settings = {
            elixirLS = {
              fetchDeps = false,
              mixEnv = "dev",
            },
          },
        },
        elmls = {},
        html = {},
        lua_ls = {
          settings = {
            Lua = {
              callSnippet = "Replace",
              diagnostics = { globals = { "vim" } },
              format = { enable = false },
            },
          },
        },
        marksman = {},
        pylsp = {},
        taplo = {},
        tsserver = {},
        rust_analyzer = {},
      }

      mason.setup({ install_root_dir = fn.stdpath("data") .. "/lsp/" })

      mason_lsp_config.setup({
        ensure_installed = vim.tbl_keys(lsps),
        automatic_installation = true,
      })

      for lsp_name, config in pairs(lsps) do
        lsp[lsp_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          flags = flags,
          cmd = config.cmd,
          settings = config.settings or {},
        })
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    config = function()
      local mason = require("mason")
      local null_ls = require("null-ls")
      local mason_null_ls = require("mason-null-ls")

      local null_sources = {
        shfmt = null_ls.builtins.formatting.shfmt, -- bash / sh
        mix = null_ls.builtins.formatting.mix, -- elixir
        elm_format = null_ls.builtins.formatting.elm_format, -- elm
        prettier = null_ls.builtins.formatting.prettier, -- html stuff
        stylua = null_ls.builtins.formatting.stylua.with({
          extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        }), -- lua
        markdownlint = null_ls.builtins.formatting.markdownlint, -- markdown
        black = null_ls.builtins.formatting.black, -- python
        rustfmt = null_ls.builtins.formatting.rustfmt, -- rust
        taplo = null_ls.builtins.formatting.taplo, -- toml
        eslint = null_ls.builtins.formatting.eslint, -- ts (js)
      }

      mason.setup({ install_root_dir = fn.stdpath("data") .. "/lsp/" })

      null_ls.setup({
        sources = vim.tbl_values(null_sources),
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  filter = function()
                    return client.name == "null-ls"
                  end,
                })
              end,
            })
          end
        end,
      })

      mason_null_ls.setup({
        ensure_installed = vim.tbl_keys(null_sources),
        automatic_installation = true,
      })
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    event = "BufReadPost",
    opts = { inlay_hints = { highlight = "Comment" } },
  },
  {
    "folke/trouble.nvim",
    event = "BufReadPost",
    opts = { position = "bottom", height = 10 },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "BufReadPost",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<cr>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "path" },
          { name = "buffer", keyword_length = 2, max_item_count = 8 },
        },
        formatting = {
          fields = { "abbr", "kind" },
          max_width = 0,
          format = function(_, vim_item)
            local function trim(text)
              local max = 40
              if text and #text > max then
                text = text:sub(1, max) .. "..."
              end
              return text
            end

            vim_item.menu = ""
            vim_item.abbr = trim(vim_item.abbr)
            return vim_item
          end,
        },
      })
    end,
  },
}
