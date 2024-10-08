return {
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
          ["<c-n>"] = actions.next,
          ["<c-e>"] = actions.previous,
          ["<cr>"] = actions.open,
          ["<esc>"] = actions.close,
          ["<tab>"] = actions.select,
          ["<c-f>"] = actions.toggle_full_screen,
          ["<c-r>"] = actions.refine,
          ["<c-q>"] = files.actions.quickfix,
          ["<c-x>"] = files.actions.toggle_hidden,
          ["<c-h>"] = actions.hide,
        },
      })

      microscope.register(files.finders)
      microscope.register(buffers.finders)
      microscope.register(code.finders)
      microscope.register(git.finders)
      microscope.register(example.finders)
    end,
    keys = {
      { "<leader>cd", ":Microscope code_definitions<cr>", desc = "definitions", silent = true },
      { "<leader>ci", ":Microscope code_implementations<cr>", desc = "implementations", silent = true },
      { "<leader>cr", ":Microscope code_references<cr>", desc = "references", silent = true },
      { "<leader>ct", ":Microscope code_type_definition<cr>", desc = "typedefs", silent = true },
      { "<leader>fb", ":Microscope buffer_grep<cr>", desc = "buffer text", silent = true },
      { "<leader>fsb", ":Microscope code_buffer_symbols<cr>", desc = "buffer symbol", silent = true },
      { "<leader>fsw", ":Microscope code_workspace_symbols<cr>", desc = "workspace symbol", silent = true },
      { "<leader>fw", ":Microscope workspace_grep<cr>", desc = "workspace text", silent = true },
      { "<leader>ob", ":Microscope buffer<cr>", desc = "buffer", silent = true },
      { "<leader>of", ":Microscope file<cr>", desc = "file", silent = true },
      { "<c-h>", ":MicroscopeResume<cr>", desc = "resume finder", silent = true },
    },
  },
  {
    "folke/flash.nvim",
    config = true,
    keys = {
      {
        "s",
        -- stylua: ignore
        function() require("flash").jump() end,
        desc = "seek",
        mode = { "n", "x" },
      },
      {
        "S",
        -- stylua: ignore
        function() require("flash").treesitter() end,
        desc = "seek",
        mode = { "n", "x" },
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      history = {
        autoSave = { enabled = false },
      },
    },
    keys = {
      {
        "<leader>fr",
        function()
          require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } })
        end,
        desc = "find and replace",
        mode = { "n", "v" },
      },
      {
        "<leader>fR",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "find and replace (workspace)",
        mode = { "n", "v" },
      },
    },
  },
}
