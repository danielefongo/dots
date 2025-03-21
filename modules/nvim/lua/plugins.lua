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

return function(extra_spec)
  local spec = { { import = "config" } }
  require("lazy").setup(extra_spec and vim.list_extend(spec, extra_spec) or spec, {
    defaults = { lazy = true },
    change_detection = { notify = false },
    debug = false,
    dev = { path = "~/nvim_plugins/", patterns = {}, fallback = true },
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "rplugin",
          "rrhelper",
          "shada",
          "tarPlugin",
          "tohtml",
          "tutor",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
        },
      },
    },
  })
end
