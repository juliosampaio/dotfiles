source ~/.config/zshrc/.zshrc-helpers

#-----------------------------#
# Zsh Environment             #
#-----------------------------#
export PATH="$HOME/.local/bin:$PATH"
export DEFAULT_EDITOR="zed"


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
# Nix
alias load-nix='. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
# Git
alias gco="alias_info git checkout"
alias gfa="alias_info git fetch --all --tags --force"
alias glog="alias_info git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gst="alias_info git status"
alias gcam="alias_info git commit --amend --no-edit"
alias gss="alias_info git stash save -u"
alias gsp="alias_info git stash pop"
alias gca="alias_info git commit --amend --no-edit --no-verify"
alias gp="alias_info git push origin \$(git branch --show-current)"
alias gfp="alias_info git push origin \$(git branch --show-current) --force-with-lease"
alias gcl="alias_info 'git checkout . && git clean -fd'"
# update the branch with the latest changes from the remote
# usage: grst <branch_name>
git_reset_branch() {
    local branch_name=$1
    gfa
    gco $branch_name
    alias_info git reset --hard origin/$branch_name
}
alias grst="git_reset_branch"

# Git worktree management
# usage: gwt from <branch-name> | gwt add <new-branch> [target-branch] | gwt remove <branch-name> | gwt remove --all
git_worktree_manager() {
    local subcommand=$1
    local branch_name=$2
    local target_branch=$3

    # Validate branch name for commands that need it
    if [[ "$subcommand" == "from" || "$subcommand" == "remove" || "$subcommand" == "add" ]]; then
        if [ -z "$branch_name" ]; then
            echo "Error: Please provide a branch name"
            if [[ "$subcommand" == "add" ]]; then
                echo "Usage: gwt add <new-branch> [target-branch]"
            elif [[ "$subcommand" == "remove" ]]; then
                echo "Usage: gwt remove <branch-name> | gwt remove --all"
            else
                echo "Usage: gwt $subcommand <branch-name>"
            fi
            return 1
        fi
    fi

    # Get the project name from the repository directory name
    local project_name=$(basename $(git rev-parse --show-toplevel))

    # Determine the branch name to use for the worktree path
    local worktree_branch_name="$branch_name"
    local worktree_path="$HOME/Workspace/worktrees/$project_name/$worktree_branch_name"

    case "$subcommand" in
        from)
            # Fetch all remote branches first
            alias_info git fetch --all
            # Create the worktree
            alias_info git worktree add "$worktree_path" "$branch_name"
            # If worktree creation succeeded, cd to it
            if [ $? -eq 0 ]; then
                cd "$worktree_path"
                echo "Changed directory to $worktree_path"
                # Open editor in the new worktree
                $DEFAULT_EDITOR . &>/dev/null &
            fi
            ;;
        add)
            # If no target branch specified, use current branch
            if [ -z "$target_branch" ]; then
                target_branch=$(git branch --show-current)
                echo "Using current branch '$target_branch' as base"
            fi

            # Fetch all remote branches first
            alias_info git fetch --all
            # Create the worktree with a new branch
            alias_info git worktree add -b "$branch_name" "$worktree_path" "$target_branch"
            # If worktree creation succeeded, cd to it
            if [ $? -eq 0 ]; then
                cd "$worktree_path"
                echo "Changed directory to $worktree_path"
                # Open editor in the new worktree
                $DEFAULT_EDITOR . &>/dev/null &
            fi
            ;;
        remove)
            if [[ "$branch_name" == "--all" ]]; then
                # Remove all worktrees for this project
                local worktrees_dir="$HOME/Workspace/worktrees/$project_name"
                if [ -d "$worktrees_dir" ]; then
                    echo "Removing all worktrees for project: $project_name"
                    for worktree_dir in "$worktrees_dir"/*/; do
                        if [ -d "$worktree_dir" ]; then
                            local worktree_name=$(basename "$worktree_dir")
                            echo "Removing worktree: $worktree_name"
                            alias_info git worktree remove "$worktree_dir"
                        fi
                    done
                    echo "All worktrees removed for project: $project_name"
                else
                    echo "No worktrees found for project: $project_name"
                fi
            else
                # Remove specific worktree
                alias_info git worktree remove "$worktree_path"
            fi
            ;;
        *)
            echo "Error: Unknown subcommand '$subcommand'"
            echo "Usage: gwt from <branch-name> | gwt add <new-branch> [target-branch] | gwt remove <branch-name> | gwt remove --all"
            return 1
            ;;
    esac
}
alias gwt="git_worktree_manager"
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
# opencode
export PATH="/Users/julio.sampaio/.bun/bin:$PATH"
# ollama
export OLLAMA_KEEP_ALIVE="-1"

source ${DEVELOPER_TOOLBOX_HOME}/zshrc/aws.zsh
source ${DEVELOPER_TOOLBOX_HOME}/zshrc/kubectl.zsh
export EMMA_TEAM_NAME=offline
export DEVELOPER_TOOLBOX_HOME=/Users/julio.sampaio/.developer-toolbox
source ${DEVELOPER_TOOLBOX_HOME}/zshrc/devx.zsh
