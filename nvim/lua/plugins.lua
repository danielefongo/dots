local ensure_packer = function()
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(fn.glob(install_path)) > 0 then
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd("packadd packer.nvim")
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  -- speed up load
  use({ "lewis6991/impatient.nvim" })

  -- ui
  use({ "gelguy/wilder.nvim", config = [[require("config.wilder")]] })
  use({ "b0o/incline.nvim", config = [[require("config.incline")]] })
  use({ "themercorp/themer.lua", config = [[require("config.themer")]] })
  use({ "norcalli/nvim-colorizer.lua" })
  use({ "nvim-lualine/lualine.nvim", config = [[require("config.lualine")]] })

  -- keymap
  use({ "folke/which-key.nvim", config = [[require("config.whichkey")]] })

  -- comments
  use({ "tpope/vim-commentary" })

  -- files
  use({
    "nvim-tree/nvim-tree.lua",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = [[require("config.nvimtree")]],
  })
  use({ "ibhagwan/fzf-lua", config = [[require("config.fzflua")]] })

  -- search/replace
  use({ "gabrielpoca/replacer.nvim" })

  -- reload
  use({ "famiu/nvim-reload", requires = { "nvim-lua/plenary.nvim" } })

  -- languages
  use({ "windwp/nvim-autopairs", config = [[require("config.autopairs")]] })
  use({ "nvim-treesitter/nvim-treesitter", config = [[require("config.treesitter")]] })
  use({ "elixir-editors/vim-elixir" })
  use({
    "j-hui/fidget.nvim",
    requires = { "neovim/nvim-lspconfig" },
    config = [[require("config.fidget")]],
  })
  use({ "williamboman/mason.nvim", config = [[require("config.mason")]] })
  use({
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "ray-x/lsp_signature.nvim",
      "lvimuser/lsp-inlayhints.nvim",
    },
    after = { "mason.nvim" },
    config = [[require("config.lspconfig")]],
  })
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "jay-babu/mason-null-ls.nvim" },
    after = { "mason.nvim" },
    config = [[require("config.null")]],
  })
  use({ "lvimuser/lsp-inlayhints.nvim", config = [[require("config.inlay")]] })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/vim-vsnip",
    },
    config = [[require("config.nvimcmp")]],
  })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = [[require("config.trouble")]],
  })

  -- buffers
  use({ "kazhala/close-buffers.nvim" })

  -- git
  use({ "lewis6991/gitsigns.nvim", config = [[require("config.gitsigns")]] })
  use({
    "TimUntersberger/neogit",
    requires = "nvim-lua/plenary.nvim",
    config = [[require("config.neogit")]],
  })

  -- session
  use({
    "rmagatti/session-lens",
    requires = { "rmagatti/auto-session", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    after = "plenary.nvim",
    config = [[require("config.autosession")]],
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
