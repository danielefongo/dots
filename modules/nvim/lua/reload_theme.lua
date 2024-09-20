local watcher = vim.loop.new_fs_poll()

local function load_theme()
  package.loaded["theme"] = nil

  local loaders = vim.loader.find("theme", { all = true })
  for _, loader in ipairs(loaders) do
    vim.loader.reset(loader.modpath)
  end

  return require("theme")
end

watcher:start(vim.fn.stdpath("config") .. "/lua/theme.lua", 500, function()
  local theme = load_theme()

  if pcall(require, "lush") then
    vim.schedule(function()
      local data = require("theme")
      require("lush")(data.lush())
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
