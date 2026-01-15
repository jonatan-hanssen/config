# aliases
alias ls="exa --icons --time-style=long-iso"
alias tree="tree -L 3 -C"
alias mv='mv --interactive'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'


# git aliases
alias ns="git status"
alias nsu="git status -uno"
alias nc="git commit -s"
alias ncm="git commit -sm"
alias na="git add"
alias nau="git add -u"
alias np="git push"
alias npu="git push --set-upstream origin \$(git branch --show-current)"
alias npl="git pull"
alias nd="git diff"
alias nr="git restore"
alias nrs="git restore --staged"
alias nch="git checkout"
alias nl="git log --stat"

# python aliases
alias python='python3'
alias pip='pip3'
alias py="python3 -q"
alias pdb="python3 -m pdb"
alias act='source env/bin/activate'

alias ra='ranger'
alias rt='ranger-cd'
alias close='disown && exit'

# god tier single char aliases
alias a='source a'
alias s='z' # s is for search
alias e='nvim' # e is for edit
alias t='cd' # t is for to
alias i='ls' # i is for info

# this is kinda crazy right guys
alias snipwatch='nvim -u ~/.config/nvim/sniprun_init.lua ~/.local/share/nvim/sniprun_output'

alias commits='echo "(build|bump|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)"'
