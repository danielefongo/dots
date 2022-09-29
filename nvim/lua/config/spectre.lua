require('spectre').setup({
  color_devicons = true,
  live_update = true,
  mapping = {
    ['toggle_line'] = {
      map = "dd",
      cmd = ":lua require('spectre').toggle_line()<cr>",
      desc = "toggle current item"
    },
    ['enter_file'] = {
      map = "<cr>",
      cmd = ":lua require('spectre.actions').select_entry()<cr>",
      desc = "goto current file"
    },
    ['run_current_replace'] = {
      map = "<leader>rc",
      cmd = ":lua require('spectre.actions').run_current_replace()<cr>",
      desc = "replace current line"
    },
    ['run_replace'] = {
      map = "<leader>ra",
      cmd = ":lua require('spectre.actions').run_replace()<cr>",
      desc = "replace all"
    },
    ['toggle_ignore_case'] = {
      map = "ti",
      cmd = ":lua require('spectre').change_options('ignore-case')<cr>",
      desc = "toggle ignore case"
    },
    ['toggle_ignore_hidden'] = {
      map = "th",
      cmd = ":lua require('spectre').change_options('hidden')<cr>",
      desc = "toggle search hidden"
    },
  }
})
