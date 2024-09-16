local function init_tool(name, on_end)
  on_end = on_end or function() end

  if not name then
    return on_end()
  end

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
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      ensure_installed = {},
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
    },
    main = "nvim-treesitter.configs",
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
    opts = {},
    config = function(_, lsps)
      local lsp = require("lspconfig")
      local cmp = require("cmp_nvim_lsp")
      local signature = require("lsp_signature")

      local mason = require("mason")

      local flags = { debounce_text_changes = 150 }
      local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function on_attach(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        signature.on_attach({ bind = true }, bufnr)
      end

      mason.setup({ install_root_dir = fn.stdpath("data") .. "/lsp" })

      for lsp_name, config in pairs(lsps) do
        init_tool(config.mason_name, function()
          lsp[lsp_name].setup({
            capabilities = capabilities,
            on_attach = config.on_attach or on_attach,
            flags = flags,
            cmd = config.cmd,
            settings = config.settings or {},
            autostart = false,
          })
        end)
      end
    end,
    keys = {
      { "<leader>ce", ":LspStart<cr>", desc = "enable lsp", silent = true },
      { "<leader>cE", ":LspStop<cr>", desc = "disable lsp", silent = true },
      { "<leader>cR", ":lua vim.lsp.buf.rename()<cr>", desc = "rename", silent = true },
      { "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", desc = "actions", mode = { "n", "v" }, silent = true },
      { "<leader>ch", ":lua vim.lsp.buf.hover()<cr>", desc = "signature", silent = true },
      {
        "<leader>cH",
        ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
        desc = "inlay toggle",
        silent = true,
      },
      { "<leader>de", ":lua vim.diagnostic.goto_prev({ wrap = false })<cr>", desc = "previous", silent = true },
      { "<leader>dn", ":lua vim.diagnostic.goto_next({ wrap = false })<cr>", desc = "next", silent = true },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      mason_sources = {},
      options = {
        formatters_by_ft = {
          ["*"] = { "trim_whitespace", "trim_newlines" },
        },
        formatters = {},
      },
    },
    config = function(_, opts)
      local mason = require("mason")
      mason.setup({ install_root_dir = fn.stdpath("data") .. "/lsp" })

      local mason_sources = opts.mason_sources

      for _, formatter in pairs(mason_sources) do
        init_tool(formatter)
      end

      require("conform").setup(opts.options)

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end,
    keys = {
      { "<leader>cf", ":lua require('conform').format({ bufnr = 0 })<cr>", desc = "format", silent = true },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {
      position = "bottom",
      height = 10,
      keys = {
        ["<c-f>"] = "fold_toggle",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>dt", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "trouble buffer", silent = true },
      { "<leader>dT", ":Trouble diagnostics toggle<cr>", desc = "trouble workspace", silent = true },
    },
  },
  require("config.languages.bash"),
  require("config.languages.css"),
  require("config.languages.dockerfile"),
  require("config.languages.elixir"),
  require("config.languages.elm"),
  require("config.languages.html"),
  require("config.languages.javascript"),
  require("config.languages.json"),
  require("config.languages.lua"),
  require("config.languages.markdown"),
  require("config.languages.nix"),
  require("config.languages.python"),
  require("config.languages.rust"),
  require("config.languages.toml"),
}
