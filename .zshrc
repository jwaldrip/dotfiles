# Install antigen, if not already installed
antigen_version=v1.0.4
init-antigen() {
  source ~/antigen-$antigen_version.zsh || (curl https://cdn.rawgit.com/zsh-users/antigen/$antigen_version/antigen.zsh > ~/antigen-$antigen_version.zsh && init-antigen)
}
init-antigen

# Load private vars
source ~/.private/vars.sh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh


# Add ZSH Syntax Hightlighting
antigen bundle zsh-users/zsh-syntax-highlighting

# Plugins
antigen bundle brew
# antigen bundle ruby
# antigen bundle rails
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
alias e=$EDITOR
alias finder-show-hidden-files="defaults write com.apple.finder AppleShowAllFiles YES && sudo killall Finder"
alias finder-hide-hidden-files="defaults write com.apple.finder AppleShowAllFiles NO && sudo killall Finder"

# Paths
export PATH="$HOME/bin:$PATH"

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

# Crystal completion
if [ -f /usr/local/share/zsh/site-functions ]; then
  source '/usr/local/share/zsh/site-functions'
fi

# Get npm token
export NPM_TOKEN="$(cat ~/.npmrc | sed "s/.*=//")"

# Google Cloud Creds
export CLOUDSDK_CONTAINER_USE_CLIENT_CERTIFICATE=True

# SSH Agent
eval $(ssh-agent) &> /dev/null
grep -rwl ~/.ssh/* -e 'PRIVATE KEY-----' | xargs ssh-add &> /dev/null

# added by travis gem
[ -f /Users/jwaldrip/.travis/travis.sh ] && source /Users/jwaldrip/.travis/travis.sh
