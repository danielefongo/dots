vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
  callback = function()
    if vim.bo.filetype ~= "gitcommit" then
      require("persistence").load()
    end
  end,
  nested = true,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("disable_session_persistence", { clear = true }),
  pattern = { "gitcommit" },
  callback = function()
    require("persistence").stop()
  end,
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
