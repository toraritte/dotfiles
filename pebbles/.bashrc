# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

. /home/toraritte/.nix-profile/etc/profile.d/nix.sh

# If not running interactively, don't do anything
# ... aaand what the hell this check means and why
#     it matters
# http://unix.stackexchange.com/questions/257571/why-does-bashrc-check-whether-the-current-shell-is-interactive
case $- in
    *i*) ;;
      *) return;;
esac

# set the title of a terminal window/tab
set-title(){
  ORIG=$PS1
  TITLE="\e]2;$@\a"
  PS1=${ORIG}${TITLE}
}

# unified bash history
# HIT ENTER FIRST IF LAST COMMAND IS NOT SEEN IN ANOTHER WINDOW
# http://superuser.com/questions/37576/can-history-files-be-unified-in-bash
shopt -s histappend # man shopt
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r" # help history

# glob hidden files too with *
shopt -s dotglob

# don't put duplicate lines in the history.
HISTCONTROL=ignoredups # man bash
HISTSIZE=200000
HISTFILESIZE=200000
HISTTIMEFORMAT='%Y/%m/%d-%H:%M	'

# make sure that tmux uses the right variable in order to
# display vim colors correctly
TERM="screen-256color"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# GIT STATUS IN BASH PROMPT
source ~/dotfiles/add/git-prompt.sh
# add git completion
git_completion_file=~/git-completion.bash
if [ ! -f $git_completion_file ]; then
  (cd ~ && curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash)
fi
source $git_completion_file
# + for staged, * if unstaged.
GIT_PS1_SHOWDIRTYSTATE=1¬
# $ if something is stashed.
GIT_PS1_SHOWSTASHSTATE=1¬
# % if there are untracked files.
GIT_PS1_SHOWUNTRACKEDFILES=1¬
# <,>,<> behind, ahead, or diverged from upstream.
GIT_PS1_SHOWUPSTREAM=1

# bash prompt
# "She's saying ... a bunch of stuff. Look, have you tried drugs?"
PS1='\[\e[33m\]$(__git_ps1 "%s") \[\e[m\]\[\e[32m\]\u@\h \[\e[m\] \[\e[01;30m\][\w]\[\033[0m\]\n\j \[\e[01;30m\][\t]\[\033[0m\] '

##################################
### ALIASES ######################
##################################

# In Fedora there is a hitch with vim so this an
# alias to gvim is needed.
if grep --quiet fedora /etc/*release; then
  alias vim='gvim -v'
fi

alias ll='ls -alF --group-directories-first --color'
alias g='egrep --colour=always -i'
alias ag='ag --hidden'
alias b='bc -lq'
alias dt="date +%Y/%m/%d-%H:%M"
alias r='fc -s' # repeat the last command
alias tmux='tmux -2' # make tmux support 256 color
alias ag='ag --hidden'
alias gl='git v --color=always | less -r'
alias ga='git van --color=always | less -r'
alias gd='git vn --color=always | less -r'
alias glh="gl | head"
alias gah="ga | head"
alias gdh="gd | head"

# http://www.gnu.org/software/bash/manual/bashref.html#Special-Parameters
tl() {
  tree -C $@ | less -R
}

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

# export PATH="$HOME/aplaceholderforthefuture:$PATH"
export PATH="$HOME/.kerl:$HOME/.exenv/bin:$HOME/dotfiles:$PATH"
export EDITOR=$(which vim)
export MANWIDTH=80
# for the vim-fzf plugin to list hidden files as well
# but the previous commands are still needed because
# fzf in bash is set up differently
export FZF_DEFAULT_COMMAND='find .'

set -o vi

# Cleanup after dot-install is finished
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
if command -v fzf-share >/dev/null; then
  source "/home/toraritte/dotfiles/copy/.fzf/shell/key-bindings.bash"
  # source "$(fzf-share)/key-bindings.bash"
fi

# https://bbs.archlinux.org/viewtopic.php?id=129992
# I had an issue with iex and this solved it
export LANG=en_US.UTF-8
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# export LC_MESSAGES="C"

export ERL_AFLAGS="-kernel shell_history enabled"

# The next line updates PATH for the Google Cloud SDK.
if [ -f /home/toraritte/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/home/toraritte/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /home/toraritte/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/home/toraritte/Downloads/google-cloud-sdk/completion.bash.inc'
fi

source $HOME/.nix-profile/etc/profile.d/nix.sh
