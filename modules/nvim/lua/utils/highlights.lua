local function get_final_highlight(name)
  local function get_highlight(name)
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    if hl.link then
      return get_highlight(hl.link)
    end
    return hl
  end

  local function rgb_to_hex(rgb)
    return string.format("#%06x", rgb)
  end

  local final_hl = get_highlight(name)
  local result = {
    fg = final_hl.foreground and rgb_to_hex(final_hl.foreground) or "none",
    bg = final_hl.background and rgb_to_hex(final_hl.background) or "none",
    style = final_hl.style or "none",
  }

  return result
end

local function filter_invalid_highlight(name, colors)
  local final_colors = get_final_highlight(name)
  local valid = true

  if final_colors.fg ~= "none" and not vim.tbl_contains(colors, final_colors.fg) then
    valid = false
  end

  if final_colors.bg ~= "none" and not vim.tbl_contains(colors, final_colors.bg) then
    valid = false
  end

  return not valid
end

local function parse_input(input, filters)
  local result = {}
  for line in input:gmatch("[^\n]+") do
    local skip = false
    for _, pattern in ipairs(filters) do
      if line:find(pattern) then
        skip = true
        break
      end
    end

    if not skip then
      local name, rest = line:match("^(%S+)%s+xxx%s+(.+)$")
      if name and rest then
        local entry = { name = name }
        if rest:find("links to") then
          local link = rest:match("links to (%S+)")
          entry.link = link
        else
          local data = {}
          for key, value in rest:gmatch("(%w+)=([^%s]+)") do
            if key == "guifg" then
              data["fg"] = value
            elseif key == "guibg" then
              data["bg"] = value
            elseif key == "gui" then
              data["gui"] = value
            end
          end
          entry.data = data
        end
        table.insert(result, entry)
      end
    end
  end
  return result
end

local function format_entry(entry)
  local name = entry.name
  if name:sub(1, 1) == "@" then
    name = 'sym("' .. name .. '")'
  end

  if entry.link then
    local link = entry.link
    if link:sub(1, 1) == "@" then
      link = 'sym("' .. link .. '")'
    end
    return string.format("%s({ %s }),", name, link)
  else
    local data_parts = {}
    for k, v in pairs(entry.data) do
      table.insert(data_parts, string.format('%s = "%s"', k, v))
    end
    local data_str = table.concat(data_parts, ", ")
    return string.format("%s({ %s }),", name, data_str)
  end
end

local function get_missing_highlights(filter_out)
  vim.cmd("Lazy load all")

  local theme = require("theme")
  local colors = vim.deepcopy(theme.colors)
  vim.list_extend(colors, theme.syntax)
  local hls = vim.fn.execute("highlight")
  local entries = parse_input(hls, filter_out)

  local result = {}
  for _, entry in ipairs(entries) do
    if filter_invalid_highlight(entry.name, colors) then
      table.insert(result, format_entry(entry))
    end
  end

  return result
end

local function apply_function_preserving_highlights(fun, matches)
  vim.cmd("Lazy load all")

  local hls = parse_input(vim.fn.execute("highlight"), {})

  hls = vim.tbl_filter(function(entry)
    return #vim.tbl_filter(function(match)
      return entry.name:find(match)
    end, matches) > 0
  end, hls)

  fun()

  for _, hl in ipairs(hls) do
    local command = ""
    if hl.data.fg then
      command = command .. " guifg=" .. hl.data.fg
    end
    if hl.data.bg then
      command = command .. " guibg=" .. hl.data.bg
    end
    vim.cmd("hi " .. hl.name .. command)
  end
end

return {
  get_missing_highlights = get_missing_highlights,
  apply_function_preserving_highlights = apply_function_preserving_highlights,
}
