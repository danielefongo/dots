return {
  {
    "olimorris/persisted.nvim",
    event = "VeryLazy",
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
    config = function(_, opts)
      local persisted = require("persisted")

      persisted.setup(opts)

      if vim.fn.argc() == 0 then persisted.load() end
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistedSavePre",
        callback = function() vim.o.sessionoptions = "buffers,tabpages,winsize" end,
      })
    end,
    keys = {
      lkey("vsd", function() require("persisted").delete() end, "delete"),
      lkey("vsl", function() require("persisted").load() end, "load"),
      lkey("vsk", function()
        require("persisted").stop()
        vim.cmd("%bdelete")
      end, "kill"),
    },
  },
}
