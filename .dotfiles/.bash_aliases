#!/bin/bash

# Put all your aliases here

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# cd
alias ..='cd ..'

# ls
alias ll='ls -aClF --human-readable'
alias la='ls -A'
alias l='ls -alF --human-readable'
alias lt='ls --human-readable --size -1 -S --classify'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Git
alias gs='git status'

# Hacks
alias myalias="vim $HOME/.dotfiles/.bash_aliases"
alias count='find . -type f | wc -l' # Recursively count number of files in directory

# To track dotfiles under $HOME
alias dgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# os-release
alias os-release='cat /etc/os-release'
