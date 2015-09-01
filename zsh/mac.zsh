ZSHRC=$(readlink "$HOME"/.zshrc)
ZSH_DIR=$(dirname "$ZSHRC")

export PATH="$HOME/bin:$HOME/Documents/go-zone/bin:$(brew --prefix go)/libexec/bin:$(brew --prefix gnu-sed)/libexec/gnubin:$(brew --prefix coreutils)/libexec/gnubin:$(brew --prefix findutils)/bin:$(brew --prefix ruby)/bin:/usr/local/share/npm/bin:/usr/local/sbin:/usr/local/bin:${PATH}"
export MANPATH="$(brew --prefix gnu-sed)/libexec/gnuman:$MANPATH"
export GOPATH="$HOME/Documents/go-zone"
export NODE_PATH="/usr/local/lib/node_modules"

# Homebrew cask aliases
alias cask_install="brew cask install --appdir=/Applications"
alias cask_uninstall="brew cask uninstall"
alias cask_search="brew cask search"
alias cask_list="brew cask list"
# Set up haste to use our BriteCore server
alias work_haste='HASTE_SERVER=http://hastebin.britecorepro.com haste'

# Better ls alias for Mac
alias ls='ls -GpFh'

alias fixtime='boot2docker ssh sudo ntpclient -s -h us.pool.ntp.org'

function macvim () { open -a /Applications/MacVim.app $1 }

# devbrite Functions / Aliases
alias bc='cd ~/repos/BriteCore/'

function git_branch_name () {
    git rev-parse --symbolic-full-name --abbrev-ref HEAD
}
function git_clean_branch_name () {
    git_branch_name | tr -cd '[[:alnum:]]'
}
function dbw () {
    bc
    if (( $# == 0  )) { machine=$(git_clean_branch_name) } else { machine=$1 }
    devbrite workon $machine
}
function dbrestart () {
    bc
    if (( $# == 0  )) { machine=$(git_clean_branch_name) } else { machine=$1 }
    devbrite restart $machine
}
function dbstart () {
    bc
    if (( $# == 0  )) { machine=$(git_clean_branch_name) } else { machine=$1 }
    devbrite start $machine
}
function dbstop () {
    bc
    if (( $# == 0  )) { machine=$(git_clean_branch_name) } else { machine=$1 }
    devbrite stop $machine
}
function dbsp () {
    bc
    if (( $# == 0  )) { machine=$(git_clean_branch_name) } else { machine=$1 }
    dbw
    devbrite sequelpro $machine
}
function dbb () {
    bc
    if (( $# == 0  )) { machine=$(git_clean_branch_name) } else { machine=$1 }
    dbw
    devbrite browse $machine
}
function dbe () {
    bc
    if (( $# == 0  )) { machine=$(git_clean_branch_name) } else { machine=$1 }
    dbw
    devbrite enter $machine webserver
}
function dbdel () {
    bc
    if (( $# == 0  )) { machine=$(git_clean_branch_name) } else { machine=$1 }
    devbrite delete $machine
}
function dbc () {
    bc
    fixtime
    machine=$(git_clean_branch_name)
    devbrite create -w $machine $1
}
function dbn () {
    bc
    fixtime
    machine=$(git_clean_branch_name)
    devbrite nuke
}
function dbrun () {
    bc
    if (( $# == 1  )) {
        machine=$(git_clean_branch_name)
        container='webserver'
        command=$1
    } elif (( $# == 2  )) {
        machine=$(git_clean_branch_name)
        container=$1
        command=$2
    } else {
        machine=$1
        container=$2
        command=$3
    }
    devbrite run $machine $container $command
}

PLUGINS=('vagrant' 'brew')
source "$ZSH_DIR/common.zsh"
$(boot2docker shellinit 2>/dev/null)
