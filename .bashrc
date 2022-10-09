# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


### Prompt
parse_git_branch() {
    # Output: "[{git-branch-name} "
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1/'
}
is_clean_git_dir() {
    if [[ $(parse_git_branch) ]]; then
        if output=$(git status --untracked-files=no --porcelain 2>/dev/null) && [ -z "$output" ]; then
            # Clean Output: "{GreenCheck} ]"
            /usr/bin/printf ' \[\e[1;32m\]\xE2\x9C\x93\[\e[0m\]]'
        else
            # Dirty Output: "{RedMark} ]"
            /usr/bin/printf ' \[\e[1;31m\]\xF0\x90\x84\x82\[\e[0m\]]'
        fi
    fi
}

build_prompt() {
    # Needs to be the first command so that it can successfully capture last command's exit status
    local RC="$?"
    # Text Reset
    local Reset='\[\e[0m\]'

    # Colors
    # Normal                      # Bold
    local Red='\[\e[0;31m\]';     local BRed='\[\e[1;31m\]';
    local Green='\[\e[0;32m\]';   local BGreen='\[\e[1;32m\]';
    local Blue='\[\e[0;34m\]';    local BBlue='\[\e[1;34m\]';
    local Cyan='\[\e[0;36m\]';    local BCyan='\[\e[1;36m\]';
    
    # Backup prompt
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

    # Show working directory with X number of levels 
    export PROMPT_DIRTRIM=2
    
    PS1='${debian_chroot:+($debian_chroot)}'
    PS1+="${BGreen}\u ${BCyan}\w${Reset}$(parse_git_branch)$(is_clean_git_dir) " 

    if [ $RC != 0 ]; then  # add arrow color dependent on exit code
        PS1+="${BRed}→${Reset} "
    else
        PS1+="${BGreen}→${Reset} "
    fi
}
PROMPT_COMMAND=build_prompt

#if [ "$color_prompt" = yes ]; then
#    PROMPT_COMMAND=build_prompt
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.dotfiles/.bash_aliases ]; then
    source ~/.dotfiles/.bash_aliases
fi

# Functions
if [ -f $HOME/.bash_functions ]; then
    source $HOME/.bash_functions
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Conda initialization
if [ -f "$HOME/.dotfiles/.miniconda3" ] ; then
    source $HOME/.dotfiles/.miniconda3
fi

# Autocomplete
if [ -f "$HOME/.dotfiles/.bash_autocomplete.sh" ]; then
    source "$HOME/.dotfiles/.bash_autocomplete.sh"
fi

