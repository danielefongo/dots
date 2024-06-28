return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signcolumn = true,
      numhl = true,
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
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neogit").setup({
        signs = {
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "NeogitStatus" },
        group = vim.api.nvim_create_augroup("NeogitStatusOptions", {}),
        callback = function()
          vim.opt.foldcolumn = "0"
        end,
      })
    end,
  },
}
