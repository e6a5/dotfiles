-- ~/.config/nvim/lua/config.lua

-- This file returns a table containing plugin specifications for lazy.nvim
-- It is required by init.lua

return {
  -- Colorscheme: Loaded immediately as lazy = false
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },

  -- File explorer: Loaded immediately as lazy = false
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({})
    end,
  },
  
  -- LSP, Treesitter, DAP, and Go plugins: Loaded when a Go filetype is detected
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- Often recommended with go.nvim
      "nvim-treesitter/nvim-treesitter", -- treesitter is a dependency
      "mfussenegger/nvim-dap", -- For debugging
      "leoluz/nvim-dap-go", -- Go debugger adapter
      "neovim/nvim-lspconfig", -- go.nvim requires this even with lsp_cfg = false
    },
    config = function()
      require("go").setup({
        -- go.nvim settings (refer to its documentation for more options)
        go_fmt = "gofumpt", -- or "golines", make sure the tool is installed
        go_lint = "golangci-lint", -- requires golangci-lint to be installed and in PATH
        goimports = 'gopls',
        lsp_cfg = false, -- ✅ Let us control gopls manually
      })
    end,
    ft = {"go", 'gomod'},
    -- Command to install/update necessary Go binaries used by go.nvim
    build = ':lua require("go.install").update_all_sync()',
  },

  -- Explicit nvim-treesitter configuration for highlighting and other features
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "go", "lua", "vimdoc", "query" },
        highlight = { enable = true },
        indent = { enable = false },
      })
    end,
  },

  -- Autocompletion: Setup nvim-cmp and its sources
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source
      "hrsh7th/cmp-buffer", -- Buffer words source
      "hrsh7th/cmp-path", -- File system path source
      "saadparwaiz1/cmp_luasnip", -- Snippet source
      "L3MON4D3/LuaSnip", -- Snippet engine
      "hrsh7th/cmp-cmdline", -- Optional: Cmdline completion
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        completion = {
          completeopt = 'menu,menuone,noselect',
        },
      })

      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' },
        })
      })
    end,
    event = "VeryLazy",
  },

  -- Git signs for visual change indicators (NEW)
 {
   "tpope/vim-fugitive",
   lazy = false, -- load at startup (tiny plugin, no cost)
  },
  -- Enhanced notifications (NEW)
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
      require('notify').setup({
        stages = 'fade_in_slide_out',
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      })
    end
  },

  -- Git signs in the gutter (+/-/~)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add    = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
        },
      })
    end,
  },

  -- Auto-close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      -- Hook into nvim-cmp so confirmed completions also close pairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Other utility plugins
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  },
  {
  "hoob3rt/lualine.nvim",
  config = function()
    local function lsp_status()
      local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
      if next(buf_clients) == nil then
        return "" -- no LSP attached
      end
      local names = {}
      for _, client in pairs(buf_clients) do
        table.insert(names, client.name)
      end
      return " " .. table.concat(names, ",")
    end

    require('lualine').setup {
      options = {
        theme = 'tokyonight',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        globalstatus = true, -- one statusline across all splits
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename', lsp_status },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }
  end,
 }
}
