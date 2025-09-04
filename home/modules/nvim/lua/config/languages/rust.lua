local base_config = {
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importEnforceGranularity = true,
        importPrefix = "crate",
      },
      cargo = {
        features = "all",
        targetDir = "target/rust-analyzer",
      },
      check = {
        features = "all",
        overrideCommand = { "cargo", "check", "--message-format=json", "--tests" },
      },
      diagnostics = {
        disabled = { "inactive-code" },
      },
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts) table.insert(opts.ensure_installed, "rust") end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts) opts.lsps["rust_analyzer"] = vim.deepcopy(base_config) end,
  },
  {
    "folke/snacks.nvim",
    init = function()
      local function pick_rust_package()
        local h = io.popen("cargo metadata --no-deps --format-version=1")
        if not h then return end
        local out = h:read("*a")
        h:close()

        local ok, meta = pcall(vim.json.decode, out)
        if not ok then
          vim.notify("rust-analyzer: parsing failed", vim.log.levels.ERROR)
          return
        end

        local items = {}
        for _, pkg in ipairs(meta.packages or {}) do
          local manifest = pkg.manifest_path
          local dir = vim.fn.fnamemodify(manifest, ":h")
          table.insert(items, {
            text = string.format("%s (%s)", pkg.name, pkg.version),
            pkg = pkg.name,
            dir = dir,
            file = manifest,
          })
        end
        table.sort(items, function(a, b) return a.pkg < b.pkg end)
        if #items == 1 then items = {} end

        table.insert(items, 1, {
          text = "WORKSPACE",
          pkg = nil,
          dir = vim.fn.getcwd(),
          file = vim.fn.getcwd() .. "/Cargo.toml",
        })

        local snacks = require("snacks")
        snacks.picker({
          title = "Rust Workspace Packages",
          items = items,
          format = function(item)
            local is_current = _G.current_rust_package == item.pkg
            if is_current then
              return { { "● " .. (item.pkg or item.text), "String" } }
            else
              return { { item.pkg or item.text, nil } }
            end
          end,
          preview = "file",
          confirm = function(picker, item)
            picker:close()

            _G.current_rust_package = item.pkg

            if item and item.pkg then
              override_config("rust_analyzer", {
                settings = {
                  ["rust-analyzer"] = {
                    cargo = {
                      extraArgs = { "-p", item.pkg },
                    },
                    check = {
                      overrideCommand = { "cargo", "check", "--message-format=json", "-p", item.pkg, "--tests" },
                    },
                  },
                },
              })
            else
              override_config("rust_analyzer", vim.deepcopy(base_config))
            end
          end,
        })
      end

      vim.api.nvim_create_user_command("LspRustPickPackage", pick_rust_package, {})
    end,
    keys = {
      lkey("cpp", function() vim.cmd("LspRustPickPackage") end, "Rust: pick package"),
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local util = require("conform.util")

      opts.options.formatters_by_ft.rust = { "rust" }
      opts.options.formatters.rust = {
        command = "rustfmt",
        options = {
          default_edition = "2024",
        },
        cwd = require("conform.util").root_file({ "rustfmt.toml", ".rustfmt.toml" }),
        args = function(self, ctx)
          local args = { "--emit=stdout" }
          local edition = util.parse_rust_edition(ctx.dirname) or self.options.default_edition
          table.insert(args, "--edition=" .. edition)

          return args
        end,
      }
    end,
  },
}
