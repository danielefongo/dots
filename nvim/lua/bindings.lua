-- neovim
set_key("n", "<leader>", "<Nop>")
set_key("n", "<leader>vr", ":lua reload_config()<cr>")
set_key("n", "<leader>vq", ":qa<cr>")

-- windows
set_key("n", "<leader>w", "<C-w>")

-- buffers
set_key('n', '<leader>bb', ":FzfLua buffers<cr>")
set_key('n', '<leader>bk', ':lua require("close_buffers").delete({ type = \'this\' })<cr>')
set_key('n', '<leader>bK', ':lua require("close_buffers").delete({ type = \'all\' })<cr>')
set_key('n', '<leader>bH', ':lua require("close_buffers").delete({ type = \'other\' })<cr>')
set_key('n', '<leader>bs', ':w<cr>')
set_key('n', '<leader>bsw', ':wa<cr>')

-- navigation
set_key('n', '<leader>b]', ':bn<cr>')
set_key('n', '<leader>b[', ':bp<cr>')
set_key('n', '<leader>g[', '<C-o><cr>')
set_key('n', '<leader>g]', '<C-i><cr>')

-- comments
set_key("n", "<A-;>", ":commentary<cr>")
set_key("v", "<A-;>", ":Commentary<cr>")

-- files
set_key("n", "<leader><space>", ":FzfLua files<cr>")
set_key("n", "<leader>oP", ":NeoTreeReveal!<cr>")
set_key("n", "<leader>op", ":NeoTreeFocusToggle<cr>")

-- search
set_key('n', '<leader>sk', ":FzfLua keymaps<cr>")
set_key('n', '<leader>sc', ":FzfLua command_history<cr>")
set_key('n', '<leader>sb', ":FzfLua grep_curbuf<cr>")
set_key('n', '<leader>sw', ":FzfLua grep_project<cr>")
set_key('n', '<leader>sr', ':lua require("spectre").open_visual()<cr>')

-- code
set_key('n', '<leader>ca', ":FzfLua lsp_code_actions<cr>")
set_key('n', '<leader>cd', ":FzfLua lsp_definitions<cr>")
set_key('n', '<leader>cD', ":FzfLua lsp_declarations<cr>")
set_key('n', '<leader>ci', ":FzfLua lsp_implementations<cr>")
set_key('n', '<leader>ct', ":FzfLua lsp_typedefs<cr>")
set_key('n', '<leader>cr', ":FzfLua lsp_references<cr>")
set_key('n', '<leader>cs', ":FzfLua lsp_document_symbols<cr>")
set_key('n', '<leader>cw', ":FzfLua lsp_workspace_symbols<cr>")
function _G.buffer_code_bindings(bufnr)
  set_buf_key(bufnr, "n", "<leader>ch", ":lua vim.lsp.buf.signature_help()<cr>")
  set_buf_key(bufnr, "n", "<leader>cR", ":lua vim.lsp.buf.rename()<cr>")
end

-- diagnostics
set_key('n', '<leader>d?', ':lua vim.diagnostic.open_float()<cr>')
set_key('n', '<leader>d[', ':lua vim.diagnostic.goto_prev({ wrap = false })<cr>')
set_key('n', '<leader>d]', ':lua vim.diagnostic.goto_next({ wrap = false })<cr>')
set_key("n", "<leader>dt", ":TroubleToggle document_diagnostics<cr>")
set_key("n", "<leader>dT", ":TroubleToggle workspace_diagnostics<cr>")

-- git
set_key("n", "<leader>gg", ":Neogit<cr>")
