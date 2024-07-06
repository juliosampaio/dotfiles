#!/usr/bin/env bash

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo ">> Installing Homebrew..."
  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo ">> Homebrew is already installed."
fi

# Check if installation was successful
if command -v brew >/dev/null 2>&1; then
  echo ">> Homebrew installation was successful."
  echo ">> Updating Homebrew..."
  brew update
  brew upgrade
  brew cleanup
  brew doctor    
  echo ">> Installing packages..."
  xargs brew install < $DOTFILES_ROOT_DIR/homebrew/leaves.txt
  # Optionally, add Homebrew to PATH in .bash_profile or .zshrc if not automatically done by the installer
  # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  # eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo ">> Homebrew installation failed."
fi