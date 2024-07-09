return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      local persistence = require("persistence")
      persistence.setup()

      persistence.delete_current_and_stop = function()
        if persistence.current then
          os.remove(persistence.current)
        end
        persistence.stop()
      end
    end,
  },
}
