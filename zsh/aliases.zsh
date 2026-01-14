
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
alias ns="git status"
alias nsu="git status -uno"
alias nc="git commit -s"
alias ncm="git commit -sm"
alias na="git add"
alias nau="git add -u"
alias np="git push"
alias nd="git diff"
alias nr="git restore"
alias npl="git pull"

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
alias a='source a'
alias s='z' # s is for search
alias e='nvim' # e is for edit
alias t='cd' # t is for to
alias i='ls' # i is for info

# this is kinda crazy right guys
alias snipwatch='nvim -u ~/.config/nvim/sniprun_init.lua ~/.local/share/nvim/sniprun_output'

alias rt='ranger-cd'
alias ra='ranger'
