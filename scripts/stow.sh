cd $DOTFILES_ROOT_DIR
echo ">> Updating stow packages from: $DOTFILES_ROOT_DIR"
stow --restow --verbose=1 .
