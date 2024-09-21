return {
  {
    "rktjmp/lush.nvim",
    lazy = false,
    config = function()
      require("lush")(require("theme").lush())
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "LspAttach",
    name = "barbecue",
    dependencies = { "SmiteshP/nvim-navic", "rktjmp/lush.nvim" },
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
    event = "VeryLazy",
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        relculright = true,
        segments = {
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
          {
            sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, colwidth = 1, auto = true },
            condition = {
              function()
                return #vim.diagnostic.get(0) > 0
              end,
              function()
                return #vim.diagnostic.get(0) > 0
              end,
            },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          {
            text = { " ", builtin.signfunc, " " },
            sign = { namespace = { "gitsign*" }, maxwidth = 1, colwidth = 1, auto = false, fillchar = " " },
            condition = { true, builtin.not_empty, builtin.not_empty },
            click = "v:lua.ScSa",
          },
        },
      }
    end,
  },
  {
    "danielefongo/tile.nvim",
    opts = { horizontal = 4, vertical = 2 },
    keys = {
      { "<a-c-Down>", ":lua require('tile').resize_down()<cr>", desc = "resize down", silent = true },
      { "<a-c-Left>", ":lua require('tile').resize_left()<cr>", desc = "resize left", silent = true },
      { "<a-c-Right>", ":lua require('tile').resize_right()<cr>", desc = "resize right", silent = true },
      { "<a-c-Up>", ":lua require('tile').resize_up()<cr>", desc = "resize up", silent = true },
      { "<a-s-Down>", ":lua require('tile').shift_down()<cr>", desc = "shift down", silent = true },
      { "<a-s-Left>", ":lua require('tile').shift_left()<cr>", desc = "shift left", silent = true },
      { "<a-s-Right>", ":lua require('tile').shift_right()<cr>", desc = "shift right", silent = true },
      { "<a-s-Up>", ":lua require('tile').shift_up()<cr>", desc = "shift up", silent = true },
    },
  },
  {
    "nanozuki/tabby.nvim",
    event = { "TabEnter", "TabLeave" },
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
      { "<leader>tc", ":tabnew<cr>", desc = "new", silent = true },
      { "<leader>tw", ":tabclose<cr>", desc = "close", silent = true },
      { "<leader>tn", ":tabnext<cr>", desc = "next", silent = true },
      { "<leader>te", ":tabprevious<cr>", desc = "previous", silent = true },
      { "<leader>tN", ":tabmove +1<cr>", desc = "move right", silent = true },
      { "<leader>tE", ":tabmove -1<cr>", desc = "move left", silent = true },
    },
  },
}
