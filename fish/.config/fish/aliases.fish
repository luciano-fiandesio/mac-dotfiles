# Navigation

function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# Utilities
function grep     ; command grep --color=auto $argv ; end
function g ; git $argv ; end

# mv, rm, cp
alias mv 'command gmv --interactive --verbose'
alias rm 'command grm --interactive --verbose'
alias cp 'command gcp --interactive --verbose'

alias chmox='chmod +x'

# typos and abbreviations
abbr g git
abbr gi git
abbr gti git
abbr v vim
abbr rm rip # use rip (https://github.com/nivekuil/rip) instead of rm
            # (experimental)
abbr frm 'rm -fr'

# Docker
abbr d docker
abbr dc "docker compose"

alias ls='lsd' # use LSDeluxe (https://github.com/Peltoche/lsd)
alias ll='ls -la'
alias l='ls -l'
alias lla='ls -la'
alias lt='ls --tree'
alias llt='lsd -tal'
alias cat='bat'
alias ss='hub sync'

alias vim='nvim'
alias v='vim'
alias hosts='sudo $EDITOR /etc/hosts'

## DEV
alias msk 'mvn clean install -Dmaven.test.skip=true'

## MISC

alias b="git branch | fzf | xargs git checkout"

## Kube
alias k="kubectl"

# aichat - https://github.com/sigoden/aichat
abbr ai aichat -e

## cheat.sh
abbr cs cht.sh
