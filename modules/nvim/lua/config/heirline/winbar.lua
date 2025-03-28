local utils = require("heirline.utils")

local function make_navic_flexible_el(count)
  return {
    provider = function(self)
      if self.display_count <= count then
        return ""
      end
      local length = self.display_count - count
      local result = self.children[length]:eval()
      if length < self.original_length and result ~= "" then
        return result .. self.ellipsis:eval()
      end
      return result
    end,
  }
end

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
  condition = function()
    return require("nvim-navic").is_available() and #(require("nvim-navic").get_data() or {}) > 0
  end,
  init = function(self)
    local data = require("nvim-navic").get_data() or {}
    self.original_length = #data
    local display_count = math.min(#data, 4)

    self.children = {}

    for length = display_count, 0, -1 do
      local shortened = {}
      for i = 1, length do
        local d = data[i]
        local child = {
          { provider = d.icon, hl = self.type_hl[d.type] },
          { provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", "") },
        }

        if i < length then
          table.insert(child, {
            provider = " > ",
            hl = { fg = "navic_separator", bg = "background_light" },
          })
        end

        table.insert(shortened, child)
      end

      self.children[length] = self:new(shortened, 1)
    end

    self.ellipsis = self:new({
      { provider = "  ", hl = { fg = "navic_separator" } },
    }, 1)

    self.display_count = display_count
  end,
  update = { "CursorMoved", "BufEnter", "BufWritePost", "VimResized", "WinResized" },
  hl = { fg = "navic_color", bg = "background_light" },
  flexible = 1,
  make_navic_flexible_el(0),
  make_navic_flexible_el(1),
  make_navic_flexible_el(2),
  make_navic_flexible_el(3),
  {
    provider = " ",
    hl = { fg = "navic_separator", bg = "background_light" },
  },
}

local FilePath = {
  init = function(self)
    self.filename = vim.fn.expand("%:t")
  end,
  update = { "BufEnter", "BufWritePost", "VimResized", "WinResized" },
  hl = { fg = "navic_file", bg = "background_light" },
  flexible = false,
  provider = function(self)
    return self.filename
  end,
}

local WinWrapper = {
  {
    provider = "",
    hl = { fg = "background_light" },
  },
  FilePath,
  {
    condition = function()
      return #(require("nvim-navic").get_data() or {}) > 0
    end,
    provider = " > ",
    hl = { fg = "navic_separator", bg = "background_light" },
  },
  Navic,
  {
    provider = "",
    hl = { fg = "background_light" },
  },
}

return WinWrapper
