local lsp = vim.lsp

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      ensure_installed = {},
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local bufnr = args.buf
          local ft = vim.bo[bufnr].filetype
          if ft == "" then return end

          local lang = vim.treesitter.language.get_lang(ft) or ft
          if pcall(vim.treesitter.start, bufnr, lang) then
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[0][0].foldmethod = "expr"
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
    config = function(_, opts)
      local ts = require("nvim-treesitter")

      ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })

      local to_install = {}
      for _, lang in ipairs(opts.ensure_installed) do
        local ok = pcall(vim.treesitter.language.inspect, lang)
        if not ok then table.insert(to_install, lang) end
      end

      if #to_install > 0 then ts.install(to_install) end
    end,
  },
  {
    "MeanderingProgrammer/treesitter-modules.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      vim.api.nvim_create_user_command("InspectTextObjects", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        row = row - 1

        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if not lang then
          print("Not supported language for textobjects: " .. vim.bo.filetype)
          return
        end

        local ok, query = pcall(vim.treesitter.query.get, lang, "textobjects")
        if not ok or not query then
          print("Query textobjects not found for language: " .. lang)
          return
        end

        local parser = vim.treesitter.get_parser(bufnr)
        local root = parser:parse()[1]:root()
        local items = {}

        for id, node in query:iter_captures(root, bufnr) do
          local name = query.captures[id]
          local srow, scol, erow, ecol = node:range()
          if srow <= row and row <= erow then
            table.insert(items, { name = name, srow = srow, scol = scol, erow = erow, ecol = ecol })
          end
        end

        local function get_depth(item, items)
          local depth = 0
          for _, other in ipairs(items) do
            if other ~= item and other.srow <= item.srow and item.erow <= other.erow then depth = depth + 1 end
          end
          return depth
        end

        local output = {}
        for _, item in ipairs(items) do
          local depth = get_depth(item, items)
          local indent = string.rep("  ", depth)
          table.insert(
            output,
            string.format(
              "%s@%s [%d:%d - %d:%d]",
              indent,
              item.name,
              item.srow + 1,
              item.scol + 1,
              item.erow + 1,
              item.ecol + 1
            )
          )
        end

        print(table.concat(output, "\n"))
      end, {})
    end,
    command = "InspectTextObjects",
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

      local all_lsp_servers = vim.tbl_keys(require("mason-lspconfig").get_mappings().lspconfig_to_mason)

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
      lkey("cH", function() lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled()) end, "signature", { "n" }),
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
      lkey("cf", function() require("conform").format({ bufnr = 0 }) end, "format", { "n", "v" }),
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
