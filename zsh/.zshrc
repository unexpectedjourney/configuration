autoload -U compinit promptinit colors
compinit
promptinit
colors

setopt NO_BEEP
PROMPT="%n@%m:%F{yellow}%~ %f%# "
export TERM="xterm-256color"
export EDITOR='nvim'

bindkey -v
export KEYTIMEOUT=1

bindkey "^[b" backward-word
bindkey "^[f" forward-word

alias la='ls -AlhFG'
alias ls='ls -hG'
