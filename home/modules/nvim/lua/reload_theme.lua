local watcher = vim.loop.new_fs_poll()

local function load_theme()
  package.loaded["theme"] = nil

  local loaders = vim.loader.find("theme", { all = true })
  for _, loader in ipairs(loaders) do
    vim.loader.reset(loader.modpath)
  end

  return require("theme")
end

watcher:start(
  vim.fn.stdpath("config") .. "/lua/theme.lua",
  500,
  vim.schedule_wrap(function()
    local highlight = require("utils.highlights")
    highlight.apply_function_preserving_highlights(function()
      local theme = load_theme()

      if pcall(require, "lush") then
        local data = require("theme")
        require("lush")(data.lush())
      end

      if pcall(require, "ccc") then
        vim.cmd("Lazy reload ccc.nvim")
        vim.cmd("CccHighlighterEnable")
      end

      if pcall(require, "heirline") then require("heirline.utils").on_colorscheme(theme.heirline) end
    end, { "DevIcon" })
  end)
)

return watcher
