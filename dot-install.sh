# Create aliases for the dotfiles folder
files = ".bashrc .vimrc .bash_profile"
mkdir .old

for f in files
do
  mv ~/$f ~/.old

# Add the erl helper functions that I am "very" proud of
cp -rv erlang/.erlang ~

# mc shortcuts
cp -rv .config ~

# fzf
source add/fzf-setup.sh
exec $SHELL
