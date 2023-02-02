require("fzf-lua").setup({
  keymap = {
    builtin = {
      ["<C-h>"] = "toggle-help",
      ["<C-f>"] = "toggle-fullscreen",
      ["<C-w>"] = "toggle-preview-wrap",
      ["<C-p>"] = "toggle-preview",
      ["<A-j>"] = "preview-page-down",
      ["<A-k>"] = "preview-page-up",
      ["<A-r>"] = "preview-page-reset",
    },
  },
})
