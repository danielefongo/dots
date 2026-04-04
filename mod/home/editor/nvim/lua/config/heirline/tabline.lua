local utils = require("heirline.utils")

local TabPage = {
  provider = function(self) return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T" end,
  hl = function(self)
    if not self.is_active then
      return "HeirlineTabNotFocused"
    else
      return "HeirlineTabFocused"
    end
  end,
}

local TabPages = {
  condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
  utils.make_tablist(TabPage),
  { provider = "%=", hl = "HeirlineTabBackground" },
}

return TabPages
