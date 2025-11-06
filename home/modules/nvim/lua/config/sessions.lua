return {
  {
    "olimorris/persisted.nvim",
    lazy = false,
    opts = {
      autostart = true,
      autoload = false,
      should_save = function()
        if vim.tbl_contains({ "gitcommit", "gitrebase", "lazy" }, vim.bo.filetype) then return false end

        local buffers = vim.api.nvim_list_bufs()
        for _, buf in ipairs(buffers) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then return true end
        end

        return false
      end,
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
