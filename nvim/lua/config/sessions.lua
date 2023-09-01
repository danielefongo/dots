return {
  "rmagatti/auto-session",
  lazy = false,
  config = function()
    require("auto-session").setup({
      auto_session_use_git_branch = false,
      auto_session_create_enabled = false,
      cwd_change_handling = false,
      pre_save_cmds = { require("nvim-tree.api").tree.close },
    })
  end,
}
