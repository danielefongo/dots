vim.api.nvim_command("autocmd VimResized * wincmd =")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

local watcher = vim.loop.new_fs_poll()

watcher:start(vim.fn.stdpath("config") .. "/lua/theme.lua", 500, function()
  package.loaded["theme"] = nil
  local theme = require("theme")

  if pcall(require, "themer") then
    vim.schedule(function()
      require("themer.modules.core")(theme.themer)
    end)
  end

  if pcall(require, "lualine") then
    vim.schedule(function()
      require("lualine.highlight").create_highlight_groups(theme.lualine)
    end)
  end
end)

return watcher
