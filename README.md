# dotfiles

Personal development environment configuration for macOS, focused on Go development.

- Neovim (Lazy.nvim-based, Go-focused)
- Tmux with seamless Neovim split navigation
- One-command install script (`install.sh`)
- JetBrainsMono Nerd Font (auto-installed)

---

## Installation

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script will:

1. Install Homebrew (if not already installed)
2. Install system dependencies: `neovim`, `git`, `go`, `ripgrep`, `fd`, `fzf`, `node`, `tmux`
3. Install Go developer tools: `gopls`, `gofumpt`, `golangci-lint`, `dlv`
4. Install JetBrainsMono Nerd Font via Homebrew Cask
5. Symlink `nvim/` → `~/.config/nvim` (backs up existing config to `~/.config/nvim.bak`)
6. Symlink `tmux.conf` → `~/.tmux.conf`
7. Install Neovim plugins via Lazy.nvim
8. Update Treesitter parsers
9. Install go.nvim binaries

After install, set **JetBrainsMonoNL Nerd Font** in your terminal font settings and run `:checkhealth` in Neovim.

---

## Requirements

- macOS (uses Homebrew and `pbcopy`)
- Nerd Font-capable terminal (iTerm2, Kitty, Wezterm, etc.)

Go and Neovim are installed automatically by the script.

---

## Neovim Configuration

The `nvim/` folder contains the full config:

| Component | Plugin |
|---|---|
| Plugin manager | lazy.nvim |
| LSP | gopls via nvim-lspconfig |
| Completion | nvim-cmp + luasnip |
| Syntax | Treesitter |
| File explorer | nvim-tree |
| Fuzzy finder | telescope.nvim |
| Status line | lualine.nvim |
| Go integration | go.nvim |

---

## Tmux Configuration

`tmux.conf` includes:

- **Prefix**: `C-a` (replaces default `C-b`)
- **Mouse**: enabled
- **True color**: 256-color + `Tc` override for correct colors in Neovim
- **Escape time**: 10ms (prevents Neovim input lag)
- **Smart pane navigation**: `C-h/j/k/l` move between tmux panes and Neovim splits transparently
- **Clipboard**: `y` in copy mode pipes to `pbcopy`
- **Scrollback**: 10,000 lines
- **Window/pane numbering**: starts at 1

---

## License

MIT — use it, fork it, tweak it.
