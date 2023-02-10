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

  buffer_code_bindings(bufnr)
end

local lsps = {
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
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        format = { enable = false },
      },
    },
  },
  pylsp = {},
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
