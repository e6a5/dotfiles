-- ~/.config/nvim/lua/autocmds.lua

-- Register Go template filetype
vim.filetype.add({
  extension = { gotmpl = "gotmpl" },
})

-- Auto-reload files when Claude Code changes them
vim.opt.autoread = true
vim.opt.updatetime = 300

vim.api.nvim_create_autocmd({'FocusGained', 'BufEnter', 'CursorHold'}, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})

-- Show when files are reloaded
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  pattern = '*',
  callback = function()
    print("🔄 File reloaded: " .. vim.fn.expand("%:t"))
  end,
})

-- Claude terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*claude*",
  callback = function(args)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf })
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "term://*claude*",
  callback = function()
    vim.cmd("vertical resize 50")  -- Claude sidebar always 50 cols
  end,
})
