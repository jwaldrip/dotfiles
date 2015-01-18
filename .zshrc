# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# zmodload zsh/complist

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="steeef"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

plugins=(autojump brew bundler chruby docker gitfast lwd node npm osx rails redis-cli ruby)

source $ZSH/oh-my-zsh.sh

# Editors
export EDITOR="vim"
export VISUAL="atom -w"

# Disable Auto Correct
DISABLE_CORRECTION="true"

# Aliases
alias zshconfig="e ~/.zshrc"
alias g=git
alias twr=gittower
alias reload!="exec $SHELL"
alias e=$EDITOR

## PATH ASSIGNMENTS

# Add Homebrew PATH
export PATH="/usr/local/bin:$PATH"

# Add Homedir PATH
export PATH="$HOME/bin:$PATH"

# Add Current Directory Path
export PATH="./bin:$PATH"

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# PG App
export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"

# Default Vagrant
export VAGRANT_DEFAULT_PROVIDER=vmware_fusion

### Exports

# Deis Ctl
export DEISCTL_TUNNEL="deis.waldrip.do-nyc3.brandfolder.com"

# Set the bundler editor
export BUNDLER_EDITOR=mine

# Android SDK HOME
export ANDROID_HOME=/usr/local/opt/android-sdk

# Set the default provider
export VAGRANT_DEFAULT_PROVIDER=virtualbox

# Set up boot2docker
if which boot2docker > /dev/null ; then
  boot2dockerstatus=$(boot2docker status)
  if [ "$boot2dockerstatus" = "running" ] ; then
    # Do nothing, boot2docker is running
  elif [ "$boot2dockerstatus" = "poweroff" ] ; then
    boot2docker start
    boot2docker up
  else 
    echo "initializing boot2docker..."
    boot2docker destroy
    rm -f .ssh/id_boot2docker
    rm -f .ssh/id_boot2docker.pub
    boot2docker init
    boot2docker start
    boot2docker up
  fi
  # init the shell
  $(boot2docker shellinit 2> /dev/null)
fi

# Set the Development PATH
export DEVPATH=~/dev

# Set the Go path
export GOPATH=$DEVPATH
export PATH=$GOPATH/bin:$PATH

# Locate Atom
export ATOM_PATH=~/Applications

### chruby
if [ -f '/usr/local/share/chruby/chruby.sh' ] ; then
source '/usr/local/share/chruby/chruby.sh'
fi
if [ -f '/usr/local/opt/chruby/share/chruby/auto.sh' ] ; then
  source '/usr/local/opt/chruby/share/chruby/auto.sh'
fi

### Goop Env
function goopinit(){
  eval $(goop env)
}

### Brew Bundle
function brew-bundle(){
  cat Brewfile | sed 's:#.*$::g' | sed '/^$/d' | /usr/bin/ruby -e "STDIN.each_line { |line| system 'brew ' + line.strip }"
}

### AUTOJUMP SETUP
if which autojump > /dev/null ; then
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi
