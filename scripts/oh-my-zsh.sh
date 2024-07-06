echo ">> Installing oh-my-zsh"

#if the folder $HOME/.oh-my-zsh already exists, let's stop the script
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo ">> oh-my-zsh is already installed. Skipping..."
    exit 0
fi

if [ -f "$HOME/.zshenv" ]; then
    rm "$HOME/.zshenv"
fi
cd $HOME
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
PID=$!
wait $PID
echo "oh-my-zsh.sh completed"
# remove the original .zshrc file from the oh-my-zsh installation
# we will create a new one with stow
echo ">> Removing the original .zshrc file from the oh-my-zsh installation"
if [ -f "$HOME/.zshrc" ]; then
    rm "$HOME/.zshrc"
fi