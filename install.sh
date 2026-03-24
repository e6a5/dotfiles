#!/bin/bash

set -e

echo "🚀 Starting dotfiles installation..."
# 1. Install Go tools
echo "🔧 Installing Go developer tools..."
go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest

echo "✅ Go tools installed."

# 2. Show Nerd Font install reminder
echo "🎨 Please make sure to install a Nerd Font (e.g. JetBrainsMono Nerd Font Complete)"
echo "Download from: https://www.nerdfonts.com/font-downloads"
echo "And set it in your terminal settings before using Neovim."

# 3. Create symlink for nvim config
echo "🔗 Linking Neovim config..."
mkdir -p ~/.config
ln -sf $(pwd)/nvim ~/.config/nvim

# 4. Launch Neovim to trigger Lazy plugin installation
echo "📦 Opening Neovim to install plugins..."
nvim --headless "+Lazy! sync" +qa

# 5. Update Treesitter parsers
echo "🌲 Updating Treesitter parsers..."
nvim --headless "+TSUpdate" +qa

# 6. Install go.nvim binaries (optional)
echo "📦 Installing go.nvim tools..."
nvim --headless -c "lua require('go.install').update_all_sync()" +qa

echo "🎉 Setup complete! Open Neovim normally and enjoy your config."


