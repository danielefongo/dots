return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
        callback = function()
          if not vim.tbl_contains({
            "gitcommit",
            "gitrebase",
          }, vim.bo.filetype) then
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
      { "<leader>sd", ":lua require('persistence').delete_current_and_stop()<cr>", desc = "delete" },
      { "<leader>sl", ":lua require('persistence').load()<cr>", desc = "load" },
      { "<leader>ss", ":lua require('persistence').save()<cr>", desc = "save" },
    },
  },
}
