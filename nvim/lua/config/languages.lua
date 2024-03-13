local function init_tool(name, on_end)
  on_end = on_end or function() end

  local mr = require("mason-registry")
  mr.refresh()

  if not mr.has_package(name) then
    vim.api.nvim_err_write("Error: not existing mason package: " .. name)
    return
  end

  local package = mr.get_package(name)

  if not package:is_installed() then
    vim.print("Installing " .. name)
    package:install():once("close", function()
      vim.schedule_wrap(on_end)
    end)
  else
    on_end()
  end
end

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
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = "v",
            node_decremental = "V",
          },
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    opts = {},
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "ray-x/lsp_signature.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", config = true },
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    event = "VeryLazy",
    config = function()
      local lsp = require("lspconfig")
      local cmp = require("cmp_nvim_lsp")
      local signature = require("lsp_signature")

      local mason = require("mason")

      local flags = { debounce_text_changes = 150 }
      local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function cmd_path(server)
        return fn.glob(fn.stdpath("data") .. "/lsp/bin/" .. server)
      end

      local function on_attach(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        signature.on_attach({ bind = true }, bufnr)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(bufnr, true)
        end
      end

      local lsps = {
        bashls = {
          mason_name = "bash-language-server",
        },
        cssls = {
          mason_name = "css-lsp",
        },
        dockerls = {
          mason_name = "dockerfile-language-server",
        },
        elixirls = {
          mason_name = "elixir-ls",
          cmd = { cmd_path("elixir-ls") },
          settings = {
            elixirLS = {
              fetchDeps = false,
              mixEnv = "dev",
            },
          },
        },
        elmls = {
          mason_name = "elm-language-server",
        },
        html = {
          mason_name = "html-lsp",
        },
        lua_ls = {
          mason_name = "lua-language-server",
          settings = {
            Lua = {
              callSnippet = "Replace",
              diagnostics = { globals = { "vim" } },
              format = { enable = false },
            },
          },
        },
        marksman = {
          mason_name = "marksman",
        },
        pylsp = {
          mason_name = "python-lsp-server",
        },
        taplo = {
          mason_name = "taplo",
        },
        tsserver = {
          mason_name = "typescript-language-server",
        },
        rust_analyzer = {
          mason_name = "rust-analyzer",
        },
      }

      mason.setup({ install_root_dir = fn.stdpath("data") .. "/lsp" })

      for lsp_name, config in pairs(lsps) do
        init_tool(config.mason_name, function()
          lsp[lsp_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            flags = flags,
            cmd = config.cmd,
            settings = config.settings or {},
          })
        end)
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local mason = require("mason")
      mason.setup({ install_root_dir = fn.stdpath("data") .. "/lsp" })

      local null_sources = {
        "black",
        "elm-format",
        "eslint",
        "jq",
        "markdownlint",
        "mix",
        "prettier",
        "rustfmt",
        "shfmt",
        "stylua",
        "taplo",
      }

      for _, formatter in pairs(null_sources) do
        init_tool(formatter)
      end

      require("conform").setup({
        formatters_by_ft = {
          bash = { "shfmt" },
          css = { "prettier" },
          elixir = { "mix" },
          elm = { "elm_format" },
          html = { "prettier" },
          javascript = { { "eslint", "prettier" } },
          json = { "jq" },
          lua = { "stylua" },
          markdown = { "markdownlint" },
          python = { "black" },
          rust = { "rustfmt" },
          scss = { "prettier" },
          sh = { "shfmt" },
          toml = { "taplo" },
          typescript = { { "eslint", "prettier" } },
          ["*"] = { "trim_whitespace", "trim_newlines" },
        },
      })

      require("conform").formatters.stylua = {
        prepend_args = function(_, _)
          return {
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
          }
        end,
      }

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
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
          ["<C-e>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
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
