require("neo-tree").setup({
  event_handlers = {
    {
      event = "neo_tree_window_after_open",
      handler = function(_)
        vim.cmd("wincmd =")
      end,
    },
    {
      event = "neo_tree_window_after_close",
      handler = function(_)
        vim.cmd("wincmd =")
      end,
    },
  },
})
