---@diagnostic disable: undefined-global

local colors = {
  unknown = "#ff0000",
  strong_blue = "{{ colors.blue | stronger }}",
  strong_green = "{{ colors.green | stronger }}",
  strong_red = "{{ colors.red | stronger }}",
  strong_orange = "{{ colors.orange | stronger }}",
  strong_magenta = "{{ colors.magenta | stronger }}",
  strong_yellow = "{{ colors.yellow | stronger }}",
  dark_red = "{{ colors.red | darken }}",
  very_dark_red = "{{ colors.red | darken | darken | darken }}",
  red = "{{ colors.red }}",
  light_red = "{{ colors.red | lighten }}",
  orange = "{{ colors.orange }}",
  dark_green = "{{ colors.green | darken }}",
  very_dark_green = "{{ colors.green | darken | darken | darken }}",
  green = "{{ colors.green }}",
  light_green = "{{ colors.green | lighten }}",
  dark_yellow = "{{ colors.yellow | darken }}",
  very_dark_yellow = "{{ colors.yellow | darken | darken | darken }}",
  yellow = "{{ colors.yellow }}",
  light_yellow = "{{ colors.yellow | lighten }}",
  dark_blue = "{{ colors.blue | darken }}",
  very_dark_blue = "{{ colors.blue | darken | darken | darken }}",
  blue = "{{ colors.blue }}",
  light_blue = "{{ colors.blue | lighten }}",
  dark_magenta = "{{ colors.magenta | darken }}",
  very_dark_magenta = "{{ colors.magenta | darken | darken | darken }}",
  magenta = "{{ colors.magenta }}",
  light_magenta = "{{ colors.magenta | lighten }}",
  dark_cyan = "{{ colors.cyan | darken }}",
  very_dark_cyan = "{{ colors.cyan | darken | darken | darken }}",
  cyan = "{{ colors.cyan }}",
  light_cyan = "{{ colors.cyan | lighten }}",
  background = "{{ colors.background }}",
  background_dimmed = "{{ colors.background_dimmed }}",
  background_alt1 = "{{ colors.background_alt1 }}",
  background_alt2 = "{{ colors.background_alt2 }}",
  grey1 = "{{ colors.grey1 }}",
  grey2 = "{{ colors.grey2 }}",
  grey3 = "{{ colors.grey3 }}",
  grey4 = "{{ colors.grey4 }}",
  grey5 = "{{ colors.grey5 }}",
  grey6 = "{{ colors.grey6 }}",
  grey7 = "{{ colors.grey7 }}",
  grey8 = "{{ colors.grey8 }}",
  grey9 = "{{ colors.grey9 }}",
  foreground = "{{ colors.foreground }}",
}

local syntax = {
  special = "{{ syntax.special }}",
  statement = "{{ syntax.statement }}",
  ["function"] = "{{ syntax.function }}",
  function_call = "{{ syntax.function_call }}",
  variable = "{{ syntax.variable }}",
  include = "{{ syntax.include }}",
  keyword = "{{ syntax.keyword }}",
  struct = "{{ syntax.struct }}",
  string = "{{ syntax.string }}",
  string_special = "{{ syntax.string_special }}",
  regex = "{{ syntax.regex }}",
  identifier = "{{ syntax.identifier }}",
  field = "{{ syntax.field }}",
  parameter = "{{ syntax.parameter }}",
  property = "{{ syntax.property }}",
  punctuation = "{{ syntax.punctuation }}",
  constructor = "{{ syntax.constructor }}",
  operator = "{{ syntax.operator }}",
  preproc = "{{ syntax.preproc }}",
  constant = "{{ syntax.constant }}",
  tag = "{{ syntax.tag }}",
  todo = "{{ syntax.todo }}",
  number = "{{ syntax.number }}",
  comment = "{{ syntax.comment }}",
  type = "{{ syntax.type }}",
  conditional = "{{ syntax.conditional }}",
  macro = "{{ syntax.macro }}",
  module = "{{ syntax.module }}",
}

local lush = function()
  local lush = require("lush")

  return lush(function(injected_functions)
    local sym = injected_functions.sym
    return {
      Unknown({ fg = colors.unknown }),
      NvimInternalError({ fg = colors.foreground, bg = colors.strong_red }),

      Error({ fg = colors.strong_red }),
      ErrorUnderlined({ Error, gui = "underline" }),
      Warning({ fg = colors.strong_orange }),
      WarningUnderlined({ Warning, gui = "underline" }),
      Hint({ fg = colors.strong_magenta }),
      HintUnderlined({ Hint, gui = "underline" }),
      Information({ fg = colors.strong_green }),
      InformationUnderlined({ Information, gui = "underline" }),

      NonText({ fg = colors.grey8 }),
      Text({ fg = colors.foreground }),
      Normal({ bg = colors.background, fg = colors.grey8 }),
      NormalNC({ bg = colors.background_dimmed, fg = colors.grey8 }),
      NormalFloat({ bg = colors.background_alt2, fg = colors.foreground }),
      FloatBorder({ bg = colors.background }),
      FloatShadow({ bg = colors.background }),
      FloatShadowThrough({ bg = colors.background }),
      Visual({ bg = colors.grey2 }),
      WinSeparator({ fg = colors.grey6 }),
      SignColumn({ fg = colors.grey6 }),
      ColorColumn({ SignColumn }),
      CursorColumn({ SignColumn }),
      LineNr({ fg = colors.grey2 }),
      Cursor({ bg = colors.foreground, fg = colors.background }),
      CursorLine({ bg = colors.background_alt2 }),
      CursorLineNr({ bg = colors.background, gui = "bold" }),
      File({ fg = colors.foreground }),
      Directory({ fg = colors.cyan }),
      CurSearch({ bg = colors.yellow, fg = colors.background }),
      Search({ bg = colors.cyan, fg = colors.background }),
      Folded({ bg = colors.background_alt2, fg = colors.grey6 }),
      Title({ Text, gui = "bold" }),
      Delimiter({ fg = colors.grey7 }),
      StatusLine({ bg = colors.background_alt1, fg = colors.foreground }),
      StatusLineNC({ bg = colors.background_alt1, fg = colors.grey6 }),
      Conceal({ fg = colors.grey6 }),
      MatchParen({ bg = colors.foreground, gui = "bold" }),
      WinBar({ bg = colors.background }),
      WinBarNC({ bg = colors.background_dimmed }),
      WinBarContent({ WinBar }),
      WinBarContentNC({ WinBarNC }),
      SpecialKey({ fg = colors.grey4 }),
      Pmenu({ bg = colors.background_alt2 }),
      PmenuSel({ bg = colors.grey2 }),
      PmenuThumb({ bg = colors.cyan }),
      QuickFixLine({ fg = colors.blue }),
      TabLine({ bg = colors.background }),
      TabLineSel({ bg = colors.blue, fg = colors.background }),
      TabLineFill({ bg = colors.background_alt1 }),
      TabLineNC({ bg = colors.background_dimmed }),
      ModeMsg({ fg = colors.yellow }),
      MoreMsg({ fg = colors.foreground }),
      MsgArea({ Normal }),
      MsgAreaNC({ NormalNC }),
      MsgSeparator({ StatusLine }),
      MsgSeparatorNC({ StatusLineNC }),
      ErrorMsg({ Error }),
      Question({ fg = colors.cyan }),
      WarningMsg({ Warning }),

      Added({ fg = colors.green }),
      StagedAdded({ fg = colors.very_dark_green }),
      Changed({ fg = colors.yellow }),
      StagedChanged({ fg = colors.very_dark_yellow }),
      Removed({ fg = colors.red }),
      StagedRemoved({ fg = colors.very_dark_red }),
      DiffAdd({ Added }),
      DiffChange({ Changed }),
      DiffDelete({ Removed }),
      DiffText({ Text }),

      Todo({ fg = syntax.todo, gui = "bold" }),
      Identifier({ fg = syntax.identifier }),
      Special({ fg = syntax.special }),
      Operator({ fg = syntax.operator }),
      PreProc({ fg = syntax.preproc }),
      Constant({ fg = syntax.constant }),
      sym("@constant.builtin")({ Constant }),
      Boolean({ Constant }),
      Number({ Constant }),
      Comment({ fg = syntax.comment }),
      Statement({ fg = syntax.statement }),
      Exception({ Statement }),
      Label({ Statement }),
      Keyword({ fg = syntax.keyword, gui = "italic" }),
      Conditional({ Keyword }),
      Field({ fg = syntax.field }),
      sym("@field")({ Field }),
      Function({ fg = syntax["function"] }),
      sym("@function.builtin")({ Function }),
      FunctionCall({ fg = syntax.function_call }),
      sym("@function.call")({ FunctionCall }),
      Macro({ fg = syntax.macro }),
      sym("@function.macro")({ Macro }),
      Type({ fg = syntax.type, gui = "bold" }),
      Typedef({ Type }),
      Structure({ Type }),
      Enum({ Type }),
      sym("@type.builtin")({ Type }),
      Variable({ fg = syntax.variable }),
      sym("@variable")({ Variable }),
      sym("@variable.builtin")({ Variable }),
      Parameter({ fg = syntax.parameter }),
      sym("@variable.parameter")({ Parameter }),
      sym("@variable.parameter.builtin")({ Parameter }),
      Property({ fg = syntax.property }),
      sym("@variable.member")({ Property }),
      String({ fg = syntax.string }),
      Character({ String }),
      sym("@string.regexp")({ fg = syntax.regex }),
      sym("@string.special")({ fg = syntax.string_special }),
      Punctuation({ fg = syntax.punctuation }),
      sym("@punctuation")({ Punctuation }),
      sym("@punctuation.special")({ Punctuation }),
      sym("@punctuation.bracket")({ Punctuation }),
      Constructor({ fg = syntax.constructor }),
      sym("@constructor")({ Constructor }),
      Module({ fg = syntax.module }),
      sym("@module")({ Module }),
      sym("@module.builtin")({ Module }),

      LspInlayHint({ fg = colors.grey4 }),

      DiagnosticError({ Error }),
      DiagnosticVirtualTextError({ ErrorUnderlined }),
      DiagnosticUnderlineError({ ErrorUnderlined }),
      DiagnosticWarn({ Warning }),
      DiagnosticVirtualTextWarn({ WarningUnderlined }),
      DiagnosticUnterlineWarn({ WarningUnderlined }),
      DiagnosticInfo({ Information }),
      DiagnosticVirtualTextInfo({ InformationUnderlined }),
      DiagnosticUnterlineInfo({ InformationUnderlined }),
      DiagnosticHint({ Hint }),
      DiagnosticVirtualTextHint({ HintUnderlined }),
      DiagnosticUnterlineHint({ HintUnderlined }),
      DiagnosticOk({ Information }),
      DiagnosticVirtualTextOk({ InformationUnderlined }),
      DiagnosticUnterlineOk({ InformationUnderlined }),

      GitSignsStagedAdd({ StagedAdded }),
      GitSignsStagedAddLn({}),
      GitSignsStagedAddNr({ StagedAdded }),
      GitSignsStagedAddCul({ StagedAdded }),
      GitSignsStagedChange({ StagedChanged }),
      GitSignsStagedChangeLn({ fg = colors.grey6 }),
      GitSignsStagedChangeNr({ StagedChanged }),
      GitSignsStagedChangedelete({ StagedChanged }),
      GitSignsStagedChangedeleteLn({ fg = colors.grey6 }),
      GitSignsStagedChangeCul({ StagedChanged }),
      GitSignsStagedChangedeleteCul({ StagedChanged }),
      GitSignsStagedChangedeleteNr({ StagedChanged }),
      GitSignsStagedDelete({ StagedRemoved }),
      GitSignsStagedTopdelete({ StagedRemoved }),
      GitSignsStagedDeleteNr({ StagedRemoved }),
      GitSignsStagedTopdeleteNr({ StagedRemoved }),
      GitSignsStagedDeleteCul({ StagedRemoved }),
      GitSignsStagedTopdeleteCul({ StagedRemoved }),

      FlashBackdrop({ fg = colors.grey3 }),
      FlashMatch({ fg = colors.grey4 }),
      FlashLabel({ fg = colors.grey9, gui = "bold" }),

      MultiCursorCursor({ reverse = true }),
      MultiCursorVisual({ link = "Visual" }),
      MultiCursorSign({ SignColumn }),
      MultiCursorMatchPreview({ Search }),
      MultiCursorDisabledCursor({ reverse = true }),
      MultiCursorDisabledVisual({ Visual }),
      MultiCursorDisabledSign({ SignColumn }),

      HeirlineStatusDiagnostic({ bold = true, StatusLine }),
      HeirlineStatusDiagnosticError({ fg = colors.strong_red, HeirlineStatusDiagnostic }),
      HeirlineStatusDiagnosticHint({ fg = colors.magenta, HeirlineStatusDiagnostic }),
      HeirlineStatusDiagnosticInfo({ fg = colors.green, HeirlineStatusDiagnostic }),
      HeirlineStatusDiagnosticSurround({ fg = colors.foreground, HeirlineStatusDiagnostic }),
      HeirlineStatusDiagnosticWarn({ fg = colors.orange, HeirlineStatusDiagnostic }),
      HeirlineStatusFileName({ fg = colors.foreground, StatusLine }),
      HeirlineStatusFileType({ fg = colors.cyan, StatusLine }),
      HeirlineStatusGitBranch({ fg = colors.orange, bold = true, StatusLine }),
      HeirlineStatusLsp({ fg = colors.grey6, StatusLine }),
      HeirlineStatusMode({ bold = true, StatusLine }),
      HeirlineStatusModeCommand({ fg = colors.orange, HeirlineStatusMode }),
      HeirlineStatusModeInsert({ fg = colors.blue, HeirlineStatusMode }),
      HeirlineStatusModeNormal({ fg = colors.green, HeirlineStatusMode }),
      HeirlineStatusModeTerminal({ fg = colors.red, HeirlineStatusMode }),
      HeirlineStatusModeVisual({ fg = colors.magenta, HeirlineStatusMode }),
      HeirlineStatusRuler({ fg = colors.forground, StatusLine }),

      HeirlineColumnCursorLineNr({ bold = true }),
      HeirlineColumnCursorLineNrCommand({ fg = colors.orange, HeirlineColumnCursorLineNr }),
      HeirlineColumnCursorLineNrInsert({ fg = colors.blue, HeirlineColumnCursorLineNr }),
      HeirlineColumnCursorLineNrNormal({ fg = colors.green, HeirlineColumnCursorLineNr }),
      HeirlineColumnCursorLineNrTerminal({ fg = colors.red, HeirlineColumnCursorLineNr }),
      HeirlineColumnCursorLineNrVisual({ fg = colors.magenta, HeirlineColumnCursorLineNr }),
      HeirlineColumnFold({ ColorColumn }),
      HeirlineColumnLineNr({ LineNr }),

      HeirlineTabBackground({ TabLine }),
      HeirlineTabFocused({ TabLineSel }),
      HeirlineTabNotFocused({ TabLineFill }),

      HeirlineWin({ WinBar }),
      HeirlineWinFile({ fg = colors.blue, HeirlineWin }),
      HeirlineWinFileNC({ fg = colors.grey6, WinBarNC }),
      HeirlineWinFileBackground({ HeirlineWin }),
      HeirlineWinFileBackgroundNC({ WinBarNC }),
      HeirlineWinFileSeparator({ fg = colors.red, HeirlineWin }),
      HeirlineWinFileSeparatorNC({ fg = colors.grey4, WinBarNC }),
    }
  end)
end

local group = vim.api.nvim_create_augroup("TmuxDim", { clear = true })
local function set_winhl(hl)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_set_option_value("winhighlight", hl, { win = win })
  end
end

local hl_saved
local hl_saved_colors_name

local function reset()
  hl_saved = nil
  hl_saved_colors_name = nil
end

local function save_highlights()
  local colors_name = vim.g.colors_name

  if hl_saved and hl_saved_colors_name == colors_name then return end

  local function get(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
  hl_saved = {
    TabLine = get("TabLine"),
    TabLineSel = get("TabLineSel"),
    TabLineFill = get("TabLineFill"),
    MsgArea = get("MsgArea"),
    MsgSeparator = get("MsgSeparator"),
  }
  hl_saved_colors_name = colors_name
end

local function restore_highlights()
  if not hl_saved then return end

  if hl_saved_colors_name ~= vim.g.colors_name then
    reset()
    return
  end

  for name, def in pairs(hl_saved) do
    vim.api.nvim_set_hl(0, name, def)
  end
  reset()
end

local function dim_highlights()
  local function get(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
  vim.api.nvim_set_hl(0, "TabLine", get("TabLineNC"))
  vim.api.nvim_set_hl(0, "TabLineSel", get("TabLineNC"))
  vim.api.nvim_set_hl(0, "TabLineFill", get("TabLineNC"))
  vim.api.nvim_set_hl(0, "MsgArea", get("MsgAreaNC"))
  vim.api.nvim_set_hl(0, "MsgSeparator", get("MsgSeparatorNC"))
end

vim.api.nvim_create_autocmd("FocusLost", {
  group = group,
  callback = function()
    save_highlights()
    dim_highlights()
    set_winhl(
      "Normal:NormalNC,WinBar:WinBarNC,WinBarContent:WinBarContentNC,HeirlineWinFile:WinBarNC,HeirlineWinFileBackground:WinBarNC,HeirlineWinFileSeparator:WinBarNC,StatusLine:StatusLineNC"
    )
  end,
})
vim.api.nvim_create_autocmd("FocusGained", {
  group = group,
  callback = function()
    set_winhl("")
    restore_highlights()
  end,
})

return {
  colors = colors,
  syntax = syntax,
  lush = lush,
  reset = reset,
}
