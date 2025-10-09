return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 100
  end,
  opts_extends = { "spec" },
  opts = {
    preset = "helix",
    spec = {
      lgroup("b", "buffer"),
      lkey("bs", function() scratch() end, "scratch"),

      lgroup("c", "code"),
      lgroup("cc", "colors"),
      lgroup("cp", "package"),

      lgroup("d", "diagnostic"),

      lgroup("f", "find"),
      lgroup("fs", "symbol"),

      lgroup("g", "git"),

      lgroup("l", "lazy"),
      lkey("lp", function() vim.cmd("Lazy profile") end, "profile"),

      lgroup("o", "open"),

      lgroup("s", "session"),

      lgroup("t", "tab"),

      lgroup("v", "vim"),
      lkey("vq", function() vim.cmd("qa") end, "quit"),

      lkey("w", "<c-w>", "window"),

      -- others
      {
        key("<a-q>", function() close_win() end, "close buffer", { "n", "v" }),
        key("<c-up>", "<c-y>", "scroll up", { "n", "v" }),
        key("<c-down>", "<c-e>", "scroll down", { "n", "v" }),
        key("<c-g>", "gg0vG$", "select all", { "n", "v" }),
        key(">", ">gv", "indent right", { "n", "v" }),
        key("<", "<gv", "indent left", { "n", "v" }),
      },
    },
  },
}
