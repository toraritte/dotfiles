# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# ... aaand what the hell this check means and why
#     it matters
# http://unix.stackexchange.com/questions/257571/why-does-bashrc-check-whether-the-current-shell-is-interactive
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
HISTSIZE=200000
HISTFILESIZE=200000
HISTTIMEFORMAT='%Y/%m/%d-%H:%M	'

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

# + for staged, * if unstaged.¬
GIT_PS1_SHOWDIRTYSTATE=1¬
# $ if something is stashed.¬
GIT_PS1_SHOWSTASHSTATE=1¬
# % if there are untracked files.¬
GIT_PS1_SHOWUNTRACKEDFILES=1¬
# <,>,<> behind, ahead, or diverged from upstream.¬
GIT_PS1_SHOWUPSTREAM=1
PS1='`if [ $? = 0 ]; then echo "\[\033[1;32m\]✔"; else echo "\[\033[1;31m\]✘"; fi`\[\033[0m\] \[\033[32m\][\j]\[\033[0m\] \[\e[33m\]$(__git_ps1 "%s") \[\e[m\]\[\e[32m\][\w] \[\e[m\] \n\[\e[01;30m\][\!] \t \[\033[0m\]'

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

# some more aliases
alias lh='ls -alhF'
alias ll='ls -alF --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
alias g='egrep --colour -i'
alias b='bc -lq'
alias ag='ack-grep -i'
alias h='history | less'
alias dt="date +%Y/%m/%d-%H:%M"
alias r='fc -s'
alias tagup="sudo updatedb && locate -b '\tags' > dotfiles/tagdb"
alias lvim='vim -c "normal '\''0"'
alias trls='tree -C | less -R'	# -C outputs colour, -R makes less understand color
alias n='ncmpcpp'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias x='xdg-open'
alias griva='cd feellikearealsoldier/grive_sync/;(grive  &> .out; notify-send --urgency=critical "griven ended with $?") &'
alias xss='xscreensaver-command -activate'
# make tmux support 256 color
alias tmux='tmux -2'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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


export GOPATH=$HOME/gopath
export PATH="$HOME/.rbenv/bin:$HOME/local/src/rebar:$PATH"
eval "$(rbenv init -)"
export EDITOR=/usr/bin/vim
export MANWIDTH=80


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

set -o vi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

PATH=$PATH:$HOME/.local/bin # Add custom bins to PATH
export PATH="$HOME/.exenv/bin:$PATH"
eval "$(exenv init -)"
