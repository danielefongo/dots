return {
  {
    "themercorp/themer.lua",
    event = "VeryLazy",
    opts = { colorscheme = theme.themer },
  },
  {
    "utilyre/barbecue.nvim",
    lazy = false,
    name = "barbecue",
    dependencies = { "SmiteshP/nvim-navic" },
    opts = { theme = theme.barbecue },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = theme.lualine,
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "filename", path = 1 } },
        lualine_c = { "branch" },
        lualine_x = { "diagnostics" },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "oil" },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { " %s" }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
        },
      }
    end,
  },
  {
    "danielefongo/tile.nvim",
    opts = { horizontal = 4, vertical = 2 },
    keys = {
      { "<a-c-Down>", ":lua require('tile').resize_down()<cr>", desc = "resize down" },
      { "<a-c-Left>", ":lua require('tile').resize_left()<cr>", desc = "resize left" },
      { "<a-c-Right>", ":lua require('tile').resize_right()<cr>", desc = "resize right" },
      { "<a-c-Up>", ":lua require('tile').resize_up()<cr>", desc = "resize up" },
      { "<a-s-Down>", ":lua require('tile').shift_down()<cr>", desc = "shift down" },
      { "<a-s-Left>", ":lua require('tile').shift_left()<cr>", desc = "shift left" },
      { "<a-s-Right>", ":lua require('tile').shift_right()<cr>", desc = "shift right" },
      { "<a-s-Up>", ":lua require('tile').shift_up()<cr>", desc = "shift up" },
    },
  },
  {
    "nanozuki/tabby.nvim",
    event = "BufReadPost",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      line = function(line)
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and "TabLineSel" or "TabLine"
            return {
              line.sep(" ", hl, "TabLineFill"),
              tab.name(),
              line.sep(" ", hl, "TabLineFill"),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          hl = "TabLineFill",
        }
      end,
    },
    keys = {
      { "<leader>tc", ":tabnew<cr>", desc = "new" },
      { "<leader>tw", ":tabclose<cr>", desc = "close" },
      { "<leader>tn", ":tabnext<cr>", desc = "next" },
      { "<leader>te", ":tabprevious<cr>", desc = "previous" },
      { "<leader>tN", ":tabmove +1<cr>", desc = "move right" },
      { "<leader>tE", ":tabmove -1<cr>", desc = "move left" },
    },
  },
}
