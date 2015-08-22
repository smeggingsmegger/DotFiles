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

alias bc='cd ~/repos/BriteCore/'

# Better ls alias for Mac
alias ls='ls -GpFh'

PLUGINS=('vagrant' 'brew')
source "$ZSH_DIR/common.zsh"
$(boot2docker shellinit 2>/dev/null)
