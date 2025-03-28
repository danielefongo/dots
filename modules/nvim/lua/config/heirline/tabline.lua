local utils = require("heirline.utils")

local TabPage = {
  provider = function(self)
    return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
  end,
  hl = function(self)
    if not self.is_active then
      return { fg = "foreground", bg = "tab_not_focused" }
    else
      return { fg = "background", bg = "tab_focused" }
    end
  end,
}

local TabPageClose = {
  provider = "%999X  %X",
  hl = { bg = "background_dark" },
}

local TabPages = {
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  { provider = "%=", hl = { bg = "background" } },
  utils.make_tablist(TabPage),
  TabPageClose,
}

return TabPages
