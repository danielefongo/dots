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
