# git
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
typeset -a precmd_functions
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' unstagedstr '%F{red}'
zstyle ':vcs_info:*' stagedstr '%F{magenta}'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '(%F{green}%c%u%b%f%f) '
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

# prompt
export NEWLINE=$'\n'
rightarrow=$(echo -en '\u25aa')
export PROMPT2=" ${rightarrow} "
export PROMPT='[%?] %F{blue}%~% %f ${vcs_info_msg_0_} %f${NEWLINE}${PROMPT2}'

if command -v catimg >/dev/null 2>&1; then
    catimg -w 100 $XDG_CONFIG_HOME/zsh/cat.jpg
    echo "                Erm, what the flip?"
fi
