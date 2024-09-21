return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
        callback = function()
          local invalid_buf = vim.tbl_contains({ "gitcommit", "gitrebase", "lazy" }, vim.bo.filetype)
          if not invalid_buf then
            require("persistence").load()
          end
        end,
        nested = true,
      })
    end,
    config = function()
      local persistence = require("persistence")
      persistence.setup()

      persistence.delete_current_and_stop = function()
        if persistence.current then
          os.remove(persistence.current())
        end
        persistence.stop()
      end
    end,
    keys = {
      { "<leader>sd", ":lua require('persistence').delete_current_and_stop()<cr>", desc = "delete", silent = true },
      { "<leader>sl", ":lua require('persistence').load()<cr>", desc = "load", silent = true },
      { "<leader>ss", ":lua require('persistence').save()<cr>", desc = "save", silent = true },
    },
  },
}
