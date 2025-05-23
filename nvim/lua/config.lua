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
  {
    "neovim/nvim-lspconfig",
    ft = "go", -- Attach specifically to Go filetypes
    config = function()
      require("lspconfig").gopls.setup({
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufEnter", {
            buffer = bufnr,
            callback = function()
              print("gopls attached!") -- Print a message when attached
            end,
          })
          -- You can add other keymaps or autocommands here if needed
        end,
        -- Add any specific gopls settings here if necessary
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
        on_attach = function(client, bufnr)
         vim.api.nvim_create_autocmd("BufEnter", {
                buffer = bufnr,
                callback = function()
                        print("gopls attached!") -- Print a message when attached
                end,
         })
        -- Key mappings can go here
        vim.keymap.set('i', '<C-Space>', vim.lsp.buf.completion, { buffer = bufnr, desc = 'Trigger Completion' })
        end,
        settings = {
         golang = {
          gopls = {
                analyses = {
                        unusedparams = true,
                },
                staticcheck = true,
                completion = {
                        usePlaceholders = true, -- Explicitly set this (often default)
                },
          },
         },
        },
        })
      end,
  },

  -- LSP, Treesitter, DAP, and Go plugins: Loaded when a Go filetype is detected
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- Often recommended with go.nvim
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter", -- treesitter is a dependency
      "mfussenegger/nvim-dap", -- For debugging
      "leoluz/nvim-dap-go", -- Go debugger adapter
    },
    config = function()
      require("go").setup({
        -- go.nvim settings (refer to its documentation for more options)
        go_fmt = "gofumpt", -- or "golines", make sure the tool is installed
        go_lint = "golangci-lint", -- requires golangci-lint to be installed and in PATH
        goimports = 'gopls',
        -- If you want to use gopls for formatting, set go_fmt to 'gopls'
        -- Example of potentially useful go.nvim settings:
        -- goimports = 'gopls', -- Use gopls for organizing imports
        -- lsp_diagnostic_signs = true, -- Enable signs for LSP diagnostics
        -- dap_debug = true, -- Enable DAP debugging integration
      })
    end,
    -- Load when a Go filetype is detected for LSP and other features
    event = {"FileType"},
    ft = {"go", 'gomod'},
    -- Command to install/update necessary Go binaries used by go.nvim
    build = ':lua require("go.install").update_all_sync()',
  },

  -- Explicit nvim-treesitter configuration for highlighting and other features
  -- It's good practice to have this separate from the go.nvim dependency
  {
    "nvim-treesitter/nvim-treesitter",
    -- build command to update parsers
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Ensure the Go parser is installed
        ensure_installed = { "go", "lua", "vimdoc", "query" }, -- Add other languages you use

        -- Enable syntax highlighting
        highlight = { enable = true },
        -- Enable indentation
        indent = { enable = false },

        -- Optional: Configure textobjects (requires nvim-treesitter-textobjects)
        -- textobjects = {
        --   select = {
        --     enable = true,
        --     lookahead = true, -- Older versions of nvim-treesitter may need this
        --     keymaps = {
        --       -- You can use the capture groups defined in textobjects.scm
        --       ["af"] = "@function.outer",
        --       ["if"] = "@function.inner",
        --       ["ac"] = "@class.outer",
        --       ["ic"] = "@class.inner",
        --       -- Add more textobjects as needed
        --     },
        --   },
        --   -- Add other textobject modules like 'move' or 'swap' here
        -- },
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
      print("cmp setup called") -- First line in the config function
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        -- Enable LSP snippets
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Key mappings
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(), -- Trigger completion
          ['<C-e>'] = cmp.mapping.abort(),       -- Abort completion
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept selected item
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),

          -- Scroll documentation
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Navigate snippets with tab/shift-tab (consistent with README)
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
        -- Sources for completion
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'cmdline' }, -- Enable cmdline completion
        }),
        -- Behavior during completion
        completion = {
          completeopt = 'menu,menuone,noselect',
        },
      })

      -- Setup command line completion (optional)
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' },
        })
      })
    end,
    event = "VeryLazy", -- Load when entering insert mode
  },
  -- Other utility plugins
  { "nvim-lua/plenary.nvim" }, -- Utility library, dependency for many plugins
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } }, -- Fuzzy finder
  { "hoob3rt/lualine.nvim" }, -- Status line
  { "joshuavial/aider.nvim" }, -- Optional: AI assistant
  {
    "christoomey/vim-tmux-navigator", -- Seamless navigation between Neovim and Tmux panes
    lazy = false  -- Load immediately for smooth navigation
  },

  -- Add any other plugin specifications here following the same format { "owner/repo", ... }
}
