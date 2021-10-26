#!/bin/zsh

# options
setopt dotglob

# autocompletion
autoload -U compinit promptinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
setopt COMPLETE_IN_WORD
setopt MENU_COMPLETE

# git
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
typeset -a precmd_functions
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' unstagedstr '%F{160}'
zstyle ':vcs_info:*' stagedstr '%F{226}'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '(%F{046}%c%u%b%f%f) '
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

# prompt
export NEWLINE=$'\n'
rightarrow=$(echo -en '\u25aa')
export PROMPT2=" ${rightarrow} "
export PROMPT='[%?] %F{069}%~% %f ${vcs_info_msg_0_} %f${NEWLINE}${PROMPT2}'


# history
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY

alias ls="ls --color=auto"
alias tree="tree -L 3 -C"
alias conf='function _(){ $EDITOR $HOME/.config/$1; }; _'
alias mv='mv --no-clobber'

alias sshuio='ssh -YC jonatahh@login.ifi.uio.no'
alias uiomount='sshfs jonatahh@login.ifi.uio.no:. ~/ifilokal'

