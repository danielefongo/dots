local function close_neo_tree()
  require("neo-tree.sources.manager").close_all()
end

require("auto-session").setup({
  auto_session_use_git_branch = false,
  auto_session_create_enabled = false,
  cwd_change_handling = false,
  bypass_session_save_file_types = { "neo-tree" },
  pre_save_cmds = { close_neo_tree },
})

require("session-lens").setup({
  path_display = { "shorten" },
  theme_conf = { border = true },
  previewer = false,
})
