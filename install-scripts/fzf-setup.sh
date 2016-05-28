fzf_dir=$HOME'/.fzf'

if [ ! -d $fzf_dir ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi
