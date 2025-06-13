---@diagnostic disable: undefined-global

local colors = {
  unknown = "{{ colors.unknown }}",
  strong_blue = "{{ colors.blue | stronger }}",
  strong_green = "{{ colors.green | stronger }}",
  strong_red = "{{ colors.red | stronger }}",
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

-- stylua: ignore
local syntax = vim.fn.json_decode('{{ syntax | tojson | safe }}')

local lush = function()
  local lush = require("lush")
  local table_insert = table.insert
  local pairs = pairs

  return lush(function(injected_functions)
    local sym = injected_functions.sym
    local values = {
      Unknown({ fg = colors.unknown }),
      NvimInternalError({ fg = colors.foreground, bg = colors.strong_red }),

      Error({ fg = colors.strong_red }),
      Warning({ fg = colors.orange }),
      Hint({ fg = colors.magenta }),
      Information({ fg = colors.green }),

      NonText({ fg = colors.grey8 }),
      Text({ fg = colors.foreground }),
      Normal({ bg = colors.background, fg = colors.foreground }),
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
      CursorLine({ bg = colors.grey1 }),
      CursorLineNr({ bg = colors.background, gui = "bold" }),
      File({ fg = colors.foreground }),
      Directory({ fg = colors.cyan }),
      CurSearch({ bg = colors.yellow, fg = colors.background }),
      Search({ bg = colors.cyan, fg = colors.background }),
      Folded({ bg = colors.background_alt2, fg = colors.grey6 }),
      Title({ Text, gui = "bold" }),
      Delimiter({ fg = colors.grey7 }),
      StatusLine({ bg = colors.background_alt1, fg = colors.yellow }),
      StatusLineNC({ bg = colors.background_alt2, fg = colors.grey6 }),
      Conceal({ fg = colors.grey6 }),
      MatchParen({ bg = colors.foreground, gui = "bold" }),
      WinBar({ fg = colors.grey8 }),
      WinBarNC({ WinBar }),
      Special({ fg = colors.cyan }),
      SpecialKey({ fg = colors.grey4 }),
      Pmenu({ bg = colors.background_alt2 }),
      PmenuSel({ bg = colors.grey2 }),
      PmenuThumb({ bg = colors.cyan }),
      QuickFixLine({ fg = colors.blue }),
      TabLine({ bg = colors.background }),
      TabLineSel({ bg = colors.blue, fg = colors.background }),
      TabLineFill({ bg = colors.background_alt1 }),
      ModeMsg({ fg = colors.yellow }),
      MoreMsg({ fg = colors.foreground }),
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

      DiagnosticError({ Error }),
      DiagnosticWarn({ Warning }),
      DiagnosticInfo({ Information }),
      DiagnosticHint({ Hint }),
      DiagnosticOk({ Information }),

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

      MicroscopeMatch({ fg = colors.strong_red, gui = "bold" }),
      MicroscopeColor1({ fg = colors.grey5 }),
      MicroscopeColor2({ fg = colors.green }),
      MicroscopeColor3({ Text }),
      MicroscopeColor4({ Text }),
      MicroscopeColor5({ Text }),
      MicroscopeColor6({ Text }),

      NeogitBranch({ fg = colors.blue }),
      NeogitBranchHead({ fg = colors.blue, gui = "underline" }),
      NeogitRemote({ fg = colors.green }),
      NeogitObjectId({ fg = colors.grey4 }),
      NeogitStash({ Unknown }),
      NeogitFold({ fg = colors.foreground }),
      NeogitRebaseDone({ Unknown }),
      NeogitTagName({ fg = colors.blue }),
      NeogitStatusHEAD({ fg = colors.foreground }),
      NeogitSectionHeader({ fg = colors.dark_red, gui = "bold" }),
      NeogitSectionHeaderCount({ fg = colors.foreground }),
      NeogitChangeModified({ Changed }),
      NeogitChangeAdded({ Added }),
      NeogitChangeDeleted({ Removed }),
      NeogitChangeRenamed({ fg = colors.blue }),
      NeogitChangeUpdated({ fg = colors.blue }),
      NeogitChangeCopied({ Added }),
      NeogitChangeNewFile({ Added }),
      NeogitChangeUnmerged({ fg = colors.magenta }),
      NeogitHunkHeader({ bg = colors.grey6, fg = colors.background }),
      NeogitHunkHeaderCursor({ bg = colors.dark_red, fg = colors.background }),
      NeogitHunkHeaderHighlight({ fg = colors.background, bg = colors.light_red, gui = "bold" }),
      NeogitDiffContext({ fg = colors.grey4 }),
      NeogitDiffContextCursor({}),
      NeogitDiffContextHighlight({ fg = colors.grey4 }),
      NeogitDiffAdd({ Added }),
      NeogitDiffAddCursor({ Added }),
      NeogitDiffAddHighlight({ Added }),
      NeogitDiffDelete({ Removed }),
      NeogitDiffDeleteCursor({ Removed }),
      NeogitDiffDeleteHighlight({ Removed }),

      TodoBgHACK({ fg = colors.background, bg = colors.orange, gui = "bold" }),
      TodoFgHACK({ fg = colors.orange }),
      TodoSignHACK({ fg = colors.orange }),
      TodoBgTEST({ fg = colors.background, bg = colors.blue, gui = "bold" }),
      TodoFgTEST({ fg = colors.blue }),
      TodoSignTEST({ fg = colors.blue }),
      TodoBgTODO({ fg = colors.background, bg = colors.green, gui = "bold" }),
      TodoFgTODO({ fg = colors.green }),
      TodoSignTODO({ fg = colors.green }),
      TodoBgFIX({ fg = colors.foreground, bg = colors.strong_red, gui = "bold" }),
      TodoFgFIX({ fg = colors.strong_red }),
      TodoSignFIX({ fg = colors.strong_red }),
      TodoBgPERF({ fg = colors.background, bg = colors.blue, gui = "bold" }),
      TodoFgPERF({ fg = colors.blue }),
      TodoSignPERF({ fg = colors.blue }),
      TodoBgNOTE({ fg = colors.background, bg = colors.magenta, gui = "bold" }),
      TodoFgNOTE({ fg = colors.magenta }),
      TodoSignNOTE({ fg = colors.magenta }),
      TodoBgWARN({ fg = colors.background, bg = colors.orange, gui = "bold" }),
      TodoFgWARN({ fg = colors.orange }),
      TodoSignWARN({ fg = colors.orange }),

      FlashBackdrop({ fg = colors.grey4 }),
      FlashMatch({ fg = colors.grey4 }),
      FlashLabel({ fg = colors.red }),
    }

    for k, v in pairs(syntax) do
      table_insert(values, sym(k)({ fg = v.fg, bg = v.bg, gui = v.gui }))
    end

    return values
  end)
end

local heirline = {
  -- background
  background_dark = colors.background_alt1,
  background_light = colors.background_alt2,
  background = colors.background,
  foreground = colors.foreground,

  -- git
  git_branch = colors.orange,

  -- file
  file_path = colors.foreground,
  file_type = colors.cyan,

  -- mode
  mode_normal = colors.green,
  mode_insert = colors.cyan,
  mode_visual = colors.magenta,
  mode_command = colors.orange,
  mode_terminal = colors.red,

  -- diagnostics
  diagnostic_error = colors.strong_red,
  diagnostic_warn = colors.orange,
  diagnostic_hint = colors.magenta,
  diagnostic_info = colors.green,
  diagnostic_surround = colors.foreground,

  -- navic
  navic_separator = colors.red,
  navic_color = colors.grey7,
  navic_file = colors.blue,

  -- tabline
  tab_focused = colors.cyan,
  tab_not_focused = colors.background_alt1,

  -- statuscol
  col_number = colors.grey2,
  col_focused_number = colors.foreground,
  col_fold = colors.grey6,
}

return {
  colors = colors,
  syntax = syntax,
  lush = lush,
  heirline = heirline,
}
