#!/bin/bash
source $HOME/dotfiles/install-scripts/fzf-setup.bash
source $HOME/dotfiles/install-scripts/node6x-install.bash
source $HOME/dotfiles/install-scripts/elm-install.bash

# kerl & exenv
source ~/dotfiles/add/erl-env-setup.bash

# link install-basic dotfiles in home to the ones in this repo
source $HOME/dotfiles/install-scripts/dots.bash

exec $SHELL
