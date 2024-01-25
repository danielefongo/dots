-- vim:ft=lua

local colors = {
  strong_blue = "{{ colors.strong_blue }}",
  strong_green = "{{ colors.strong_green }}",
  strong_red = "{{ colors.strong_red }}",
  strong_yellow = "{{ colors.strong_yellow }}",
  dark_red = "{{ colors.dark_red }}",
  red = "{{ colors.red }}",
  light_red = "{{ colors.light_red }}",
  dark_green = "{{ colors.dark_green }}",
  green = "{{ colors.green }}",
  light_green = "{{ colors.light_green }}",
  dark_yellow = "{{ colors.dark_yellow }}",
  yellow = "{{ colors.yellow }}",
  light_yellow = "{{ colors.light_yellow }}",
  dark_blue = "{{ colors.dark_blue }}",
  blue = "{{ colors.blue }}",
  light_blue = "{{ colors.light_blue }}",
  dark_magenta = "{{ colors.dark_magenta }}",
  magenta = "{{ colors.magenta }}",
  light_magenta = "{{ colors.light_magenta }}",
  dark_cyan = "{{ colors.dark_cyan }}",
  cyan = "{{ colors.cyan }}",
  light_cyan = "{{ colors.light_cyan }}",
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

local syntax = {
  statement = "{{ colors.orange }}",
  ["function"] = "{{ colors.blue }}",
  variable = "{{ colors.foreground }}",
  include = "{{ colors.red }}",
  keyword = "{{ colors.red }}",
  struct = "{{ colors.red }}",
  string = "{{ colors.green }}",
  identifier = "{{ colors.blue }}",
  field = "{{ colors.cyan }}",
  parameter = "{{ colors.magenta }}",
  property = "{{ colors.cyan }}",
  punctuation = "{{ colors.foreground }}",
  constructor = "{{ colors.cyan }}",
  operator = "{{ colors.grey8 }}",
  preproc = "{{ colors.blue }}",
  constant = "{{ colors.orange }}",
  tag = "{{ colors.red }}",
  todo_fg = "{{ colors.cyan }}",
  todo_bg = "{{ colors.grey1 }}",
  number = "{{ colors.orange }}",
  comment = "{{ colors.grey4 }}",
  type = "{{ colors.yellow }}",
  conditional = "{{ colors.red }}",
}

local themer = {
  red = colors.dark_red,
  yellow = colors.yellow,
  orange = colors.dark_yellow,
  magenta = colors.magenta,
  blue = colors.blue,
  green = colors.green,
  cyan = colors.cyan,

  directory = colors.blue,
  fg = colors.foreground,
  diff = {
    add = colors.dark_green,
    remove = colors.dark_red,
    text = colors.dark_blue,
    change = colors.dark_yellow,
  },
  accent = colors.cyan,
  search_result = { fg = colors.background_alt1, bg = colors.blue, telescope = colors.blue },
  match = colors.grey9,
  dimmed = { bg = colors.grey4, fg = colors.grey4 },
  bg = {
    base = colors.background,
    alt = colors.background_alt2,
    selected = colors.grey2,
  },
  border = colors.foreground,
  syntax = syntax,
  built_in = syntax,
  diagnostic = {
    error = colors.strong_red,
    warn = colors.strong_yellow,
    info = colors.strong_green,
    hint = colors.magenta,
  },
  inc_search = { fg = colors.background_alt1, bg = colors.blue },
  uri = colors.dark_yellow,
  pum = {
    fg = colors.grey9,
    bg = colors.background_alt1,
    sbar = colors.background_alt2,
    thumb = colors.blue,
    sel = { bg = colors.grey2, fg = colors.foreground },
  },
  heading = {
    h1 = colors.blue,
    h2 = colors.blue,
  },
  remaps = {
    base = {
      FoldColumn = { fg = colors.grey4, bg = colors.background },
      Folded = { bg = colors.background_alt2 },
      WinSeparator = { fg = colors.grey2, bg = colors.background },
      DiffAdd = { fg = colors.dark_green, bg = colors.background },
      DiffChange = { fg = colors.dark_yellow, bg = colors.background },
      DiffDelete = { fg = colors.dark_red, bg = colors.background },
      ["@lsp.type.class"] = { fg = syntax.type },
      ["@lsp.type.decorator"] = { fg = syntax["function"] },
      ["@lsp.type.enum"] = { fg = syntax.type },
      ["@lsp.type.enumMember"] = { fg = syntax.constant },
      ["@lsp.type.function"] = { fg = syntax["function"] },
      ["@lsp.type.interface"] = { fg = syntax.type },
      ["@lsp.type.macro"] = { fg = syntax["function"] },
      ["@lsp.type.method"] = { fg = syntax["function"] },
      ["@lsp.type.namespace"] = { fg = syntax.identifier },
      ["@lsp.type.parameter"] = { fg = syntax.parameter },
      ["@lsp.type.property"] = { fg = syntax.property },
      ["@lsp.type.struct"] = { fg = syntax.type },
      ["@lsp.type.type"] = { fg = syntax.type },
      ["@lsp.type.typeParamater"] = { fg = syntax.type },
      ["@lsp.type.variable"] = { fg = syntax.variable },
    },
    plugins = {
      nvim_tree = {
        NVimTreeNormal = { fg = colors.foreground, bg = colors.background },
        NvimTreeGitDeleted = { fg = colors.red },
        NvimTreeGitDirty = { fg = colors.yellow },
        NvimTreeGitStaged = { fg = colors.green },
        NvimTreeGitMerge = { fg = colors.yellow },
        NvimTreeGitNew = { fg = colors.red },
        NvimTreeGitRenamed = { fg = colors.foreground },
        NvimTreeSpecialFile = { fg = colors.foreground },
        NvimTreeImageFile = { fg = colors.foreground },
        NvimTreeOpenedFile = { fg = colors.foreground },
        NvimTreeModifiedFile = { fg = colors.foreground },
        NvimTreeIndentMarker = { fg = colors.foreground },
        NvimTreeSymlink = { fg = colors.foreground },
        NvimTreeExecFile = { fg = colors.foreground },
      },
      microscope = {
        MicroscopeMatch = { fg = colors.blue },
        MicroscopeColor1 = { fg = colors.red },
        MicroscopeColor2 = { fg = colors.green },
      },
    },
  },
}

local lualine = {
  normal = {
    a = { fg = colors.background, bg = colors.green, gui = "bold" },
    b = { fg = colors.foreground, bg = colors.grey3 },
    c = { fg = colors.foreground, bg = colors.background_alt2 },
  },
  command = { a = { fg = colors.background, bg = colors.yellow, gui = "bold" } },
  insert = { a = { fg = colors.background, bg = colors.blue, gui = "bold" } },
  visual = { a = { fg = colors.background, bg = colors.magenta, gui = "bold" } },
  terminal = { a = { fg = colors.background, bg = colors.cyan, gui = "bold" } },
  replace = { a = { fg = colors.background, bg = colors.red, gui = "bold" } },
}

return {
  themer = themer,
  lualine = lualine,
}
