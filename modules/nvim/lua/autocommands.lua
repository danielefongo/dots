vim.api.nvim_create_autocmd("VimLeavePre", {
  pattern = "*",
  callback = function()
    local windows = vim.api.nvim_list_wins()
    for _, win in ipairs(windows) do
      local buf = vim.api.nvim_win_get_buf(win)
      local is_listed = vim.api.nvim_get_option_value("buflisted", { buf = buf })
      if not is_listed then
        if #vim.api.nvim_list_wins() > 1 then vim.api.nvim_win_close(win, false) end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function() vim.api.nvim_exec2("wincmd =", { output = false }) end,
})
