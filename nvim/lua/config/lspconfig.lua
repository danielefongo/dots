local lsp = require("lspconfig")
local cmp = require("cmp_nvim_lsp")
local signature = require("lsp_signature")

local flags = { debounce_text_changes = 150 }
local capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function full_path(server, path)
  return fn.glob(fn.stdpath("data") .. "/lsp" .. "/" .. server .. "/" .. path)
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
  cmd = { full_path("elixirls", "elixir-ls/language_server.sh") },
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
  flags = flags,
  cmd = { full_path("elmls", "node_modules/@elm-tooling/elm-language-server/out/index.js") }
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
  flags = flags,
  cmd = { full_path("pylsp", "venv/bin/pylsp") }
})

lsp["rust_analyzer"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  cmd = { full_path("rust_analyzer", "rust-analyzer") }
})

lsp["sumneko_lua"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = flags,
  cmd = { full_path("sumneko_lua", "extension/server/bin/lua-language-server") },
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
  flags = flags,
  cmd = { full_path("tsserver", "node_modules/typescript-language-server/lib/cli.js"), "--stdio" }
})

vim.diagnostic.config({ virtual_text = false })
