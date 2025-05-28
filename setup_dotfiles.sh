#!/bin/bash

set -e

# ----------- Variables -----------

DOTFILES_REPO="https://github.com/SajanGhuman/Dotfiles"
DOTFILES_DIR="$HOME/Dotfiles"
CONFIG_DIRS=(config p10k tmux xinitrc zsh)

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

declare -A ZSH_PLUGINS=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
  [zsh-256color]="https://github.com/chrissicool/zsh-256color"
)

# ----------- Clone or update dotfiles -----------

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "Dotfiles repository already exists. Pulling latest changes..."
  git -C "$DOTFILES_DIR" pull
fi

# ----------- Install Oh My Zsh -----------

if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed."
fi

# ----------- Install Powerlevel10k -----------

if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"
else
  echo "Powerlevel10k already installed."
fi

# ----------- Install Zsh plugins -----------

echo "Installing Zsh plugins..."

for plugin in "${!ZSH_PLUGINS[@]}"; do
  plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
  if [ ! -d "$plugin_dir" ]; then
    echo "Installing $plugin..."
    git clone "${ZSH_PLUGINS[$plugin]}" "$plugin_dir"
  else
    echo "$plugin already installed."
  fi
done

# ----------- Install ASDF -----------

if [ ! -d "${HOME}/.asdf" ]; then
  echo "Installing ASDF version manager..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
else
  echo "ASDF already installed."
fi

# ----------- Symlink config directories with stow -----------

echo "Linking dotfiles with stow..."
cd "$DOTFILES_DIR" || { echo "Failed to cd to $DOTFILES_DIR"; exit 1; }

for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "Stowing $dir..."
    stow -v -R -t "$HOME" "$dir"
  else
    echo "Directory $dir does not exist, skipping..."
  fi
done

echo ""
echo "✅ Dotfiles and tools setup complete!"
echo "👉 Restart your terminal or run 'exec zsh' to apply changes."
