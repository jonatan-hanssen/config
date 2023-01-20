#!/bin/zsh
# options
setopt dotglob

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
zstyle ':vcs_info:*' unstagedstr '%F{196}'
zstyle ':vcs_info:*' stagedstr '%F{208}'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '(%F{046}%c%u%b%f%f) '
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

# prompt
export NEWLINE=$'\n'
rightarrow=$(echo -en '\u25aa')
export PROMPT2=" ${rightarrow} "
export PROMPT='[%?] %F{027}%~% %f ${vcs_info_msg_0_} %f${NEWLINE}${PROMPT2}'

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

# aliases
alias ls="ls --color=auto"
alias tree="tree -L 3 -C"
alias mv='mv --interactive'
alias v='nvim'
alias ls='ls --color=always'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cal='cal -m'


# git aliases
alias gs="git status"
alias gc="git commit -s"
alias ga="git add"
alias gp="git push"
alias gd="git diff"
alias gr="git restore"
alias gpl="git pull"
alias gch="git checkout"


# python aliases
alias python='python3'
alias pip='pip3'
alias py="python3"
alias act='source env/bin/activate'

# other aliases
alias batt='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
alias sshuio='ssh -YC jonatahh@login.ifi.uio.no'
alias uiomount='sshfs jonatahh@login.ifi.uio.no:. ~/ifilokal'
alias :q='exit'
alias c='z' # c is easier to hit
alias pac='sudo pacman -Syu'

# this is to make latex installer work
alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'

# cd also runs ls
function cd() {
    new_directory="$*";
    if [ $# -eq 0 ]; then 
        new_directory=${HOME};
    fi;
    builtin cd "${new_directory}" && ls
}


# i dont remember why i did this
gpg-connect-agent updatestartuptty /bye >/dev/null

export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
bindkey -v
