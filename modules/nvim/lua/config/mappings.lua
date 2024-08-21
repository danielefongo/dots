return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 100

    local wk = require("which-key")

    wk.add({
      { "<leader>;", ":Commentary<cr>", desc = "comment", mode = { "n", "v" } },

      { "<leader>b", group = "buffer" },
      { "<leader>bH", ":lua require('close_buffers').delete({ type = 'other' })<cr>", desc = "close all" },
      { "<leader>bK", ":lua require('close_buffers').delete({ type = 'all' })<cr>", desc = "close all" },
      { "<leader>be", ":bp<cr>", desc = "previous" },
      { "<leader>bk", ":lua require('close_buffers').delete({ type = 'this' })<cr>", desc = "close" },
      { "<leader>bn", ":bn<cr>", desc = "next" },
      { "<leader>bs", ":lua scratch()<cr>", desc = "scratch" },

      { "<leader>c", group = "code" },
      { "<leader>cR", ":lua vim.lsp.buf.rename()<cr>", desc = "rename" },
      { "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", desc = "actions", mode = { "n", "v" } },
      { "<leader>cc", ":lua require('nvim-highlight-colors').toggle()<cr>", desc = "colors" },
      { "<leader>cd", ":Microscope code_definitions<cr>", desc = "definitions" },
      { "<leader>ce", "<C-o><cr>", desc = "previous" },
      { "<leader>cf", ":lua require('conform').format({ bufnr = 0 })<cr>", desc = "format" },
      { "<leader>ch", ":lua vim.lsp.buf.hover()<cr>", desc = "signature" },
      { "<leader>ci", ":Microscope code_implementations<cr>", desc = "implementations" },
      { "<leader>cn", "<C-i><cr>", desc = "next" },
      { "<leader>cr", ":Microscope code_references<cr>", desc = "references" },
      { "<leader>ct", ":Microscope code_type_definition<cr>", desc = "typedefs" },

      { "<leader>d", group = "diagnostic" },
      { "<leader>d?", "<leader>d?", desc = "show" },
      { "<leader>de", ":lua vim.diagnostic.goto_prev({ wrap = false })<cr>", desc = "previous" },
      { "<leader>dn", ":lua vim.diagnostic.goto_next({ wrap = false })<cr>", desc = "next" },
      { "<leader>dt", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "trouble workspace" },
      { "<leader>dT", ":Trouble diagnostics toggle<cr>", desc = "trouble buffer" },

      { "<leader>f", group = "find" },
      { "<leader>fb", ":Microscope buffer_grep<cr>", desc = "buffer text" },
      { "<leader>fc", ":Telescope command_history<cr>", desc = "commands" },
      { "<leader>fk", ":Telescope keymaps<cr>", desc = "keymaps" },
      { "<leader>fs", group = "symbol" },
      { "<leader>fsb", ":Microscope code_buffer_symbols<cr>", desc = "buffer symbol" },
      { "<leader>fsw", ":Microscope code_workspace_symbols<cr>", desc = "workspace symbol" },
      { "<leader>fw", ":Microscope workspace_grep<cr>", desc = "workspace text" },

      { "<leader>g", group = "git" },
      { "<leader>gS", ":Gitsigns undo_stage_hunk<cr>", desc = "stage hunk" },
      { "<leader>gb", ":Gitsigns blame_line<cr>", desc = "blame line" },
      { "<leader>gg", ":Neogit<cr>", desc = "neo" },
      { "<leader>gh", ":Gitsigns preview_hunk<cr>", desc = "preview hunk" },
      { "<leader>gr", ":Gitsigns reset_hunk<cr>", desc = "reset hunk" },
      { "<leader>gs", ":Gitsigns stage_hunk<cr>", desc = "stage hunk" },

      { "<leader>o", group = "open" },
      { "<leader>ob", ":Microscope buffer<cr>", desc = "buffer" },
      { "<leader>of", ":Microscope file<cr>", desc = "file" },
      { "<leader>ot", ":Oil<cr>", desc = "tree" },

      { "<leader>r", ":lua require('replacer').run()<cr>", desc = "replace" },

      { "<leader>s", group = "session" },
      { "<leader>sd", ":lua require('persistence').delete_current_and_stop()<cr>", desc = "delete" },
      { "<leader>sl", ":lua require('persistence').load()<cr>", desc = "load" },
      { "<leader>ss", ":lua require('persistence').save()<cr>", desc = "save" },

      { "<leader>v", group = "vim" },
      { "<leader>vq", ":qa<cr>", desc = "quit" },

      { "<leader>w", "<C-w>", desc = "windows" },
    })

    -- stylua: ignore
    wk.add({
      { "s", function() require('flash').jump() end, desc = "seek", mode = { "n", "x" } },
      { "S", function() require('flash').treesitter() end, desc = "seek", mode = { "n", "x" } },
    })

    wk.add({
      { "<c-f>", "za", desc = "toggle fold" },
      { "<a-q>", ":lua close_win()<cr>", desc = "close buffer" },
    })

    -- resize
    wk.add({
      { "<a-c-Down>", ":lua require('tile').resize_down()<cr>", desc = "resize down" },
      { "<a-c-Left>", ":lua require('tile').resize_left()<cr>", desc = "resize left" },
      { "<a-c-Right>", ":lua require('tile').resize_right()<cr>", desc = "resize right" },
      { "<a-c-Up>", ":lua require('tile').resize_up()<cr>", desc = "resize up" },
      { "<a-s-Down>", ":lua require('tile').shift_down()<cr>", desc = "shift down" },
      { "<a-s-Left>", ":lua require('tile').shift_left()<cr>", desc = "shift left" },
      { "<a-s-Right>", ":lua require('tile').shift_right()<cr>", desc = "shift right" },
      { "<a-s-Up>", ":lua require('tile').shift_up()<cr>", desc = "shift up" },
    })

    -- colemak remap
    wk.add({
      mode = { "n", "v", "o" },
      { "E", "K", desc = "-" },
      { "H", "I", desc = "insert beginning" },
      { "I", "L", desc = "-" },
      { "J", "E", desc = "end WORD" },
      { "K", "N", desc = "find previous" },
      { "N", "J", desc = "join lines" },
      { "e", "k", desc = "up" },
      { "h", "i", desc = "insert" },
      { "i", "l", desc = "right" },
      { "j", "e", desc = "end word" },
      { "k", "n", desc = "find next" },
      { "m", "h", desc = "left" },
      { "n", "j", desc = "down" },
    })
  end,
}
