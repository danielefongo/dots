_G.opt = vim.opt
_G.fn = vim.fn
_G.api = vim.api

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

function _G.lgroup(lhs, group) return { lhs = "<leader>" .. lhs, group = group } end
function _G.key(lhs, rhs, desc, modes, opts)
  opts = opts or {}
  opts.desc = desc
  opts.mode = modes or { "n" }
  opts.noremap = opts.remap ~= true
  opts.silent = opts.silent ~= false
  return vim.tbl_extend("force", { lhs, rhs }, opts)
end
function _G.lkey(lhs, rhs, desc, modes) return key("<leader>" .. lhs, rhs, desc, modes) end
