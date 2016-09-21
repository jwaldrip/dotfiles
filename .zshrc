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

# Install Required Packages
which brew &> /dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
which autojump &> /dev/null || brew install autojump
which git &> /dev/null || brew install git
which ruby-install &>/dev/null || brew install ruby-install

# Install Programming Languages
which go &> /dev/null || brew install go
which crystal &> /dev/null || brew install crystal-lang
which node &> /dev/null || brew install node
which elixir &> /dev/null || brew install elixir
which rustc &> /dev/null || brew install rust

# Install used libaries
which psql &> /dev/null || brew install postgresql
which mysql &> /dev/null || brew install mysql

# Install Tools
which heroku &> /dev/null || brew install heroku
which terraform &> /dev/null || brew install terraform

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

# Other Tools
brew list chruby &> /dev/null || brew install chruby
source `brew --prefix chruby`/share/chruby/chruby.sh
source `brew --prefix chruby`/share/chruby/auto.sh

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
if [ -f /Users/jwaldrip/Downloads/google-cloud-sdk/path.zsh.inc ]; then
  source '/Users/jwaldrip/Downloads/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/jwaldrip/Downloads/google-cloud-sdk/completion.zsh.inc ]; then
  source '/Users/jwaldrip/Downloads/google-cloud-sdk/completion.zsh.inc'
fi

# SSH Agent
eval $(ssh-agent) &> /dev/null
grep -rwl ~/.ssh/* -e 'PRIVATE KEY-----' | xargs ssh-add &> /dev/null
