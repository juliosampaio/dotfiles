# git
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# for maintaining the zshrc local file if it exists
# this is useful for adding custom local configurations
# without modifying the main zshrc file
if [ -f "$HOME/.zshrc-local" ]; then
    source "$HOME/.zshrc-local"
fi