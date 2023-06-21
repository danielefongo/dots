return {
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<A-j>"] = actions.preview_scrolling_down,
              ["<A-k>"] = actions.preview_scrolling_up,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            themes.get_dropdown({}),
          },
        },
      })

      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
    end,
  },
  {
    "danielefongo/microscope",
    dev = true,
    dependencies = {
      { "danielefongo/microscope-files", dev = true },
      { "danielefongo/microscope-buffers", dev = true },
      { "danielefongo/microscope-code", dev = true },
      { "danielefongo/microscope-git", dev = true },
      { "danielefongo/microscope-example", dev = true },
    },
    event = "VeryLazy",
    config = function()
      local microscope = require("microscope")
      local actions = require("microscope.builtin.actions")

      local files = require("microscope-files")
      local buffers = require("microscope-buffers")
      local code = require("microscope-code")
      local git = require("microscope-git")
      local example = require("microscope-example")

      microscope.setup({
        size = {
          width = 150,
          height = 50,
        },
        bindings = {
          ["<c-j>"] = actions.next,
          ["<c-k>"] = actions.previous,
          ["<c-n>"] = actions.scroll_down,
          ["<c-p>"] = actions.scroll_up,
          ["<cr>"] = actions.open,
          ["<esc>"] = actions.close,
          ["<tab>"] = actions.select,
          ["<c-f>"] = actions.toggle_full_screen,
          ["<c-r>"] = actions.refine,
          ["<c-q>"] = files.actions.quickfix,
        },
      })

      microscope.register(files.finders)
      microscope.register(buffers.finders)
      microscope.register(code.finders)
      microscope.register(git.finders)
      microscope.register(example.finders)
    end,
  },
}
