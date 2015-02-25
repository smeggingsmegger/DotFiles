# Export some global settings
export EDITOR="vim"
export LESS="-R"

# Style for autocomplete
zstyle ':completion:*' completer _complete _ignored _correct _approximate
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle :compinstall filename "$HOME/.zshrc"

# Load autocompletion
autoload -Uz compinit
compinit

autoload -U bashcompinit
bashcompinit

# Nosetest autocomplete
_nosetests()
{
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=(`nosecomplete ${cur} 2>/dev/null`)
}
complete -o nospace -F _nosetests nosetests

# Correct all mistyped commands
setopt correctall
# Ignore entries with a preceding space
setopt hist_ignore_space
# Change directory when typing directory
setopt autocd

# Enable save history of 1000 cmds, write to a certain file
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Emacs-style bindings
bindkey -e

# Enable Antigen bundle system
# https://github.com/zsh-users/antigen
source "$ZSH_DIR/antigen.zsh"

# Enable oh-my-zsh repo
antigen-use oh-my-zsh

# Turn on some different plugins
antigen-bundle git
antigen-bundle golang
antigen-bundle pip

for p in $PLUGINS; do
    antigen-bundle $p end
done

# Turn on syntax highlighting for shell
antigen-bundle zsh-users/zsh-syntax-highlighting

# Pretty Colors
antigen-theme dpoggi

antigen-apply

# Aliases (at the end to overwrite any antigen aliases)
alias t='todo.sh'
alias ta='todo.sh add'
alias tap='todo.sh adda'
alias tax='todo.sh addx'
alias tp='todo.sh pri'
alias td='todo.sh do'
alias te='todo.sh edit'
alias tls='todo.sh list'
alias gg='git grep -n'
compdef _git gg=git-grep
alias gws='git iws'
compdef _git gws=git-iws
alias gwsc='git iws cut'
compdef _git gwsc=git-iws-cut
alias gwsu='git iws push'
compdef _git gwsu=git-iws-push
alias gwsp='git iws pullrequest'
compdef _git gwsp=git-iws-pullrequest
alias gbu='git branch -u'
compdef _git gbu=git-push
alias ggforce='ggpush -f --no-verify'
compdef ggforce=git
alias gginit='for b in `gba | grep origin | grep -v HEAD | cut -d"/" -f3`; gco $b && gbu upstream/master;'
alias nosecov='nosetests --with-cover --cover-html --cover-html-dir=htmlcov'
compdef _nosetests nosecov=nosetests

# Delete Local & Remote Git Branches from origin
function gbd() {
    git branch -D $1
    git push --delete origin $1
}
compdef _git gbd=git-branch

# Find the commit that introduced a given string or regex
function find_commit_by_string() {
    git log -S "$1" --source --all
}

# Find the pull request for a given commit hash
function pull_request_from_commit() {
    git log --merges --ancestry-path --oneline $1..master | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/IntuitiveWebSolutions/BriteCore/pull/%
}

# Activate virtualenv bottles named .venv automatically upon cd
function chpwd() {
    if [ -d .venv ]; then
        . .venv/bin/activate
    fi
}

# If a home venv exists, turn it on
[[ -d ~/.venv  ]] && . ~/.venv/bin/activate

# Serve HTML Directory at specified port (8000 is the default)
function serve() {
    pushd $1
    python2 -m SimpleHTTPServer $2
    popd
}

# Functions for finding commits and PRs

# This function will find the PR that included a particular commit by hash
function pull_request_from_commit {
    git log --merges --ancestry-path --oneline $1..master | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/IntuitiveWebSolutions/BriteCore/pull/%
}

# This function will find which commit introduced a particular string to the repository.
function find_commit_by_string() {
    git log -S "${(q)1}" --source --all
}

