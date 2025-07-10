return {
  {
    "rktjmp/lush.nvim",
    lazy = false,
    config = function() require("lush")(require("theme").lush()) end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    opts = {
      provider_selector = function() return { "treesitter", "indent" } end,
    },
    keys = {
      { "<c-f>", "za", desc = "toggle fold", silent = true },
    },
  },
  {
    "SmiteshP/nvim-navic",
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Navic Attacher",
        group = vim.api.nvim_create_augroup("NvimAttach", {}),
        callback = function(a)
          local client = vim.lsp.get_client_by_id(a.data.client_id)
          if not client then return end
          if client.server_capabilities["documentSymbolProvider"] then require("nvim-navic").attach(client, a.buf) end
        end,
      })
    end,
  },
  {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "kevinhwang91/nvim-ufo",
    },
    config = function()
      require("heirline").setup({
        winbar = require("config.heirline.winbar"),
        tabline = require("config.heirline.tabline"),
        statuscolumn = require("config.heirline.statuscolumn"),
        statusline = require("config.heirline.statusline"),
        opts = {
          disable_winbar_cb = function(args)
            return require("heirline.conditions").buffer_matches({
              buftype = { "nofile", "prompt", "help", "quickfix" },
              filetype = { "^git.*", "Neogit.*", "Trouble", "oil" },
            }, args.buf) or args.file == ""
          end,
        },
      })
      require("heirline").load_colors(theme.heirline)
    end,
    init = function() vim.opt.laststatus = 3 end,
    keys = {
      { "<leader>tc", ":tabnew<cr>", desc = "new", silent = true },
      { "<leader>tq", ":tabclose<cr>", desc = "close", silent = true },
      { "<leader>t.", ":tabnext<cr>", desc = "next", silent = true },
      { "<leader>t,", ":tabprevious<cr>", desc = "previous", silent = true },
      { "<leader>t>", ":tabmove +1<cr>", desc = "move right", silent = true },
      { "<leader>t<", ":tabmove -1<cr>", desc = "move left", silent = true },
    },
  },
}
