set -g fish_greeting

if status is-interactive
    starship init fish | source
end

function fish_right_prompt
    mommy -1 -s $status
end

# List Directory
alias l='eza -lh  --icons=auto' # long list
#alias ls='eza -1   --icons=auto' # short list
alias ls='lsd'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias quit='exit'
alias vi='nvim'
alias vim='nvim'
alias n='nvim'

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
abbr ..... 'cd ../../../..'
abbr ...... 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

# load rbenv
status --is-interactive; and rbenv init - fish | source

# Created by `pipx` on 2024-10-06 19:22:26
set PATH $PATH /home/raumsegler/.local/bin

export PATH="$PATH:/home/raumsegler/go/bin"

