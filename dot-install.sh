# link install-basic dotfiles in home to the ones in this repo
source add/dots.sh

# Add the erl helper functions that I am "very" proud of
cp -rv erlang/.erlang ~

# mc shortcuts
cp -rv .config ~

# fzf
source add/fzf-setup.sh

# vim
source add/vim-setup.sh


exec $SHELL
