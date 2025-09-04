return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 10000,
      preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
    keys = {
      lkey("gS", function() vim.cmd("Gitsigns undo_stage_hunk") end, "undo stage hunk"),
      lkey("gb", function() vim.cmd("Gitsigns blame_line") end, "blame line"),
      lkey("gh", function() vim.cmd("Gitsigns preview_hunk") end, "preview hunk"),
      lkey("gr", function() vim.cmd("Gitsigns reset_hunk") end, "reset hunk"),
      lkey("gs", function() vim.cmd("Gitsigns stage_hunk") end, "stage hunk"),
    },
  },
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "NeogitStatus" },
        group = vim.api.nvim_create_augroup("NeogitStatusOptions", {}),
        callback = function() vim.opt.foldcolumn = "0" end,
      })
    end,
    opts = {
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
    },
    keys = {
      lkey("gg", function() vim.cmd("Neogit") end, "neo"),
    },
  },
}
