local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local function required(name)
  return function()
    require(name)
  end
end

require("lazy").setup({
  -- speed up load
  { "lewis6991/impatient.nvim" },

  -- ui
  {
    "gelguy/wilder.nvim",
    config = required("config.wilder"),
  },
  {
    "b0o/incline.nvim",
    config = required("config.incline"),
  },
  {
    "themercorp/themer.lua",
    config = required("config.themer"),
  },
  {
    "norcalli/nvim-colorizer.lua",
  },
  {
    "nvim-lualine/lualine.nvim",
    config = required("config.lualine"),
  },

  -- keymap
  {
    "folke/which-key.nvim",
    config = required("config.whichkey"),
  },

  -- comments
  { "tpope/vim-commentary" },

  -- files
  {
    "nvim-tree/nvim-tree.lua",
    config = required("config.nvimtree"),
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- search
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = required("config.telescope"),
  },

  -- replace
  { "gabrielpoca/replacer.nvim" },

  -- reload
  {
    "famiu/nvim-reload",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- languages
  {
    "windwp/nvim-autopairs",
    config = required("config.autopairs"),
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = required("config.treesitter"),
  },
  {
    "elixir-editors/vim-elixir",
  },
  {
    "j-hui/fidget.nvim",
    config = required("config.fidget"),
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "williamboman/mason.nvim",
    config = required("config.mason"),
  },
  {
    "neovim/nvim-lspconfig",
    config = required("config.lspconfig"),
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "ray-x/lsp_signature.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "mason.nvim",
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = required("config.null"),
    dependencies = { "jay-babu/mason-null-ls.nvim", "mason.nvim" },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = required("config.inlay"),
  },
  {
    "hrsh7th/nvim-cmp",
    config = required("config.nvimcmp"),
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/vim-vsnip",
    },
  },
  {
    "folke/trouble.nvim",
    config = required("config.trouble"),
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- buffers
  { "kazhala/close-buffers.nvim" },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    config = required("config.gitsigns"),
  },
  {
    "TimUntersberger/neogit",
    config = required("config.neogit"),
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- session
  {
    "rmagatti/session-lens",
    config = required("config.autosession"),
    dependencies = { "rmagatti/auto-session", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "plenary.nvim" },
  },
})
