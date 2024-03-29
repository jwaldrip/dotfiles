# /--------------------------------------------------\
# | NOTE: You need to be running zsh as your shell:  |
# |    `chsh -s /bin/zsh`                            |
# |                                                  |
# |  ...and have antigen installed:                  |
# |    `brew install antigen`                        |
# \--------------------------------------------------/

# Set up completions
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# Source antigen
source "$(brew --prefix antigen)/share/antigen/antigen.zsh"

# Load private vars, ignore if not present
source ~/.private/vars.sh 2> /dev/null || true

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Add ZSH Syntax Hightlighting
antigen bundle zsh-users/zsh-syntax-highlighting

# Plugins
antigen bundle bundler
antigen bundle asdf
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
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-apple-touchbar
antigen bundle cp
antigen bundle yarn
antigen bundle jimeh/zsh-peco-history

# Theme
# antigen theme https://github.com/jwaldrip/bullet-train-oh-my-zsh-theme bullet-train
# BULLETTRAIN_GIT_COLORIZE_DIRTY=true
# BULLETTRAIN_PERL_SHOW=true
# BULLETTRAIN_GO_BG=80
# BULLETTRAIN_GO_FG=230
# BULLETTRAIN_GO_SHOW=true
# BULLETTRAIN_RUBY_SHOW=true
# BULLETTRAIN_NVM_SHOW=true
# BULLETTRAIN_VIRTUALENV_SHOW=true
# BULLETTRAIN_CONTEXT_DEFAULT_USER=$USER

# History Settings
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000
export SAVEHIST=$HISTSIZE

# Editors
export EDITOR="vim"
export VISUAL="code"
export REACT_EDITOR="code"

# Disable Auto Correct
DISABLE_CORRECTION="true"
unsetopt correct_all

# Direnv
eval "$(direnv hook zsh)"

# ASDF
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
if [ -f ~/.asdf/plugins/java/set-java-home.zsh ] ; then
  . ~/.asdf/plugins/java/set-java-home.zsh
fi

# Aliases
alias zshconfig="e ~/.zshrc"
alias kiki="echo 'love of my life'"
alias g=git
alias twr='gittower `git root`'
alias reload!="exec $SHELL"
alias d=docker
alias dc=docker-compose
alias e=$EDITOR
alias code="code-insiders"
alias c="code"
alias atom="code"
alias a="atom"
alias icr="`brew --prefix crystal`/bin/crystal i"
alias finder-show-hidden-files="defaults write com.apple.finder AppleShowAllFiles YES && sudo killall Finder"
alias finder-hide-hidden-files="defaults write com.apple.finder AppleShowAllFiles NO && sudo killall Finder"
alias docker-implode="docker ps -aq | xargs docker rm -f; docker images -aq | xargs docker rmi; docker volume prune"
alias dj="curl https://icanhazdadjoke.com/"
alias backmergedev='for mr in `lab mr list -a --target-branch dev | grep -oE "\d{4}"`; do lab mr checkout $mr --force && git fu && git pull --no-edit && git pull --no-edit origin dev && git push; git merge --abort ; done'
alias mr="lab mr checkout"
alias codegr='code `git root`'
alias cdgr='cd `git root`'
alias glci="lab issue create"
alias glcifm="lab issue create -a jwaldrip"
alias glcmr="lab mr create origin"
alias m="cd /Users/jwaldrip/dev/src/gitlab.com/gigsmart/projects/monorepo"
alias m1="cd /Users/jwaldrip/dev/src/gitlab.com/gigsmart/projects/monorepo-1"
alias m2="cd /Users/jwaldrip/dev/src/gitlab.com/gigsmart/projects/monorepo-2"
alias ksh="kubectl run $USER-`openssl rand -hex 5` --image=busybox --restart=Never --attach --wait --rm -it"
alias fix10='yarn tsc -b | grep -oE "[^\(]*\.tsx?" | grep --invert-match "error T" | uniq | head -10 | xargs code'
alias k='kubectl'
alias kns='kubectl config set-context --current --namespace'

# Paths
export PATH="$HOME/bin:$PATH"

# PKG config
export PKG_CONFIG_PATH=$(brew --prefix openssl@1.1)/lib/pkgconfig:$PKG_CONFIG_PATH
export KERL_BUILD_DOCS="no"
export KERL_CONFIGURE_OPTIONS=" \
--disable-debug \
--disable-silent-rules \
--without-javac \
--enable-shared-zlib \
--enable-dynamic-ssl-lib \
--enable-threads \
--enable-kernel-poll \
--enable-wx \
--enable-darwin-64bit \
--with-ssl=$(brew --prefix openssl@1.1) \
--with-dynamic-trace=dtrace \
--enable-smp-support \
"

# Set the development path
export DEVPATH=~/dev

# Use GKE Auth Plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Set the Go path
export GOPATH=$DEVPATH
export PATH=$GOPATH/bin:$PATH

# iTerm integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# Set Android SDK path
# export ANDROID_HOME=
# export ANDROID_NDK_HOME=
export ANDROID_SDK_ROOT=$(brew --prefix)/share/android-commandlinetools
export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
export PATH=$ANDROID_SDK_ROOT/emulator:$PATH

# SSH Agent
grep -rwl ~/.ssh/* -e 'PRIVATE KEY-----' | xargs ssh-add -K &> /dev/null

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# increase node size
export NODE_OPTIONS=--max-old-space-size=4096

antigen apply

which starship &>/dev/null && eval "$(starship init zsh)"
export PATH="/usr/local/sbin:$PATH"





