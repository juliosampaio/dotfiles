# git

# for maintaining the zshrc local file if it exists
# this is useful for adding custom local configurations
# without modifying the main zshrc file
if [ -f "$HOME/.zshrc-local" ]; then
    source "$HOME/.zshrc-local"
fi