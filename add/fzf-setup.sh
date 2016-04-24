git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
cp .fzf/shell/key-bindings.bash ~/.fzf/shell/
# for the vim-fzf plugin to list hidden files as well
# but the previous commands are still needed because
# fzf in bash is set up differently
export FZF_DEFAULT_COMMAND='find .'
