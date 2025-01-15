vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'

    -- LSP, autocompletion, and linting
    use 'neovim/nvim-lspconfig'         -- LSP support
    use 'hrsh7th/nvim-cmp'              -- Autocompletion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'nvim-lua/plenary.nvim'         -- Dependency
    use 'jose-elias-alvarez/null-ls.nvim' -- Formatters/Linters

    -- Treesitter for syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- File explorer
    use 'kyazdani42/nvim-tree.lua'

    -- Fuzzy finder
    use 'nvim-telescope/telescope.nvim'

    -- Git integration
    use 'lewis6991/gitsigns.nvim'

    -- Golang support
    use 'fatih/vim-go'

    -- React/TypeScript support
    use 'maxmellon/vim-jsx-pretty'
end)

