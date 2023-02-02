local ensure_packer = function()
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(fn.glob(install_path)) > 0 then
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  -- keymap
  use({ "folke/which-key.nvim", config = [[require("config.whichkey")]] })

  -- comments
  use({ "tpope/vim-commentary" })

  -- files
  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = [[require("config.neotree")]],
  })
  use({ "ibhagwan/fzf-lua", config = [[require("config.fzflua")]] })

  -- search/replace
  use({ "gabrielpoca/replacer.nvim" })

  -- theme
  use({ "themercorp/themer.lua", config = [[require("config.themer")]] })
  use({ "norcalli/nvim-colorizer.lua" })

  -- linebar
  use({
    "nvim-lualine/lualine.nvim",
    config = [[require("config.lualine")]],
  })

  -- reload
  use({ "famiu/nvim-reload", requires = { "nvim-lua/plenary.nvim" } })

  -- languages
  use({ "nvim-treesitter/nvim-treesitter", config = [[require("config.treesitter")]] })
  use({ "elixir-editors/vim-elixir" })
  use({
    "j-hui/fidget.nvim",
    requires = { "neovim/nvim-lspconfig" },
    config = [[require("config.fidget")]],
  })
  use({
    "neovim/nvim-lspconfig",
    requires = { "hrsh7th/nvim-cmp", "ray-x/lsp_signature.nvim", "lvimuser/lsp-inlayhints.nvim" },
    config = [[require("config.lspconfig")]],
  })
  use({ "lvimuser/lsp-inlayhints.nvim", config = [[require("config.inlay")]] })
  use({ "jose-elias-alvarez/null-ls.nvim", config = [[require("config.null")]] })
  use({
    "williamboman/mason.nvim",
    requires = { "williamboman/mason-lspconfig.nvim", "jay-babu/mason-null-ls.nvim" },
    config = [[require("config.mason")]],
  })
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

  if packer_bootstrap then
    require("packer").sync()
  end
end)
