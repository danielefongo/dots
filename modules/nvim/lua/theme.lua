local colors = {
  strong_blue = "{{ colors.blue | stronger }}",
  strong_green = "{{ colors.green | stronger }}",
  strong_red = "{{ colors.red | stronger }}",
  strong_yellow = "{{ colors.yellow | stronger }}",
  dark_red = "{{ colors.red | darken }}",
  red = "{{ colors.red }}",
  light_red = "{{ colors.red | lighten }}",
  dark_green = "{{ colors.green | darken }}",
  green = "{{ colors.green }}",
  light_green = "{{ colors.green | lighten }}",
  dark_yellow = "{{ colors.yellow | darken }}",
  yellow = "{{ colors.yellow }}",
  light_yellow = "{{ colors.yellow | lighten }}",
  dark_blue = "{{ colors.blue | darken }}",
  blue = "{{ colors.blue }}",
  light_blue = "{{ colors.blue | lighten }}",
  dark_magenta = "{{ colors.magenta | darken }}",
  magenta = "{{ colors.magenta }}",
  light_magenta = "{{ colors.magenta | lighten }}",
  dark_cyan = "{{ colors.cyan | darken }}",
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

local syntax = {
  statement = "{{ syntax.statement }}",
  ["function"] = "{{ syntax.function }}",
  variable = "{{ syntax.variable }}",
  include = "{{ syntax.include }}",
  keyword = "{{ syntax.keyword }}",
  struct = "{{ syntax.struct }}",
  string = "{{ syntax.string }}",
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
  todo_fg = "{{ syntax.todo }}",
  todo_bg = "{{ colors.grey1 }}",
  number = "{{ syntax.number }}",
  comment = "{{ syntax.comment }}",
  type = "{{ syntax.type }}",
  conditional = "{{ syntax.conditional }}",
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
    error = "{{ theme.error }}",
    warn = "{{ theme.warn }}",
    info = "{{ theme.info }}",
    hint = "{{ theme.hint }}",
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
      LspInlayHint = { fg = colors.grey5 },
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
      microscope = {
        MicroscopeMatch = { fg = colors.blue },
        MicroscopeColor1 = { fg = colors.red },
        MicroscopeColor2 = { fg = colors.green },
      },
      git_signs = {
        GitSignsAdd = { fg = colors.green },
        GitSignsChange = { fg = colors.yellow },
        GitSignsChangedelete = { fg = colors.yellow },
        GitSignsDelete = { fg = colors.red },
        GitSignsTopdelete = { fg = colors.red },
      },
      tabby = {
        TabLine = { bg = colors.background },
        TabLineSel = { bg = colors.blue, fg = colors.background },
        TabLineFill = { bg = colors.background_alt1 },
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

local barbecue = {
  normal = { fg = colors.grey8, bg = colors.background_alt2 },

  ellipsis = { fg = colors.grey4 },
  separator = { fg = colors.red },
  modified = { fg = colors.orange },

  dirname = { fg = colors.blue, bold = true },
  basename = { fg = colors.grey8, bold = true },
  context = { fg = colors.grey6 },

  context_file = { fg = colors.magenta },
  context_module = { fg = colors.magenta },
  context_namespace = { fg = colors.magenta },
  context_package = { fg = colors.magenta },
  context_class = { fg = colors.magenta },
  context_method = { fg = colors.magenta },
  context_property = { fg = colors.magenta },
  context_field = { fg = colors.magenta },
  context_constructor = { fg = colors.magenta },
  context_enum = { fg = colors.magenta },
  context_interface = { fg = colors.magenta },
  context_function = { fg = colors.magenta },
  context_variable = { fg = colors.magenta },
  context_constant = { fg = colors.magenta },
  context_string = { fg = colors.magenta },
  context_number = { fg = colors.magenta },
  context_boolean = { fg = colors.magenta },
  context_array = { fg = colors.magenta },
  context_object = { fg = colors.magenta },
  context_key = { fg = colors.magenta },
  context_null = { fg = colors.magenta },
  context_enum_member = { fg = colors.magenta },
  context_struct = { fg = colors.magenta },
  context_event = { fg = colors.magenta },
  context_operator = { fg = colors.magenta },
  context_type_parameter = { fg = colors.magenta },
}

return {
  themer = themer,
  lualine = lualine,
  barbecue = barbecue,
}
