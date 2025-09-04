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
      lkey("sd", function() require("persisted").delete() end, "delete"),
      lkey("sl", function() require("persisted").load() end, "load"),
    },
  },
}
