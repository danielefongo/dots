return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 100

    local wk = require("which-key")
    wk.register({
      [";"] = { ":Commentary<cr>", "comment" },
      b = {
        name = "buffer",
        ["e"] = { ":bp<cr>", "previous" },
        ["n"] = { ":bn<cr>", "next" },
        k = { ":lua require('close_buffers').delete({ type = 'this' })<cr>", "close" },
        K = { ":lua require('close_buffers').delete({ type = 'all' })<cr>", "close all" },
        H = { ":lua require('close_buffers').delete({ type = 'other' })<cr>", "close all" },
        s = { ":w<cr>", "save" },
        S = { ":wa<cr>", "save all" },
      },
      c = {
        name = "code",
        c = { ":lua require('nvim-highlight-colors').toggle()<cr>", "colors" },
        ["e"] = { "<C-o><cr>", "previous" },
        ["n"] = { "<C-i><cr>", "next" },
        a = { ":lua vim.lsp.buf.code_action()<cr>", "actions" },
        d = { ":Microscope code_definitions<cr>", "definitions" },
        h = { ":lua vim.lsp.buf.hover()<cr>", "signature" },
        i = { ":Microscope code_implementations<cr>", "implementations" },
        r = { ":Microscope code_references<cr>", "references" },
        R = { ":lua vim.lsp.buf.rename()<cr>", "rename" },
        t = { ":Microscope code_type_definition<cr>", "typedefs" },
      },
      d = {
        name = "diagnostic",
        ["e"] = { ":lua vim.diagnostic.goto_prev({ wrap = false })<cr>", "previous" },
        ["n"] = { ":lua vim.diagnostic.goto_next({ wrap = false })<cr>", "next" },
        ["?"] = { "<leader>d?", "show" },
        t = { ":lua require('trouble').toggle('document_diagnostics')<cr>", "trouble buffer" },
        T = { ":lua require('trouble').toggle('workspace_diagnostics')<cr>", "trouble workspace" },
      },
      f = {
        name = "find",
        b = { ":Microscope buffer_grep<cr>", "buffer text" },
        c = { ":Telescope command_history<cr>", "commands" },
        k = { ":Telescope keymaps<cr>", "keymaps" },
        w = { ":Microscope workspace_grep<cr>", "workspace text" },
        s = {
          name = "symbol",
          b = { ":Microscope code_buffer_symbols<cr>", "buffer symbol" },
          w = { ":Microscope code_workspace_symbols<cr>", "workspace symbol" },
        },
      },
      g = {
        name = "git",
        b = { ":Gitsigns blame_line<cr>", "blame line" },
        g = { ":Neogit<cr>", "neo" },
        h = { ":Gitsigns preview_hunk<cr>", "preview hunk" },
        s = { ":Gitsigns stage_hunk<cr>", "stage hunk" },
        S = { ":Gitsigns undo_stage_hunk<cr>", "stage hunk" },
        r = { ":Gitsigns reset_hunk<cr>", "reset hunk" },
      },
      o = {
        name = "open",
        b = { ":Microscope buffer<cr>", "buffer" },
        f = { ":Microscope file<cr>", "file" },
        t = { ":Oil<cr>", "tree" },
      },
      r = { ":lua require('replacer').run()<cr>", "replace" },
      s = {
        name = "session",
        d = { ":lua require('persistence').delete_current_and_stop()<cr>", "delete current and stop" },
      },
      v = {
        name = "vim",
        q = { ":qa<cr>", "quit" },
      },
      w = { "<C-w>", "windows" },
    }, { prefix = "<leader>" })

    -- stylua: ignore
    wk.register({
      s = { function() require('flash').jump() end, "seek" },
      S = { function() require('flash').treesitter() end, "seek" },
    }, { mode = { "n", "x" } })

    wk.register({
      [";"] = { ":Commentary<cr>", "comment" },
      c = {
        name = "code",
        a = { ":lua vim.lsp.buf.code_action()<cr>", "actions" },
      },
    }, { prefix = "<leader>", mode = "v" })

    wk.register({
      ["<c-f>"] = { "za", "toggle fold" },
    }, { mode = "n" })

    wk.register({
      ["<a-q>"] = { ":lua close_win()<cr>", "close buffer" },
    }, { mode = "n" })

    wk.register({
      ["<a-c-Left>"] = { ":lua require('tile').resize_left()<cr>", "resize left" },
      ["<a-c-Down>"] = { ":lua require('tile').resize_down()<cr>", "resize down" },
      ["<a-c-Up>"] = { ":lua require('tile').resize_up()<cr>", "resize up" },
      ["<a-c-Right>"] = { ":lua require('tile').resize_right()<cr>", "resize right" },
      ["<a-s-Left>"] = { ":lua require('tile').shift_left()<cr>", "shift left" },
      ["<a-s-Down>"] = { ":lua require('tile').shift_down()<cr>", "shift down" },
      ["<a-s-Up>"] = { ":lua require('tile').shift_up()<cr>", "shift up" },
      ["<a-s-Right>"] = { ":lua require('tile').shift_right()<cr>", "shift right" },
    }, { mode = "n" })
  end,
}
