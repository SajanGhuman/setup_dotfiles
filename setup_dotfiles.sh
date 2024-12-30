#!/bin/bash

# Define variables
DOTFILES_REPO="https://github.com/SajanGhuman/Dotfiles"  # Replace with your Git repository URL
DOTFILES_DIR="$HOME/Dotfiles"
CONFIG_DIRS=(config p10k tmux xinitrc zsh)

# Clone the dotfiles repository
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "Dotfiles repository already exists. Pulling latest changes..."
  git -C "$DOTFILES_DIR" pull
fi

# Navigate to the dotfiles directory
cd "$DOTFILES_DIR" || { echo "Failed to navigate to $DOTFILES_DIR"; exit 1; }

# Use stow to symlink configuration directories
for dir in "${CONFIG_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "Stowing $dir..."
    stow -v -R -t "$HOME" "$dir"
  else
    echo "Directory $dir does not exist, skipping..."
  fi
done

# Completion message
echo "Dotfiles setup complete!"

