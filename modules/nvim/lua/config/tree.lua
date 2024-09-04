return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        columns = { "icon", "size" },
        delete_to_trash = true,
        experimental_watch_for_changes = true,
        view_options = {
          show_hidden = true,
        },
      })
    end,
    keys = {
      { "<leader>ot", ":Oil<cr>", desc = "tree" },
    },
  },
}
