opt = vim.opt
fn = vim.fn
api = vim.api

local highlights = require("utils.highlights")

function _G.close_win()
  return pcall(function() return api.nvim_win_close(0, false) end) or vim.cmd(":q")
end

function _G.scratch()
  local buf = api.nvim_create_buf(false, true)

  api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
  api.nvim_set_option_value("swapfile", false, { buf = buf })
  api.nvim_set_current_buf(buf)

  local filetype = vim.fn.input("Filetype (optional): ")
  if filetype ~= "" then api.nvim_set_option_value("filetype", filetype, { buf = buf }) end
end

function _G.missing_hls()
  local missing = highlights.get_missing_highlights({
    "Redraw",
    "DevIcon",
  })
  vim.fn.setreg("z", table.concat(missing, "\n"))
end
