-- ~/.config/nvim/lua/keymaps.lua
-- Centralized keymaps for a clean and consistent setup

local map = vim.keymap.set

-- FILE MANAGEMENT
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Find files' })

-- gf: go to file under cursor, fall back to Telescope if not found
map('n', 'gf', function()
  local file = vim.fn.expand('<cfile>')
  if vim.fn.filereadable(file) == 1 then
    vim.cmd('edit ' .. file)
  else
    require('telescope.builtin').find_files({ default_text = file })
  end
end, { desc = 'Go to file (fuzzy fallback)' })
map('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Search text in files' })
map('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'List open buffers' })
map('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Search help' })

-- EDITING & BUFFERS
map('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit window' })
map('n', '<leader>Q', ':qa<CR>', { desc = 'Quit all' })
map('n', '<leader>r', ':e!<CR>', { desc = 'Reload current buffer' })
map('n', '<leader>R', ':checktime<CR>', { desc = 'Check all buffers for changes' })

-- LSP keymaps are set per-buffer in on_attach (init.lua)

-- LSP navigation (Telescope-powered for multi-result views)
map('n', 'gr', function() require('telescope.builtin').lsp_references() end,        { desc = 'Find references' })
map('n', 'gi', function() require('telescope.builtin').lsp_implementations() end,   { desc = 'Find implementations' })
map('n', '<leader>ds', function() require('telescope.builtin').lsp_document_symbols() end,   { desc = 'Document symbols' })
map('n', '<leader>ws', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, { desc = 'Workspace symbols' })

-- CLAUDE CODE
local claude_win = nil

map('n', '<leader>cl', function()
  if claude_win and vim.api.nvim_win_is_valid(claude_win) then
    vim.api.nvim_win_close(claude_win, false)
    claude_win = nil
  else
    vim.cmd('botright vsplit')
    vim.cmd('vertical resize 60')
    vim.cmd('terminal claude')
    vim.cmd('startinsert')
    claude_win = vim.api.nvim_get_current_win()
  end
end, { desc = 'Toggle Claude sidebar' })

map('n', '<leader>cp', function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end, { desc = 'Copy file path' })

map('n', '<leader>cL', function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.')
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local ref = path .. ':' .. line
  vim.fn.setreg('+', ref)
  vim.notify('Copied: ' .. ref)
end, { desc = 'Copy file:line' })


-- Trouble diagnostics
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>',                        { desc = 'Diagnostics (project)' })
map('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',           { desc = 'Diagnostics (buffer)' })
map('n', '<leader>xs', '<cmd>Trouble symbols toggle<CR>',                            { desc = 'Symbols' })
map('n', ']x', function() require('trouble').next({ skip_groups = true, jump = true }) end, { desc = 'Next trouble item' })
map('n', '[x', function() require('trouble').prev({ skip_groups = true, jump = true }) end, { desc = 'Prev trouble item' })

-- GIT
map('n', '<leader>gg', function()
  vim.cmd('tabnew | terminal lazygit')
  vim.cmd('startinsert')
  vim.api.nvim_create_autocmd('TermClose', {
    once = true,
    callback = function() pcall(vim.cmd, 'tabclose') end,
  })
end, { desc = 'Git: lazygit' })

map('n', '<leader>gv', ':DiffviewOpen<CR>',          { desc = 'Git: review changes / conflicts' })
map('n', '<leader>gh', ':DiffviewFileHistory %<CR>',  { desc = 'Git: file history' })
map('n', '<leader>gx', ':DiffviewClose<CR>',          { desc = 'Git: close diff view' })

