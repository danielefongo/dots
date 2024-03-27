opt = vim.opt
fn = vim.fn

function _G.close_win()
  return pcall(function()
    return vim.api.nvim_win_close(0, false)
  end) or vim.cmd(":q")
end

function _G.load_theme()
  package.loaded["theme"] = nil

  local loaders = vim.loader.find("theme", { all = true })
  for _, loader in ipairs(loaders) do
    vim.loader.reset(loader.modpath)
  end

  return require("theme")
end
