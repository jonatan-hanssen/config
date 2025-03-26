#!/bin/zsh
export GPG_TTY=$(tty)
# options
setopt dotglob

export PATH="/home/jona/.local/bin:$PATH"
export EDITOR="nvim"

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_PICTURES_DIR="$HOME/pictures"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

export GRIM_DEFAULT_DIR="$HOME/pictures"


# z
source ${XDG_CONFIG_HOME}/zsh/z.zsh
source ${XDG_CONFIG_HOME}/zsh/termtitle.zsh


# autocompletion
autoload -U compinit && compinit
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
setopt COMPLETE_IN_WORD
setopt MENU_COMPLETE

# git
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
typeset -a precmd_functions
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' unstagedstr '%F{red}'
zstyle ':vcs_info:*' stagedstr '%F{green}'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '(%F{046}%c%u%b%f%f) '
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

# prompt
export NEWLINE=$'\n'
rightarrow=$(echo -en '\u25aa')
export PROMPT2=" ${rightarrow} "
export PROMPT='[%?] %F{blue}%~% %f ${vcs_info_msg_0_} %f${NEWLINE}${PROMPT2}'

# this is to make pip not halt looking for some keyring
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
export PAGER='less'

# history
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
alias history="history 0"

# aliases
alias ls="exa --icons --time-style=long-iso"
alias tree="tree -L 3 -C"
alias mv='mv --interactive'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cal='cal -m'
alias jup='jupyter notebook'
alias mosh='mosh --no-init'


# git aliases
alias gs="git status"
alias gc="git commit -s"
alias ga="git add"
alias gp="git push"
alias gd="git diff"
alias gr="git restore"
alias gpl="git pull"

alias mc="make clean"


# python aliases
alias python='python3'
alias pip='pip3'
alias py="python3 -q"
alias pdb="python3 -m pdb"
alias act='source env/bin/activate'

# other aliases
alias sshuio='ssh -YC jonatahh@login.ifi.uio.no'
alias uiomount='sshfs -o reconnect,ServerAliveInterval=2 uio:. ~/ifilokal/ifilokal'
alias :q='exit'
alias c='z' # c is easier to hit
alias pac='sudo pacman -Syu'
alias ra='ranger'

alias close='disown && exit'

# this is to make latex installer work
alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'


# god tier single char aliases
alias d='cd'
alias f='z'
alias l='ls'
alias h='history'
alias s='ssh'
alias a='source a'
alias v='nvim'
alias m="make"
alias b="bat"


alias master='datediff --format="%m %d" now 2025-5-15'

# cd also runs ls
function cd() {
    new_directory="$*";
    if [ $# -eq 0 ]; then 
        new_directory=${HOME};
    fi;
    builtin cd -- "${new_directory}" && ls
}

function ultradog() {
    if [ $# -eq 0 ]; then
        git add -u && git commit -m "do stuff" && git push
        return 0
    fi

    git add -u && git commit -m "$*" && git push
}

function dogshit() {
    if [ $# -eq 0 ]; then
        git commit -m "do stuff" && git push
        return 0
    fi

    git commit -m "$*" && git push
}


# beatufil ranger-cd
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        builtin cd -- "$(cat "$tempfile")"
    fi  
    rm -f -- "$tempfile"
}


bindkey -s '^R' 'ranger-cd\n'


# ------- alert if long since last pacman action ---------
last_update=$(awk 'END{sub(/\[/,""); sub(/\]/,""); print $1}' /var/log/pacman.log)

# get time from last pacman -Syu
diff=$(datediff --format="%d" $last_update now)

# if there is more than 3 days since last update
if (( $diff > 3 )); then
    # compare todays date to previously stored
    cmp -s $XDG_DATA_HOME/curdate <(date +%D)
    # we only want to alert once per day

    # check return value of cmp. 0 if they were the same,
    # so we should not alert
    if [ $? -ne 0 ]; then
        # if not, tell how long since last
        echo -e "Last update: $diff days ago"
        # write new date, so that this does not happen again today
        date +%D > $XDG_DATA_HOME/curdate
    fi
fi
# -------------------------------------------------------

# ------- check if there is a sale on lucy and jack ---------
# compare todays date to previously stored
# cmp -s $XDG_DATA_HOME/curdate2 <(date +%D)
# we only want to alert once per day

# check return value of cmp. 0 if they were the same,
# so we should not alert
# if [ $? -ne 0 ]; then
    # /usr/bin/python3 $HOME/scraping/scrape.py
    # write new date, so that this does not happen again today
    # date +%D > $XDG_DATA_HOME/curdate2
# fi
# -------------------------------------------------------

export PYTHONSTARTUP=$HOME/.config/python/pythonrc
# https://github.com/python/cpython/issues/118840
# dumbasses dont want to implement vi mode >:(
export PYTHON_BASIC_REPL=1


export R_LIBS_USER=$HOME/.rlibrary/library

# pyenv stuff
# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"


# i dont remember why i did this
gpg-connect-agent updatestartuptty /bye >/dev/null

export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

catimg -w 100 $XDG_CONFIG_HOME/zsh/cat.jpg
echo "                Erm, what the flip?"
