return {
  "folke/which-key.nvim",
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 100

    local wk = require("which-key")
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
        a = { ":lua vim.lsp.buf.code_action()<cr>", "actions" },
        d = { ":lua require('telescope.builtin').lsp_definitions()<cr>", "definitions" },
        h = { ":lua vim.lsp.buf.signature_help()<cr>", "signature" },
        i = { ":lua require('telescope.builtin').lsp_implementations()<cr>", "implementations" },
        r = { ":lua require('telescope.builtin').lsp_references()<cr>", "references" },
        R = { ":lua vim.lsp.buf.rename()<cr>", "rename" },
        t = { ":lua require('telescope.builtin').lsp_type_definitions()<cr>", "typedefs" },
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
        b = { ":lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", "buffer text" },
        c = { ":lua require('telescope.builtin').command_history()<cr>", "commands" },
        k = { ":lua require('telescope.builtin').keymaps()<cr>", "keymaps" },
        w = { ":lua require('telescope.builtin').live_grep()<cr>", "workspace text" },
        s = {
          name = "symbol",
          b = { ":lua require('telescope.builtin').lsp_document_symbols()<cr>", "buffer symbol" },
          w = { ":lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", "workspace symbol" },
        },
      },
      g = {
        name = "git",
        g = { ":lua require('neogit').open()<cr>", "neo" },
      },
      o = {
        name = "open",
        b = { ":lua require('telescope.builtin').buffers()<cr>", "buffer" },
        f = { ":lua require('telescope.builtin').find_files()<cr>", "file" },
        t = { ":NvimTreeToggle<cr>", "tree" },
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
  end,
}
