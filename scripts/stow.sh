cd $DOTFILES_ROOT_DIR
echo ">> Updating stow packages from: $DOTFILES_ROOT_DIR"
stow --restow --verbose=1 .

# Create symlinks for zsh files that must be in home directory
echo ">> Creating symlinks for zsh config files in home directory"
ln -sf ~/.config/zshrc/.zshrc ~/.zshrc
ln -sf ~/.config/zshrc/.zprofile ~/.zprofile
