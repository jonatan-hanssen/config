setopt dotglob
setopt COMPLETE_IN_WORD
setopt MENU_COMPLETE
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY

# autocompletion
autoload -U compinit && compinit
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache

# vi mode
bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

