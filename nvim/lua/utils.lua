key_opts = { noremap = true, silent = true }
set_var = vim.api.nvim_set_var
exec = vim.api.nvim_command
opt = vim.opt
fn = vim.fn

function _G.set_key(mode, keys, command)
  vim.api.nvim_set_keymap(mode, keys, command, key_opts)
end

function _G.set_buf_key(bufnr, mode, keys, command)
  vim.api.nvim_buf_set_keymap(bufnr, mode, keys, command, key_opts)
end
