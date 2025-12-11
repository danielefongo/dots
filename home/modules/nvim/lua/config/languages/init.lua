local lsp = vim.lsp

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
    "nvim-mini/mini.ai",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        silent = true,
        custom_textobjects = {
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          ["/"] = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          s = { -- Single words in different cases (camelCase, snake_case, etc.)
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[^%s%p][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
              "%f[^%s%p][%a%d]+%f[^%a%d]",
              "^[%a%d]+%f[^%a%d]",
            },
            "^().*()$",
          },
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
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

      function _G.override_config(lsp_name, config)
        vim.lsp.config(lsp_name, vim.tbl_deep_extend("force", vim.lsp.config[lsp_name] or {}, config or {}))
        lsp_toggle(false)
        vim.defer_fn(function() lsp_toggle(true) end, 100)
      end
    end,
    keys = {
      lkey("ce", function() lsp_toggle(true) end, "enable lsp"),
      lkey("cE", function() lsp_toggle(false) end, "disable lsp"),
      lkey("cR", function() vim.lsp.buf.rename() end, "rename"),
      lkey("ca", function() vim.lsp.buf.code_action() end, "actions", { "n", "v" }),
      lkey("ch", function() lsp.buf.hover() end, "signature"),
      lkey("cH", function() lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled()) end, "signature", { "n", "i" }),
      lkey("d,", function() vim.diagnostic.jump({ count = -1, float = true }) end, "previous"),
      lkey("d.", function() vim.diagnostic.jump({ count = 1, float = true }) end, "next"),
      lkey("dh", function() vim.diagnostic.open_float() end, "help"),
      lkey("ds", function()
        local virtual_text = not vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ severity_sort = true, virtual_text = virtual_text })
      end, "show"),
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
      lkey("cf", function() require("conform").format({ bufnr = 0 }) end, "format"),
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
      lkey("dt", function() vim.cmd("Trouble diagnostics toggle filter.buf=0") end, "trouble buffer"),
      lkey("dT", function() vim.cmd("Trouble diagnostics toggle") end, "trouble workspace"),
    },
  },
  require("config.languages.bash"),
  require("config.languages.c"),
  require("config.languages.clojure"),
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
  require("config.languages.toml"),
}
