source ~/.config/zshrc/.zshrc-helpers

#-----------------------------#
# Zsh Environment             #
#-----------------------------#
export PATH="$HOME/.local/bin:$PATH"
export DEFAULT_EDITOR="code"


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
                    # Ask git for the real worktree paths instead of globbing the
                    # filesystem: branch names with slashes (e.g. user/ticket-123)
                    # nest worktrees two+ levels deep, which a one-level glob misses.
                    git worktree list --porcelain | awk '/^worktree /{print $2}' | while read -r wt_path; do
                        [[ "$wt_path" == "$worktrees_dir"/* ]] || continue
                        echo "Removing worktree: $wt_path"
                        alias_info git worktree remove "$wt_path"
                    done
                    # Clean up now-empty leftover container dirs (e.g. the "user"
                    # part of a "user/ticket-123" branch-derived path)
                    find "$worktrees_dir" -mindepth 1 -type d -empty -delete 2>/dev/null
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

# Scaffolding commands
# usage: new emma-task <JIRA-TICKET> <branch-description...> [--no-editor]
# branch-description can be multiple words, unquoted; they'll be joined and
# snake_cased, e.g. "new emma-task OOT-2868 display shipping address list"
new_manager() {
    local subcommand=$1

    case "$subcommand" in
        emma-task)
            local no_editor=false
            local positional=()
            local arg
            for arg in "${@:2}"; do
                if [[ "$arg" == "--no-editor" ]]; then
                    no_editor=true
                else
                    positional+=("$arg")
                fi
            done
            local jira_ticket=${positional[1]}
            # join every remaining word into the description, so the caller
            # doesn't need to quote a multi-word description
            local branch_description="${positional[2,-1]}"

            if [ -z "$jira_ticket" ] || [ -z "$branch_description" ]; then
                echo "Error: Please provide a JIRA ticket and a branch description"
                echo "Usage: new emma-task <JIRA-TICKET> <branch-description> [--no-editor]"
                return 1
            fi

            # snake_case: lowercase, collapse any run of non-alphanumerics to a
            # single underscore, and trim leading/trailing underscores
            branch_description=$(echo "$branch_description" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/_/g; s/^_+|_+$//g')

            local branch_name="juliosampaio/${jira_ticket}_${branch_description}"
            alias_info git checkout -b "$branch_name"
            if [ $? -eq 0 ] && [ "$no_editor" = false ]; then
                $DEFAULT_EDITOR . &>/dev/null &
            fi
            ;;
        *)
            echo "Error: Unknown subcommand '$subcommand'"
            echo "Usage: new emma-task <JIRA-TICKET> <branch-description> [--no-editor]"
            return 1
            ;;
    esac
}
alias new="new_manager"
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
