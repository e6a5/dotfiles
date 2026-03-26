-- ~/.config/nvim/lua/keymaps.lua
-- Centralized keymaps for a clean and consistent setup

local map = vim.keymap.set

-- FILE MANAGEMENT
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Find files' })
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

-- CLAUDE CODE
map('n', '<leader>ct', function()
  local result = vim.fn.system('which claude 2>/dev/null')
  if result and result ~= "" then
    vim.cmd('!claude --version')
  else
    vim.notify("Claude not found in PATH", vim.log.levels.ERROR)
  end
end, { desc = 'Test Claude installation', silent = true })

-- Launch Claude Code in a fixed right sidebar
map('n', '<leader>cl', function()
  -- Open a vertical split on the right
  vim.cmd('botright vsplit')
  vim.cmd('vertical resize 50')  -- set width (adjust to your liking)
  vim.cmd('terminal claude')
  vim.cmd('startinsert')
end, { desc = 'Launch Claude Code (right sidebar)', silent = true })

-- Close sidebar if it's a Claude terminal
map('n', '<leader>cq', function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match('term://') and bufname:match('claude') then
    vim.cmd('quit')
  else
    vim.notify("Not in a Claude terminal", vim.log.levels.WARN)
  end
end, { desc = 'Close Claude sidebar', silent = true })


-- Git (Fugitive) — interactive operations
map('n', '<leader>gs', ':Git<CR>',        { desc = 'Git status (Fugitive)' })
map('n', '<leader>gb', ':Git blame<CR>',  { desc = 'Git blame' })
map('n', '<leader>gd', ':Gdiffsplit<CR>', { desc = 'Git diff current file' })
map('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git commit' })
map('n', '<leader>gp', ':Git push<CR>',   { desc = 'Git push' })

-- Telescope Git pickers — browse/search
map('n', '<leader>gS', function() require('telescope.builtin').git_status() end,   { desc = 'Telescope: git status' })
map('n', '<leader>gL', function() require('telescope.builtin').git_commits() end,  { desc = 'Telescope: git log' })
map('n', '<leader>gB', function() require('telescope.builtin').git_branches() end, { desc = 'Telescope: git branches' })
map('n', '<leader>gf', function() require('telescope.builtin').git_files() end,    { desc = 'Telescope: git files' })
