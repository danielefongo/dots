local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.mix, -- elixir
    null_ls.builtins.formatting.elm_format, -- elm
    null_ls.builtins.formatting.stylua.with({
      extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    }), -- lua
    null_ls.builtins.formatting.black, -- python
    null_ls.builtins.formatting.rustfmt, -- rust
    null_ls.builtins.formatting.prettier, -- ts (js)
    null_ls.builtins.formatting.eslint, -- ts (js)
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function()
              return client.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})
