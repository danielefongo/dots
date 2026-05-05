local function make_navic_flexible_el(count)
  return {
    provider = function(self)
      if self.display_count <= count then return "" end

      local length = self.display_count - count
      local result = self.children[length]:eval()

      return length < self.original_length and result ~= "" and (result .. self.ellipsis:eval()) or result
    end,
  }
end

local function get_hl(hl_name)
  local is_active = vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or 0)
  local separator_hl = is_active and hl_name or hl_name .. "NC"
end

local Space = { provider = " " }

local Navic = {
  static = {
    type_hl = {
      File = "Directory",
      Module = "@include",
      Namespace = "@namespace",
      Package = "@include",
      Class = "@structure",
      Method = "@method",
      Property = "@property",
      Field = "@field",
      Constructor = "@constructor",
      Enum = "@field",
      Interface = "@type",
      Function = "@function",
      Variable = "@variable",
      Constant = "@constant",
      String = "@string",
      Number = "@number",
      Boolean = "@boolean",
      Array = "@field",
      Object = "@type",
      Key = "@keyword",
      Null = "@comment",
      EnumMember = "@field",
      Struct = "@structure",
      Event = "@keyword",
      Operator = "@operator",
      TypeParameter = "@type",
    },
    last_length = 0, -- Store the last known navic data length
  },
  condition = function() return require("nvim-navic").is_available() and #(require("nvim-navic").get_data() or {}) > 0 end,
  init = function(self)
    local data = require("nvim-navic").get_data() or {}
    self.original_length = #data
    local display_count = math.min(#data, 4)

    self.children = {}

    local separator_hl = get_hl("HeirlineWinFileSeparator")

    for length = display_count, 0, -1 do
      local shortened = {}
      for i = 1, length do
        local d = data[i]
        local child = {
          { provider = d.icon, hl = self.type_hl[d.type] },
          { provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", "") },
        }

        if i < length then table.insert(child, {
          provider = " > ",
          hl = separator_hl,
        }) end

        table.insert(shortened, child)
      end

      self.children[length] = self:new(shortened, 1)
    end

    self.ellipsis = self:new({
      { provider = "  ", hl = separator_hl },
    }, 1)

    self.display_count = display_count
  end,

  flexible = 1,
  make_navic_flexible_el(0),
  make_navic_flexible_el(1),
  make_navic_flexible_el(2),
  make_navic_flexible_el(3),
  {
    provider = " ",
    hl = get_hl("HeirlineWinFileSeparator"),
  },
}

local FilePath = {
  init = function(self) self.filename = vim.fn.expand("%:t") end,
  hl = get_hl("HeirlineWinFile"),
  flexible = false,
  provider = function(self) return self.filename end,
}

local WinWrapper = {
  hl = get_hl("HeirlineWinFileBackground"),
  update = {
    "BufEnter",
    "BufWritePost",
    "CursorMoved",
    "FocusGained",
    "FocusLost",
    "VimResized",
    "WinEnter",
    "WinLeave",
    "WinResized",
  },
  Space,
  FilePath,
  {
    condition = function() return #(require("nvim-navic").get_data() or {}) > 0 end,
    provider = " > ",
    hl = get_hl("HeirlineWinFileSeparator"),
  },
  Navic,
  Space,
}

return WinWrapper
