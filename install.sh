#!/usr/bin/env bash
{# this ensures the entire script is downloaded #
git --version 2>&1 >/dev/null

GIT_IS_AVAILABLE=$?

if [ $GIT_IS_AVAILABLE -eq 0 ]; then
  git clone https://github.com/juliosampaio/dotfiles.git $HOME/.dotfiles
  cd $HOME/.dotfiles
  echo "I need you to enter your sudo password so I can install some things:"
  sudo -v
  ./setup.sh
else
  echo "It seems you don't have git installed. Please install it then execute this file again."
fi
}# this ensures the entire script is downloaded #
