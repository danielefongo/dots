return {
  { "elixir-editors/vim-elixir" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
    opts = { window = { relative = "editor" } },
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "williamboman/mason.nvim",
    opts = { install_root_dir = fn.stdpath("data") .. "/lsp/" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "ray-x/lsp_signature.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "mason.nvim",
    },
    config = function()
      local lsp = require("lspconfig")
      local cmp = require("cmp_nvim_lsp")
      local signature = require("lsp_signature")
      local inlay = require("lsp-inlayhints")

      local flags = { debounce_text_changes = 150 }
      local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function cmd_path(server)
        return fn.glob(fn.stdpath("data") .. "/lsp/bin/" .. server)
      end

      local function on_attach(client, bufnr)
        signature.on_attach({ bind = true }, bufnr)
        inlay.on_attach(client, bufnr)
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

      require("mason-lspconfig").setup({
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
    dependencies = { "jay-babu/mason-null-ls.nvim", "nvim-lua/plenary.nvim", "mason.nvim" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.shfmt, -- bash / sh
          null_ls.builtins.formatting.mix, -- elixir
          null_ls.builtins.formatting.elm_format, -- elm
          null_ls.builtins.formatting.prettier, -- html stuff
          null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          }), -- lua
          null_ls.builtins.formatting.markdownlint, -- markdown
          null_ls.builtins.formatting.black, -- python
          null_ls.builtins.formatting.rustfmt, -- rust
          null_ls.builtins.formatting.taplo, -- toml
          null_ls.builtins.formatting.eslint, -- ts (js)
        },
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

      local mason_null_ls = require("mason-null-ls")
      mason_null_ls.setup({
        automatic_installation = true,
        automatic_setup = true,
      })
      mason_null_ls.setup_handlers()
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    opts = { inlay_hints = { highlight = "Comment" } },
  },
  {
    "folke/trouble.nvim",
    opts = { position = "bottom", height = 10 },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "hrsh7th/nvim-cmp",
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
          { name = "buffer" },
        },
      })
    end,
  },
}
