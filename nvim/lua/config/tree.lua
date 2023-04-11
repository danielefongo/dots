return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    opts = {
      update_cwd = true,
      update_focused_file = {
        enable = true,
        update_cwd = false,
      },
      view = {
        adaptive_size = true,
        side = "left",
        width = 25,
        hide_root_folder = true,
      },
      git = {
        enable = true,
        ignore = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      filesystem_watchers = {
        enable = true,
      },
      renderer = {
        highlight_git = true,
        highlight_opened_files = "none",
        indent_markers = {
          enable = false,
        },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },
        },
      },
    },
  },
}
