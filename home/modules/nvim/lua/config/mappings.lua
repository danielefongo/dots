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
      lgroup("a", "ai"),

      lgroup("b", "buffer"),

      lgroup("c", "code"),
      lgroup("cc", "colors"),
      lgroup("cp", "package"),

      lgroup("d", "diagnostic"),

      lgroup("f", "find"),
      lgroup("fs", "symbol"),

      lgroup("g", "git"),

      lgroup("l", "lazy"),
      lkey("lp", function() require("lazy").profile() end, "profile"),

      lgroup("o", "open"),
      lkey("os", function() scratch() end, "scratch"),

      lgroup("m", "multi"),

      lgroup("s", "seek"),

      lgroup("t", "tab"),

      lgroup("v", "vim"),
      lgroup("vs", "session"),
      lkey("vq", function() vim.cmd("qa") end, "quit"),

      lkey("w", "<c-w>", "window"),

      -- others
      {
        key("<a-q>", function() close_win() end, "close buffer", { "n", "v" }),
        key("<c-up>", "<c-y>", "scroll up", { "n", "v" }),
        key("<c-down>", "<c-e>", "scroll down", { "n", "v" }),
        key(">", ">gv", "indent right", { "n", "v" }),
        key("<", "<gv", "indent left", { "n", "v" }),

        key(";", "gcc", "comment", { "n" }, { remap = true }),
        key(";", "gc", "comment", { "v" }, { remap = true }),
      },
    },
  },
}
