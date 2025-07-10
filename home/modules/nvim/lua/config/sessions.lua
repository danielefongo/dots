return {
  {
    "olimorris/persisted.nvim",
    lazy = false,
    opts = {
      autostart = true,
      autoload = false,
      should_save = function() return not vim.tbl_contains({ "gitcommit", "gitrebase", "lazy" }, vim.bo.filetype) end,
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistedSavePre",
        callback = function() vim.o.sessionoptions = "buffers,tabpages,winsize" end,
      })
    end,
    keys = {
      { "<leader>sd", ":lua require('persisted').delete()<cr>", desc = "delete", silent = true },
      { "<leader>sl", ":lua require('persisted').load()<cr>", desc = "delete", silent = true },
    },
  },
}
