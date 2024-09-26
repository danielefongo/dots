return {
  {
    "olimorris/persisted.nvim",
    lazy = false,
    opts = {
      autostart = true,
      autoload = true,
      should_save = function()
        return not vim.tbl_contains({ "gitcommit", "gitrebase", "lazy" }, vim.bo.filetype)
      end,
    },
    keys = {
      { "<leader>sd", ":lua require('persisted').delete()<cr>", desc = "delete", silent = true },
      { "<leader>sl", ":lua require('persisted').load()<cr>", desc = "delete", silent = true },
    },
  },
}
