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
    event = "LspAttach",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "mason-org/mason-lspconfig.nvim", version = "^1.0.0", config = function() end },
    },
    opts = { lsps = {} },
    config = function(_, opts)
      local mason_lsp = require("mason-lspconfig")
      local blink = require("blink.cmp")

      local all_lsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

      local ensure_installed = {}
      for lsp_name, lsp_configuration in pairs(opts.lsps) do
        if vim.tbl_contains(all_lsp_servers, lsp_name) then table.insert(ensure_installed, lsp_name) end
        vim.lsp.config[lsp_name] = vim.tbl_deep_extend(
          "force",
          lsp_configuration,
          { capabilities = blink.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()) }
        )
      end

      mason_lsp.setup({ ensure_installed = ensure_installed })

      function _G.lsp_toggle(enabled)
        local filetype = vim.bo.filetype

        for _, lsp_configuration in pairs(opts.lsps) do
          if lsp_configuration.lsp_custom_toggle and lsp_configuration.lsp_custom_toggle[filetype] then
            return lsp_configuration.lsp_custom_toggle[filetype](enabled)
          end
        end

        for lsp_name, lsp_configuration in pairs(opts.lsps) do
          if vim.tbl_contains(lsp_configuration.filetypes or {}, filetype) then vim.lsp.enable(lsp_name, enabled) end
        end
      end
    end,
    keys = {
      { "<leader>ce", ":lua lsp_toggle(true)<cr>", desc = "enable lsp", silent = true },
      { "<leader>cE", ":lua lsp_toggle(false)<cr>", desc = "disable lsp", silent = true },
      { "<leader>cR", ":lua vim.lsp.buf.rename()<cr>", desc = "rename", silent = true },
      { "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", desc = "actions", mode = { "n", "v" }, silent = true },
      { "<leader>ch", ":lua vim.lsp.buf.hover()<cr>", desc = "signature", silent = true },
      {
        "<leader>cH",
        ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
        desc = "inlay toggle",
        silent = true,
      },
      { "<leader>d,", ":lua vim.diagnostic.goto_prev({ wrap = false })<cr>", desc = "previous", silent = true },
      { "<leader>d.", ":lua vim.diagnostic.goto_next({ wrap = false })<cr>", desc = "next", silent = true },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufReadPost",
    dependencies = {
      "williamboman/mason.nvim",
      "zapling/mason-conform.nvim",
    },
    opts = {
      options = {
        formatters_by_ft = {
          ["*"] = { "trim_whitespace", "trim_newlines" },
        },
        formatters = {
          rustfmt = {
            command = "cargo fmt",
          },
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts.options)
      require("mason-conform").setup()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then return end
          client.server_capabilities.semanticTokensProvider = nil
          client.server_capabilities.documentFormattingProvider = false
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args) require("conform").format({ bufnr = args.buf, stop_after_first = true }) end,
      })
    end,
    keys = {
      { "<leader>cf", ":lua require('conform').format({ bufnr = 0 })<cr>", desc = "format", silent = true },
    },
  },
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    cmd = "Mason",
    opts = {
      install_root_dir = fn.stdpath("data") .. "/lsp",
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(
          function()
            require("lazy.core.handler.event").trigger({
              event = "FileType",
              buf = vim.api.nvim_get_current_buf(),
            })
          end,
          100
        )
      end)
    end,
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
  require("config.languages.c"),
  require("config.languages.css"),
  require("config.languages.dockerfile"),
  require("config.languages.elixir"),
  require("config.languages.elm"),
  require("config.languages.gdscript"),
  require("config.languages.graphql"),
  require("config.languages.html"),
  require("config.languages.javascript"),
  require("config.languages.json"),
  require("config.languages.lua"),
  require("config.languages.markdown"),
  require("config.languages.nix"),
  require("config.languages.python"),
  require("config.languages.rust"),
  -- require("config.languages.sql"),
  require("config.languages.toml"),
}
