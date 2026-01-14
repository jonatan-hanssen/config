# Environment variables

# paths
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_PICTURES_DIR="$HOME/pictures"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"
export PATH="/home/jona/.local/bin:$PATH"
export GRIM_DEFAULT_DIR="$HOME/pictures"

# variables read by other programs
export EDITOR="nvim"
export PAGER='less'

export GPG_TTY=$(tty)

# python
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
export PYTHONSTARTUP=$HOME/.config/python/pythonrc
# https://github.com/python/cpython/issues/118840
# dumbasses dont want to implement vi mode >:(
export PYTHON_BASIC_REPL=1

export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
