source ~/.config/zshrc/.zshrc-helpers

#-----------------------------#
# Zsh Environment             #
#-----------------------------#
export PATH="$HOME/.local/bin:$PATH"


#-----------------------------#
# Oh-My-Zsh                   #
#-----------------------------#

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
alias gss="alias_info git stash save -u"
alias gsp="alias_info git stash pop"
# update the branch with the latest changes from the remote
# usage: grst <branch_name>
git_reset_branch() {
    local branch_name=$1
    gfa
    gco $branch_name
    alias_info git reset --hard origin/$branch_name
}
alias grst="git_reset_branch"
#-----------------------------#
# Machine specific zshrc      #
#-----------------------------#
if [ -f "$HOME/.zshrc-local" ]; then
    source "$HOME/.zshrc-local"
fi
# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
