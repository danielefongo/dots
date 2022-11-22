local lsp = require("lspconfig")
local cmp = require("cmp_nvim_lsp")
local signature = require("lsp_signature")

local flags = { debounce_text_changes = 150 }
local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

local function cmd_path(server)
  return fn.glob(fn.stdpath("data") .. "/lsp/bin/" .. server)
end

local function on_attach_common(_, bufnr)
  signature.on_attach({ bind = true }, bufnr)
  buffer_code_bindings(bufnr)
end

local function on_attach(client, bufnr)
  on_attach_common(client, bufnr)
  vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 5000)]])
end

local function on_attach_eslint(_, _)
  vim.cmd([[autocmd BufWritePre <buffer> EslintFixAll]])
end

lsp["elixirls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  cmd = { cmd_path("elixir-ls") },
  settings = {
    elixirLS = {
      fetchDeps = false,
      mixEnv = "dev"
    }
  }
})

lsp["elmls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags
})

lsp["eslint"].setup({
  capabilities = capabilities,
  on_attach = on_attach_eslint,
  flags = flags
})

lsp["jsonls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags
})

lsp["pylsp"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags
})

lsp["rust_analyzer"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags
})

lsp["sumneko_lua"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      }
    }
  }
})

lsp["tsserver"].setup({
  capabilities = capabilities,
  on_attach = on_attach_common,
  flags = flags
})

vim.diagnostic.config({ virtual_text = false })
