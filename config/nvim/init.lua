_G.dd = function(...)
  local Snacks = require("snacks")
  Snacks.debug.inspect(...)
end
_G.bt = function()
  local Snacks = require("snacks")
  Snacks.debug.backtrace()
end
vim.print = _G.dd

require("user.options")

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

require("lazy").setup("plugins")

require("plugins")

require("user.colorscheme")
require("user.commands")
require("user.treesitter")
require("user.ruby")

if not vim.g.vscode then
  require("user.gitsigns")
  require("user.lualine")
  require("user.testing")
end

require("user.keymaps")
