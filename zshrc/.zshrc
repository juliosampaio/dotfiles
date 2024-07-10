source ~/.config/zshrc/.zshrc-helpers
#-----------------------------#
# oh-my-zsh                   #
#-----------------------------#
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh
#-----------------------------#
# Starship                    #
#-----------------------------#
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
#-----------------------------#
# FZF                         #
#-----------------------------#
source <(fzf --zsh)
#-----------------------------#
# Aliases                     #
#-----------------------------#
# Git
alias gco="alias_info git checkout"
alias gfa="alias_info git fetch --all --tags --force"
alias glog="alias_info git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gst="alias_info git status"
alias gcam="alias_info git commit --amend --no-edit"
#-----------------------------#
# Machine specific zshrc      #
#-----------------------------#
if [ -f "$HOME/.zshrc-local" ]; then
    source "$HOME/.zshrc-local"
fi