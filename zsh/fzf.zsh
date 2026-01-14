source <(fzf --zsh)
bindkey '^N' fzf-history-widget # For Zsh
export FZF_DEFAULT_OPTS="--bind='j:down,k:up' --bind='start:unbind(i,a,j,k)' --bind='esc:disable-search+rebind(i,a,j,k)' --bind='i:enable-search+unbind(i,j,k)' --bind='a:enable-search+unbind(i,a,j,k)'"
