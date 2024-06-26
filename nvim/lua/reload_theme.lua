local watcher = vim.loop.new_fs_poll()

watcher:start(vim.fn.stdpath("config") .. "/lua/theme.lua", 500, function()
  local theme = load_theme()

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

  if pcall(require, "barbecue") then
    vim.schedule(function()
      vim.g.colors_name = nil
      require("barbecue.config").apply({ theme = theme.barbecue })
      require("barbecue.theme").load()
    end)
  end
end)

return watcher
