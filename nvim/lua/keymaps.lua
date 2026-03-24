-- ~/.config/nvim/lua/keymaps.lua
-- Centralized keymaps for a clean and consistent setup

local map = vim.keymap.set
local tb = require('telescope.builtin')

-- FILE MANAGEMENT
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
map('n', '<leader>ff', tb.find_files, { desc = 'Find files' })
map('n', '<leader>fg', tb.live_grep, { desc = 'Search text in files' })
map('n', '<leader>fb', tb.buffers, { desc = 'List open buffers' })
map('n', '<leader>fh', tb.help_tags, { desc = 'Search help' })

-- EDITING & BUFFERS
map('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit window' })
map('n', '<leader>Q', ':qa<CR>', { desc = 'Quit all' })
map('n', '<leader>r', ':e!<CR>', { desc = 'Reload current buffer' })
map('n', '<leader>R', ':checktime<CR>', { desc = 'Check all buffers for changes' })

-- LSP (works when an LSP client is attached)
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover info' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })

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
map('n', '<leader>gS', tb.git_status,   { desc = 'Telescope: git status' })
map('n', '<leader>gL', tb.git_commits,  { desc = 'Telescope: git log' })
map('n', '<leader>gB', tb.git_branches, { desc = 'Telescope: git branches' })
map('n', '<leader>gf', tb.git_files,    { desc = 'Telescope: git files' })
