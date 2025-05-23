# dotfiles

Personal development environment configuration with:

- Neovim (Lazy.nvim-based, Go-focused)
- Tmux integration with seamless navigation
- Auto-setup script (`install.sh`)
- Icon support via Nerd Fonts

---

## Installation

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh  # Ensure it's executable
./install.sh
```

This will:

- Install Go tools (gopls, gofumpt, golangci-lint, dlv)
- Symlink your Neovim config to ~/.config/nvim
- Auto-install Neovim plugins with Lazy.nvim
- Update Treesitter parsers

Run go.nvim tool installation

## Requirements
- Go installed and added to $PATH
- Neovim 0.9+ installed
- Nerd Font (see below)
- Tmux (optional but recommended)

## Neovim Configuration
The nvim/ folder contains your full config:
- Plugin manager: lazy.nvim
- LSP: gopls with nvim-lspconfig
- Completion: nvim-cmp, luasnip
- Treesitter syntax highlighting
- File explorer: nvim-tree
- Fuzzy finder: telescope.nvim
- Status line: lualine.nvim

## Nerd Font Setup
To render icons in nvim-tree, statusline, etc.:
1. Go to: https://www.nerdfonts.com/font-downloads
2. Download and install a full font like JetBrainsMono Nerd Font or FiraCode Nerd Font
3. Set your terminal to use it

✅ Test in terminal:
```bash
echo "     "
```
If you see icons instead of ?, you're good!

## Tmux Integration
To enable seamless navigation between Tmux and Neovim splits, add this to your ~/.tmux.conf:
```bash
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
```

##  License
MIT — use it, fork it, tweak it!

