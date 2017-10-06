# Source antigen
source /usr/local/share/antigen/antigen.zsh

# Load private vars
source ~/.private/vars.sh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Add ZSH Syntax Hightlighting
antigen bundle zsh-users/zsh-syntax-highlighting

# Plugins
antigen bundle bundler
antigen bundle git
antigen bundle docker
antigen bundle autojump
antigen bundle node
antigen bundle npm
antigen bundle osx
antigen bundle redis-cli
antigen bundle golang
antigen bundle postgres
antigen bundle rust
antigen bundle terraform
antigen bundle heroku
antigen bundle chruby
antigen bundle zsh-users/zsh-completions
antigen bundle cp
antigen bundle yarn
antigen bundle commercialtribe/.zshrc

# Theme
antigen theme https://github.com/jwaldrip/bullet-train-oh-my-zsh-theme bullet-train
BULLETTRAIN_GIT_COLORIZE_DIRTY=true
BULLETTRAIN_PERL_SHOW=true
BULLETTRAIN_GO_BG=80
BULLETTRAIN_GO_FG=230
BULLETTRAIN_GO_SHOW=true
BULLETTRAIN_RUBY_SHOW=true
BULLETTRAIN_NVM_SHOW=true
BULLETTRAIN_VIRTUALENV_SHOW=true
BULLETTRAIN_CONTEXT_DEFAULT_USER=$USER

# Nix
. /Users/jwaldrip/.nix-profile/etc/profile.d/nix.sh

# Editors
export EDITOR="vim"
export VISUAL="atom -w"

# Disable Auto Correct
DISABLE_CORRECTION="true"
unsetopt correct_all

# Aliases
alias zshconfig="e ~/.zshrc"
alias kiki="echo 'love of my life'"
alias g=git
alias twr=gittower
alias reload!="exec $SHELL"
alias d=docker
alias dc=docker-compose
alias e=$EDITOR
alias a="atom"
alias finder-show-hidden-files="defaults write com.apple.finder AppleShowAllFiles YES && sudo killall Finder"
alias finder-hide-hidden-files="defaults write com.apple.finder AppleShowAllFiles NO && sudo killall Finder"
alias docker-implode="docker ps -aq | xargs docker rm -f; docker images -aq | xargs docker rmi; docker volume prune"

# Paths
export PATH="$HOME/bin:$PATH"

# PKG config
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# Set the development path
export DEVPATH=~/dev

# Set the Go path
export GOPATH=$DEVPATH
export PATH=$GOPATH/bin:$PATH

# iTerm integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
fi

# Get npm token
export NPM_TOKEN="$(cat ~/.npmrc | grep "//registry.npmjs.org/:_authToken=" | sed "s/.*=//")"

# SSH Agent
grep -rwl ~/.ssh/* -e 'PRIVATE KEY-----' | xargs ssh-add &> /dev/null

# added by travis gem
[ -f /Users/jwaldrip/.travis/travis.sh ] && source /Users/jwaldrip/.travis/travis.sh

antigen apply

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh
