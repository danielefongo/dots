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
    k = { ":lua require(\"close_buffers\").delete({ type = 'this' })<cr>", "close" },
    K = { ":lua require(\"close_buffers\").delete({ type = 'all' })<cr>", "close all" },
    H = { ":lua require(\"close_buffers\").delete({ type = 'other' })<cr>", "close all" },
    s = { ":w<cr>", "save" },
    S = { ":wa<cr>", "save all" },
  },
  c = {
    name = "code",
    ["["] = { "<C-o><cr>", "previous" },
    ["]"] = { "<C-i><cr>", "next" },
    a = { ":FzfLua lsp_code_actions<cr>", "actions" },
    d = { ":FzfLua lsp_definitions<cr>", "definitions" },
    D = { ":FzfLua lsp_declarations<cr>", "declarations" },
    i = { ":FzfLua lsp_implementations<cr>", "implementations" },
    r = { ":FzfLua lsp_references<cr>", "references" },
    t = { ":FzfLua lsp_typedefs<cr>", "typedefs" },
  },
  d = {
    name = "diagnostic",
    ["["] = { ":lua vim.diagnostic.goto_prev({ wrap = false })<cr>", "previous" },
    ["]"] = { ":lua vim.diagnostic.goto_next({ wrap = false })<cr>", "next" },
    ["?"] = { "<leader>d?", "show" },
    t = { ":TroubleToggle document_diagnostics<cr>", "trouble buffer" },
    T = { ":TroubleToggle workspace_diagnostics<cr>", "trouble workspace" },
  },
  f = {
    name = "find",
    b = { ":FzfLua grep_curbuf<cr>", "buffer text" },
    c = { ":FzfLua command_history<cr>", "commands" },
    k = { ":FzfLua keymaps<cr>", "keymaps" },
    w = { ":FzfLua grep_project<cr>", "workspace text" },
    s = {
      name = "symbol",
      b = { ":FzfLua lsp_document_symbols<cr>", "buffer symbol" },
      w = { ":FzfLua lsp_live_workspace_symbols<cr>", "workspace symbol" },
    },
  },
  g = {
    name = "git",
    g = { ":Neogit<cr>", "neo" },
  },
  o = {
    name = "open",
    b = { ":FzfLua buffers<cr>", "buffer" },
    f = { ":FzfLua files<cr>", "file" },
    t = { ":NeoTreeFocusToggle<cr>", "tree" },
    T = { ":NeoTreeReveal!<cr>", "tree (focus file)" },
  },
  r = { ":lua require('replacer').run()<cr>", "replace" },
  s = {
    name = "session",
    d = { ":DeleteSession<cr>", "delete" },
    l = { ":lua require('session-lens').search_session()<cr>", "load" },
    s = { ":SaveSession<cr>", "save" },
  },
  v = {
    name = "vim",
    r = { ":lua reload_config()<cr>", "reload" },
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
