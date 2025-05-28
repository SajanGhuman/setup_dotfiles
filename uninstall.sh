#!/bin/bash

# Define variables
DOTFILES_DIR="$HOME/Dotfiles"
CONFIG_DIRS=(config p10k tmux xinitrc zsh)

# Confirm before proceeding
read -p "⚠️ This will remove your dotfiles symlinks and delete related tools. Continue? [y/N]: " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

echo ""

# Unstow config directories
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR" || { echo "❌ Could not access $DOTFILES_DIR"; exit 1; }
  for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
      echo "Unstowing $dir..."
      stow -v -D -t "$HOME" "$dir"
    else
      echo "Directory $dir does not exist in $DOTFILES_DIR, skipping..."
    fi
  done
else
  echo "❌ Dotfiles directory $DOTFILES_DIR does not exist."
fi

echo ""

# Ask whether to delete Dotfiles repo
if [ -d "$DOTFILES_DIR" ]; then
  read -p "🗑️ Do you want to delete the entire Dotfiles directory at $DOTFILES_DIR? [y/N]: " del_dotfiles
  if [[ "$del_dotfiles" =~ ^[Yy]$ ]]; then
    rm -rf "$DOTFILES_DIR"
    echo "Deleted $DOTFILES_DIR"
  fi
fi

# Remove Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  read -p "🗑️ Remove Oh My Zsh? [y/N]: " del_omz
  if [[ "$del_omz" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.oh-my-zsh"
    echo "Removed Oh My Zsh"
  fi
fi

# Remove Powerlevel10k theme
if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  read -p "🗑️ Remove Powerlevel10k theme? [y/N]: " del_p10k
  if [[ "$del_p10k" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    echo "Removed Powerlevel10k"
  fi
fi

# Remove ASDF version manager
if [ -d "$HOME/.asdf" ]; then
  read -p "🗑️ Remove ASDF version manager? [y/N]: " del_asdf
  if [[ "$del_asdf" =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.asdf"
    echo "Removed ASDF"
  fi
fi

echo ""
echo "✅ Uninstallation complete."
