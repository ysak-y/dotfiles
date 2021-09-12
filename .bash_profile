export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/.mos/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(rbenv init -)"
alias rn="react-native"
alias g="git"
alias vim="nvim"

#https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/#get-started-export
alias get_idf='$HOME/esp/esp-idf/install.sh && . $HOME/esp/esp-idf/export.sh'

#export PGDATA=/usr/local/var/postgres
PATH=$HOME/.nodebrew/current/bin:$PATH
PATH=$JAVA_HOME:$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/lib/flutter/bin
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/Downloads/account-book-3144d-firebase-adminsdk-v0rk4-2ba00d8cce.json
PATH="$HOME/google-cloud-sdk:$HOME/google-cloud-sdk/bin:$PATH"
PATH="/usr/local/bin/platform-tools:$PATH"
PATH=$(npm bin):$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/m4/bin:$PATH"
. "$HOME/.cargo/env"

export PATH="$HOME/.xtensa/xtensa-esp32-elf-clang:$PATH"
alias python="python3"
