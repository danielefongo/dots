vim.api.nvim_command('autocmd VimResized * wincmd =')
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})
