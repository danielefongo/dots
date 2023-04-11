return {
  {
    "rmagatti/session-lens",
    dependencies = { "rmagatti/auto-session", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "plenary.nvim" },
    config = function()
      local function close_nvim_tree()
        vim.cmd("NvimTreeClose")
      end

      require("auto-session").setup({
        auto_session_use_git_branch = false,
        auto_session_create_enabled = false,
        cwd_change_handling = false,
        pre_save_cmds = { close_nvim_tree },
      })

      require("session-lens").setup({
        path_display = { "shorten" },
        theme_conf = { border = true },
        previewer = false,
      })
    end,
  },
}
