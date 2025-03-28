local conditions = require("heirline.conditions")

local Space = { provider = " " }
local Align = { provider = "%=" }

local ViMode = {
  static = {
    mode_names = {
      n = "N",
      no = "N?",
      nov = "N?",
      noV = "N?",
      ["no\22"] = "N?",
      niI = "Ni",
      niR = "Nr",
      niV = "Nv",
      nt = "Nt",
      v = "V",
      vs = "Vs",
      V = "V_",
      Vs = "Vs",
      ["\22"] = "^V",
      ["\22s"] = "^V",
      s = "S",
      S = "S_",
      ["\19"] = "^S",
      i = "I",
      ic = "Ic",
      ix = "Ix",
      R = "R",
      Rc = "Rc",
      Rx = "Rx",
      Rv = "Rv",
      Rvc = "Rv",
      Rvx = "Rv",
      c = "C",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "?",
      ["!"] = "!",
      t = "T",
    },
    mode_colors = {
      n = "mode_normal",
      i = "mode_insert",
      v = "mode_visual",
      V = "mode_visual",
      ["\22"] = "mode_visual",
      c = "mode_command",
      s = "mode_visual",
      S = "mode_visual",
      ["\19"] = "mode_visual",
      R = "mode_command",
      r = "mode_command",
      ["!"] = "mode_terminal",
      ["t"] = "mode_terminal",
    },
  },
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  flexible = false,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return { fg = self.mode_colors[mode], bg = "background_dark", bold = true }
  end,
  provider = function(self)
    return " %1(" .. self.mode_names[self.mode] .. "%)"
  end,
  Space,
}

local GitBranch = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
  end,
  hl = { fg = "git_branch", bg = "background_dark" },
  {
    provider = function(self)
      local head = self.status_dict.head
      if head:match("^INTSL") then
        head = head:match("^[^/]*")
      end
      return " " .. head
    end,
    hl = { bold = true },
  },
  Space,
}

local FileName = {
  init = function(self)
    self.relname = vim.fn.fnamemodify(self.filename, ":.")
    if self.relname == "" then
      self.relname = "[No Name]"
    end
  end,
  flexible = 2,
  {
    provider = function(self)
      return self.relname
    end,
  },
  {
    provider = function(self)
      return vim.fn.pathshorten(self.relname)
    end,
  },
  {
    provider = function(self)
      return vim.fn.fnamemodify(self.filename, ":t")
    end,
  },
}

local FileNameWrapper = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  update = { "BufEnter", "DirChanged", "BufModifiedSet", "VimResized" },
  hl = { fg = "file_path", bg = "background_dark" },
  FileName,
  { provider = "%<" },
  Space,
}

local FileType = {
  hl = { fg = "file_type", bg = "background_dark" },
  provider = function()
    return vim.bo.filetype
  end,
  Space,
}

local Diagnostics = {
  static = {
    error_icon = "󰅚 ",
    warn_icon = "󰀪 ",
    info_icon = "󰋽 ",
    hint_icon = "󰌶 ",
  },
  condition = function()
    return #vim.diagnostic.get(0) > 0
  end,
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = {
    "LspAttach",
    "LspDetach",
    "DiagnosticChanged",
    callback = vim.schedule_wrap(function(_)
      vim.cmd.redrawstatus()
    end),
  },
  hl = { bg = "background_dark" },
  { provider = "[", hl = { fg = "diagnostic_surround" } },
  {
    condition = function(self)
      return self.errors > 0
    end,
    provider = function(self)
      return string.format("%s%s", self.error_icon, self.errors)
    end,
    hl = { fg = "diagnostic_error", bold = true },
  },
  {
    condition = function(self)
      return self.warnings > 0
    end,
    provider = function(self)
      local prefix = self.errors > 0 and " " or ""
      return string.format("%s%s%s", prefix, self.warn_icon, self.warnings)
    end,
    hl = { fg = "diagnostic_warn", bold = true },
  },
  {
    condition = function(self)
      return self.info > 0
    end,
    provider = function(self)
      local prefix = (self.errors > 0 or self.warnings > 0) and " " or ""
      return string.format("%s%s%s", prefix, self.info_icon, self.info)
    end,
    hl = { fg = "diagnostic_info", bold = true },
  },
  {
    condition = function(self)
      return self.hints > 0
    end,
    provider = function(self)
      local prefix = (self.errors > 0 or self.warnings > 0 or self.info > 0) and " " or ""
      return string.format("%s%s%s", prefix, self.hint_icon, self.hints)
    end,
    hl = { fg = "diagnostic_hint", bold = true },
  },
  { provider = "]", hl = { fg = "diagnostic_surround" } },
  Space,
}

local Ruler = { provider = "%l/%L" }

return {
  Space,
  ViMode,
  FileNameWrapper,
  GitBranch,
  Align,
  Diagnostics,
  FileType,
  Ruler,
  Space,
}
