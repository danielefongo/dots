opt = vim.opt
fn = vim.fn
api = vim.api

function _G.close_win()
  return pcall(function()
    return api.nvim_win_close(0, false)
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

function _G.scratch()
  local buf = api.nvim_create_buf(false, true)

  api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
  api.nvim_set_option_value("swapfile", false, { buf = buf })
  api.nvim_set_current_buf(buf)

  local filetype = vim.fn.input("Filetype (optional): ")
  if filetype ~= "" then
    api.nvim_set_option_value("filetype", filetype, { buf = buf })
  end
end
