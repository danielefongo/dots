return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    opts = {
      sync_root_with_cwd = true,
      view = {
        side = "left",
        width = {
          min = 25,
          max = 75,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
            modified = false,
            diagnostics = true,
            bookmarks = true,
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      diagnostics = {
        enable = true,
        severity = {
          min = vim.diagnostic.severity.WARN,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      modified = {
        enable = false,
      },
    },
  },
}
