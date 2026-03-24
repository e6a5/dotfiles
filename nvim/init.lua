
require("autocmds")


-- Set <leader> key (optional, but common)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim: auto-clone if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- Add lazy.nvim to Neovim's runtime path
vim.opt.rtp:prepend(lazypath)

-- Set some basic options early
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true -- Essential for true color themes
vim.opt.expandtab = true
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

-- Setup lazy.nvim and load your configuration from lua/config.lua
require("lazy").setup({
  spec = {
    -- This tells lazy.nvim to load all plugin specifications from the table returned by require("config")
    { import = "config" },
  },
  -- Add any other global lazy.nvim options here
  change_detection = {
    notify = false, -- Disable notification for changes in plugins
  },
  ui = { -- Optional: Configuration for the lazy.nvim UI
    -- You can add options here if you want to customize the appearance
  },
})

-- Set the colorscheme AFTER lazy.setup() has loaded the plugin
-- Ensure 'tokyonight-storm' is available from your colorscheme plugin (set with lazy=false in config.lua)
-- This line should be after the require("lazy").setup block
vim.cmd.colorscheme("tokyonight-storm")

-- Load custom keymaps
require("keymaps")

