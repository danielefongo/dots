local modes = require("config.heirline.modes")

local function get_marks_for_namespace(namespace_pattern)
  local lnum = vim.v.lnum - 1
  local result = {}
  local namespaces = vim.api.nvim_get_namespaces()

  for name, id in pairs(namespaces) do
    if name:match(namespace_pattern) then
      local marks = vim.api.nvim_buf_get_extmarks(0, id, { lnum, 0 }, { lnum, -1 }, { limit = 1, details = true })
      if #marks > 0 and marks[1][2] == lnum then
        table.insert(result, {
          name = name,
          id = id,
          mark = marks[1],
          highlight = marks[1][4]["sign_hl_group"],
        })
      end
    end
  end

  return result
end

local function is_virtual_line() return vim.v.virtnum < 0 end
local function is_wrapped_line() return vim.v.virtnum > 0 end
local function not_in_fold_range() return vim.fn.foldlevel(vim.v.lnum) <= 0 end
local function not_fold_start(line) return vim.fn.foldlevel(line) <= vim.fn.foldlevel(line - 1) end
local function fold_opened(line) return vim.fn.foldclosed(line or vim.v.lnum) == -1 end

local Space = { provider = " " }

local LineNumber = {
  static = modes,
  { provider = "%=" },
  {
    provider = function()
      local lnum = tostring(vim.v.lnum)
      if is_virtual_line() then
        return string.rep(" ", #lnum)
      elseif is_wrapped_line() then
        return " " .. string.rep(" ", #lnum)
      else
        return (#lnum == 1 and "  " or " ") .. lnum
      end
    end,
    hl = function(self)
      local mode = vim.fn.mode(1):sub(1, 1)
      if vim.v.lnum == vim.fn.getcurpos()[2] then
        return { fg = self.mode_colors[mode], bold = true }
      else
        return { fg = "col_number", bold = false }
      end
    end,
  },
  { provider = " " },
}

local Fold = {
  provider = function()
    if is_wrapped_line() or is_virtual_line() then
      return ""
    elseif not_in_fold_range() or not_fold_start(vim.v.lnum) then
      return " "
    elseif fold_opened() then
      return ""
    else
      return ""
    end
  end,
  hl = { fg = "col_fold" },
}

local GitSigns = {
  init = function(self)
    self.has_sign = false
    self.highlight = nil

    local marks = get_marks_for_namespace("^gitsigns")

    if #marks > 0 then
      self.has_sign = true
      self.highlight = marks[1].highlight
    end
  end,

  provider = function(self)
    if not self.has_sign then return " " end

    local highlight = self.highlight or ""

    if highlight:match("Add") then
      return "▌"
    elseif highlight:match("Change") then
      return "▌"
    elseif highlight:match("Delete") then
      return "▄"
    elseif highlight:match("TopDelete") then
      return "▀"
    elseif highlight:match("ChangeDelete") then
      return "▌"
    else
      return "▌"
    end
  end,

  hl = function(self) return self.highlight or "StatusColumnBorder" end,
}

local DiagnosticSigns = {
  init = function(self)
    local lnum = vim.v.lnum - 1
    local diags = vim.diagnostic.get(0, { lnum = lnum })

    self.has_sign = #diags > 0
    self.severity = nil

    if self.has_sign then
      local best = math.huge
      for _, d in ipairs(diags) do
        if d.severity and d.severity < best then best = d.severity end
      end
      self.severity = best
    end
  end,

  provider = function(self)
    if not self.has_sign then return "" end
    local s = vim.diagnostic.severity
    if self.severity == s.ERROR then
      return " 󰅚"
    elseif self.severity == s.WARN then
      return " 󰀪"
    elseif self.severity == s.INFO then
      return " 󰋽"
    elseif self.severity == s.HINT then
      return " 󰌶"
    else
      return "?"
    end
  end,

  hl = function(self)
    local s = vim.diagnostic.severity
    local map = {
      [s.ERROR] = "DiagnosticError",
      [s.WARN] = "DiagnosticWarn",
      [s.INFO] = "DiagnosticInfo",
      [s.HINT] = "DiagnosticHint",
    }
    return map[self.severity] or "StatusColumnBorder"
  end,
}

return {
  Fold,
  DiagnosticSigns,
  LineNumber,
  GitSigns,
  Space,
}
