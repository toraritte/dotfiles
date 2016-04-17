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
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install




exec $SHELL
