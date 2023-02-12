vim.o.timeout = true
vim.o.timeoutlen = 100

local wk = require("which-key")
wk.setup()
wk.register({
  [";"] = { ":Commentary<cr>", "comment" },
  b = {
    name = "buffer",
    ["["] = { ":bp<cr>", "previous" },
    ["]"] = { ":bn<cr>", "next" },
    k = { ":lua require('close_buffers').delete({ type = 'this' })<cr>", "close" },
    K = { ":lua require('close_buffers').delete({ type = 'all' })<cr>", "close all" },
    H = { ":lua require('close_buffers').delete({ type = 'other' })<cr>", "close all" },
    s = { ":w<cr>", "save" },
    S = { ":wa<cr>", "save all" },
  },
  c = {
    name = "code",
    ["["] = { "<C-o><cr>", "previous" },
    ["]"] = { "<C-i><cr>", "next" },
    a = { ":lua require('fzf-lua').lsp_code_actions()<cr>", "actions" },
    d = { ":lua require('fzf-lua').lsp_definitions()<cr>", "definitions" },
    D = { ":lua require('fzf-lua').lsp_declarations()<cr>", "declarations" },
    i = { ":lua require('fzf-lua').lsp_implementations()<cr>", "implementations" },
    r = { ":lua require('fzf-lua').lsp_references()<cr>", "references" },
    t = { ":lua require('fzf-lua').lsp_typedefs()<cr>", "typedefs" },
  },
  d = {
    name = "diagnostic",
    ["["] = { ":lua vim.diagnostic.goto_prev({ wrap = false })<cr>", "previous" },
    ["]"] = { ":lua vim.diagnostic.goto_next({ wrap = false })<cr>", "next" },
    ["?"] = { "<leader>d?", "show" },
    t = { ":lua require('trouble').toggle('document_diagnostics')<cr>", "trouble buffer" },
    T = { ":lua require('trouble').toggle('workspace_diagnostics')<cr>", "trouble workspace" },
  },
  f = {
    name = "find",
    b = { ":lua require('fzf-lua').grep_curbuf()<cr>", "buffer text" },
    c = { ":lua require('fzf-lua').command_history()<cr>", "commands" },
    k = { ":lua require('fzf-lua').keymaps()<cr>", "keymaps" },
    w = { ":lua require('fzf-lua').grep_project()<cr>", "workspace text" },
    s = {
      name = "symbol",
      b = { ":lua require('fzf-lua').lsp_document_symbols()<cr>", "buffer symbol" },
      w = { ":lua require('fzf-lua').lsp_live_workspace_symbols()<cr>", "workspace symbol" },
    },
  },
  g = {
    name = "git",
    g = { ":lua require('neogit').open()<cr>", "neo" },
  },
  o = {
    name = "open",
    b = { ":lua require('fzf-lua').buffers()<cr>", "buffer" },
    f = { ":lua require('fzf-lua').files()<cr>", "file" },
    t = { ":lua require('nvim-tree').toggle()<cr>", "tree" },
  },
  r = { ":lua require('replacer').run()<cr>", "replace" },
  s = {
    name = "session",
    d = { ":lua require('auto-session').DeleteSession()<cr>", "delete" },
    l = { ":lua require('session-lens').search_session()<cr>", "load" },
    s = { ":lua require('auto-session').SaveSession()<cr>", "save" },
  },
  v = {
    name = "vim",
    q = { ":qa<cr>", "quit" },
  },
  w = { "<C-w>", "windows" },
}, { prefix = "<leader>" })

wk.register({
  [";"] = { ":Commentary<cr>", "comment" },
}, { prefix = "<leader>", mode = "v" })

function _G.buffer_code_bindings(bufnr)
  wk.register({
    c = {
      h = { ":lua vim.lsp.buf.signature_help()<cr>", "signature" },
      R = { ":lua vim.lsp.buf.rename()<cr>", "rename" },
    },
  }, { prefix = "<leader>", buffer = bufnr })
end
