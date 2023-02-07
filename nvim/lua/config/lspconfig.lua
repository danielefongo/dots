local lsp = require("lspconfig")
local cmp = require("cmp_nvim_lsp")
local signature = require("lsp_signature")
local inlay = require("lsp-inlayhints")

local flags = { debounce_text_changes = 150 }
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
local settings = {
  elixirLS = {
    fetchDeps = false,
    mixEnv = "dev",
  },
  Lua = {
    diagnostics = { globals = { "vim" } },
  },
}

local function cmd_path(server)
  return fn.glob(fn.stdpath("data") .. "/lsp/bin/" .. server)
end

local function on_attach(client, bufnr)
  signature.on_attach({ bind = true }, bufnr)
  inlay.on_attach(client, bufnr)

  buffer_code_bindings(bufnr)
end

local function setup(lsp_name, command)
  lsp[lsp_name].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = flags,
    cmd = command,
    settings = settings,
  })
end

require("mason-lspconfig").setup({
  automatic_installation = true,
})
setup("elixirls", { cmd_path("elixir-ls") })
setup("elmls")
setup("sumneko_lua")
setup("pylsp")
setup("tsserver")
setup("rust_analyzer")
