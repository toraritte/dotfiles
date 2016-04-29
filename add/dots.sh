backupdir=".old-dots/"$(date +%Y%m%d-%H%M)
pebbles=$(ls -A ~/dotfiles/pebbles/)
copy=$(ls -A ~/dotfiles/copy/)

mkdir -p ~/$backupdir

for p in $pebbles; do
  mv ~/$p ~/$backupdir 2> /dev/null
  [[ $p != *swp ]] && ln -s {~/dotfiles/pebbles/,~/}$p
done

for c in $copy; do
  [[ $c != .vim ]] && cp -rv ~/dotfiles/copy/$c ~
done

