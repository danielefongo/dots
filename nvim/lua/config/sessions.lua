return {
  "rmagatti/auto-session",
  lazy = false,
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
  end,
}
