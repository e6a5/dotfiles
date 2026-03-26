#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Starting dotfiles installation..."

# ── 1. Homebrew ──────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script (Apple Silicon path)
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
else
  echo "✅ Homebrew already installed."
fi

# ── 2. System dependencies ────────────────────────────────────────────────────
echo "📦 Installing system dependencies..."
brew install \
  neovim \
  git \
  go \
  ripgrep \
  fd \
  fzf \
  node \
  tmux || brew link --overwrite node 2>/dev/null || true

echo "✅ System dependencies installed."

# ── 3. Go developer tools ─────────────────────────────────────────────────────
echo "🔧 Installing Go developer tools..."
go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest
echo "✅ Go tools installed."

# ── 4. Nerd Font ──────────────────────────────────────────────────────────────
echo "🎨 Installing JetBrainsMono Nerd Font..."
brew install --cask font-jetbrains-mono-nerd-font || echo "⚠️  Font install failed (may need to re-run with GUI session). Set it manually in your terminal."

# ── 5. Symlink configs ────────────────────────────────────────────────────────
echo "🔗 Linking Neovim config..."
mkdir -p ~/.config
# If ~/.config/nvim exists as a real directory (not a symlink), back it up first
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  echo "⚠️  Found existing ~/.config/nvim — backing up to ~/.config/nvim.bak"
  mv ~/.config/nvim ~/.config/nvim.bak
fi
ln -sfn "$DOTFILES_DIR/nvim" ~/.config/nvim
echo "✅ Neovim config linked."

echo "🔗 Linking tmux config..."
ln -sfn "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
echo "✅ tmux config linked."

# ── 6. Install Neovim plugins via Lazy ───────────────────────────────────────
echo "📦 Installing Neovim plugins..."
rm -rf ~/.local/share/nvim/lazy/LuaSnip  # avoid local-mod conflicts
nvim --headless "+Lazy! sync" +qa
echo "✅ Plugins installed."

# ── 7. Treesitter parsers ─────────────────────────────────────────────────────
echo "🌲 Updating Treesitter parsers..."
nvim --headless "+TSUpdate" +qa
echo "✅ Treesitter updated."

# ── 8. go.nvim binaries ───────────────────────────────────────────────────────
echo "🔧 Installing go.nvim tools..."
nvim --headless -c "lua require('go.install').update_all_sync()" +qa
echo "✅ go.nvim tools installed."

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Set 'JetBrainsMonoNL Nerd Font' (or similar) in your terminal font settings."
echo "  2. Open Neovim and run :checkhealth to verify everything is working."
