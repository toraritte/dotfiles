# Create aliases for the dotfiles folder
files = ".bashrc .vimrc .bash_profile"

# Needed to avoid "__git_ps1 command not found" messages for the prompt in .bashrc
wget -O ./_work/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# Add the erl helper functions that I am "very" proud of
cp erlang/.erlang ~
