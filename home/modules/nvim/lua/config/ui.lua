return {
  {
    "linrongbin16/lsp-progress.nvim",
    opts = {
      series_format = function(title, _, percentage, done)
        local builder = {}
        if title and title ~= "" then table.insert(builder, title) end
        if percentage then table.insert(builder, string.format("%.0f%%", percentage)) end
        return { msg = table.concat(builder, " "), done = done }
      end,
      client_format = function(_, _, series_messages)
        if #series_messages == 0 then return end
        local builder = {}
        for _, series in ipairs(series_messages) do
          if series.msg ~= "" then table.insert(builder, series.msg) end
        end
        if #builder == 0 then return nil end
        return table.concat(builder, " | ")
      end,
    },
  },
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
      key("<c-f>", "za", "toggle fold"),
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
      "linrongbin16/lsp-progress.nvim",
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
      lkey("tc", function() vim.cmd("tabnew") end, "new"),
      lkey("tq", function() vim.cmd("tabclose") end, "close"),
      lkey("t.", function() vim.cmd("tabnext") end, "next"),
      lkey("t,", function() vim.cmd("tabprevious") end, "previous"),
      lkey("t>", function() vim.cmd("tabmove +1") end, "move right"),
      lkey("t<", function() vim.cmd("tabmove -1") end, "move left"),
    },
  },
}
