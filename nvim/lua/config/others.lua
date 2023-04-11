return {
  { "norcalli/nvim-colorizer.lua" },
  { "tpope/vim-commentary", cmd = "Commentary" },
  { "gabrielpoca/replacer.nvim", cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" } },
  { "windwp/nvim-autopairs", opts = {}, event = "BufReadPre" },
  { "kazhala/close-buffers.nvim", event = "VeryLazy" },
}
