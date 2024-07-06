#!/usr/bin/env bash

DOTFILES_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DOTFILES_ROOT_DIR=$(dirname "$DOTFILES_SCRIPT_DIR")

export DOTFILES_ROOT_DIR
export DOTFILES_SCRIPT_DIR

"$DOTFILES_SCRIPT_DIR/homebrew.sh"
# Install oh-my-zsh before setting up zshenv, so it don't overwrite the .zshrc file
"$DOTFILES_SCRIPT_DIR/oh-my-zsh.sh"
"$DOTFILES_SCRIPT_DIR/zshenv.sh"
"$DOTFILES_SCRIPT_DIR/stow.sh"