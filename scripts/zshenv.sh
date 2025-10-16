#!/usr/bin/env bash
echo ">> Setting up zsh environment"

EXPECTED_CONTENT='export ZDOTDIR="$HOME"/.config/zshrc'

# Check if .zshenv exists and has correct content
if [ -f "$HOME/.zshenv" ]; then
  CURRENT_CONTENT=$(cat "$HOME/.zshenv")
  if [ "$CURRENT_CONTENT" = "$EXPECTED_CONTENT" ]; then
    echo "   ✓ .zshenv already configured correctly"
    exit 0
  else
    echo "   → Updating .zshenv with new configuration"
  fi
else
  echo "   → Creating .zshenv"
fi

echo "$EXPECTED_CONTENT" > ~/.zshenv
