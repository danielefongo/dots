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

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      local persistence = require("persistence")
      persistence.setup()

      persistence.delete_current_and_stop = function()
        if persistence.current then
          os.remove(persistence.current)
        end
        persistence.stop()
      end
    end,
  },
}
