export FLUTTER_ROOT=/usr/local/lib/flutter
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/.mos/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(rbenv init -)"
alias rn="react-native"
alias g="git"
alias vim="nvim"
alias tmux="tmux -u"
alias ngrok-vscode="ngrok http 3000 --region=jp --log=stdout > ngrok.log & PORT=3000 code-server"
alias code="code-insiders"

#export PGDATA=/usr/local/var/postgres
PATH=$JAVA_HOME:$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/lib/flutter/bin
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.cargo/bin/
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/Downloads/account-book-3144d-firebase-adminsdk-v0rk4-2ba00d8cce.json
PATH="$HOME/google-cloud-sdk:$HOME/google-cloud-sdk/bin:$PATH"
PATH="/usr/local/bin/platform-tools:$PATH"
PATH=$(npm bin):$PATH
PATH=$(yarn global bin):$PATH

# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/m4/bin:/opt/homebrew/bin:$PATH"
. "$HOME/.cargo/env"

. $HOME/export-esp.sh
#export PATH="$HOME/.xtensa/xtensa-esp32-elf-clang:$PATH"
alias python="python3"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
