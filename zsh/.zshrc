autoload -U compinit promptinit colors
compinit
promptinit
colors

setopt NO_BEEP
PROMPT="%n@%m:%F{yellow}%~ %f%# "
export TERM="xterm-256color"
export EDITOR='nvim'

# Vim keys
bindkey -v
export KEYTIMEOUT=1

bindkey "^[b" backward-word
bindkey "^[f" forward-word

# History
HISTFILE=~/.zshhistory
SAVEHIST=10000
HISTSIZE=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Aliases
alias la='ls -AlhFG'
alias ls='ls -hG'

export PATH=/Users/antonbabenko/Library/Python/3.9/bin:$PATH
