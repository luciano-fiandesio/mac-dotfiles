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

# docker
abbr d docker
abbr dc "docker compose"
abbr -a -g dcup 'docker compose up -d'
abbr -a -g dcd 'docker compose down'
abbr -a -g dl 'docker logs'
abbr -a -g dps 'docker ps'

# python + uv
abbr uvsa "source .venv/bin/activate"

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
alias msk 'mvn clean install -DskipTests'

## MISC

alias b="git branch | fzf | xargs git checkout"

## Kube
alias k="kubectl"

# aichat - https://github.com/sigoden/aichat
abbr ai aichat -e

# unix
abbr -a -g c 'clear'
abbr -a -g df 'df -h'
abbr -a -g du 'du -h'
abbr -a -g dud 'du -d 1 -h'
abbr -a -g duf 'du -sh *'
abbr -a -g cat 'bat'
abbr -a -g cp 'gcp -iv'
abbr -a -g l 'ls -lhF --git'
abbr -a -g mkdir 'mkdir -pv'
abbr -a -g mv 'mv -iv'

# claude code
abbr -a -g cl 'claude'
abbr -a -g clsp 'claude --dangerously-skip-permissions'
abbr -a -g clh 'claude --help'
abbr -a -g clv 'claude --version'
abbr -a -g clr 'claude --resume'
abbr -a -g clc 'claude --continue'
abbr -a -g clp 'claude --print'
abbr -a -g clcp 'claude --continue --print'
abbr -a -g clup 'claude update'
abbr -a -g clmcp 'claude mcp'
