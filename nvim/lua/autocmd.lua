vim.api.nvim_command("autocmd VimResized * wincmd =")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "{}",
    callback = function(args)
      if vim.api.nvim_buf_get_name(args.buf) == "" then
        vim.opt_local.buftype = "nofile"
        vim.opt_local.bufhidden = "unload"
        vim.keymap.set("n", "<leader>d", "", { buffer = args.buf })
      end
    end,
})
