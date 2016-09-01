# Install antigen, if not already installed
init-antigen() {
  source antigen-$1.zsh || (curl https://cdn.rawgit.com/zsh-users/antigen/$1/antigen.zsh > antigen-$1.zsh && init-antigen)
}
init-antigen v1.0.4

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
antigen bundle ruby
antigen bundle rails
antigen bundle bundler
antigen bundle git
antigen bundle docker
antigen bundle autojump
antigen bundle chruby
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
which chruby &> /dev/null || brew install chruby

# Theme
# antigen bundle frmendes/geometry
antigen theme https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train

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
