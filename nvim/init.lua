-- ~/.config/nvim/init.lua

-- Set <leader> key (optional, but common)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Define the path where lazy.nvim is installed (using expand to handle ~)
-- IMPORTANT: This path must match exactly where you cloned the lazy.nvim repository
local lazypath = vim.fn.expand("~/.config/nvim/lazy/lazy.nvim")

-- Check if lazy.nvim exists at the specified path
-- (You might not need the git clone part anymore if you manually cloned it,
-- but keeping the check is harmless)
if not vim.loop.fs_stat(lazypath) then
  -- Optional: Add a print statement or error here if lazy.nvim is not found
  -- print("Error: lazy.nvim not found at " .. lazypath)
  -- return -- Or handle the error appropriately
  -- If you want to keep the automatic cloning, use the original lazypath definition
  -- and delete the manually cloned directory.
  print("lazy.nvim not found at " .. lazypath .. ". Please ensure it's cloned there.")
  return -- Exit the script if lazy.nvim is not found
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

-- Any other final configuration that doesn't strictly belong in plugin specs
-- For example, global autocommands, keymaps that don't fit elsewhere, etc.
