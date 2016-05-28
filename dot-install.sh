#!/bin/sh
# fzf
source $HOME/dotfiles/install-scripts/fzf-setup.sh

# kerl & exenv
source ~/dotfiles/add/erl-env-setup.sh

# link install-basic dotfiles in home to the ones in this repo
source $HOME/dotfiles/install-scripts/dots.sh

exec $SHELL
