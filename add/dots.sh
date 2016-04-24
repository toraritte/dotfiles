backupdir=".old-dots/"$(date +%Y%m%d-%H%M)
pebbles=".bashrc .vimrc .gitconfig .erlang"

mkdir -p ~/$backupdir

for p in $pebbles; do
  mv ~/$p ~/$backupdir 2> /dev/null
  ln -s {dotfiles/pebbles/,~/}$p
done

