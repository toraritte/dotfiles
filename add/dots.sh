backupdir=".old-dots/"$(date +%Y%m%d-%H%M)
pebbles=$(ls -A pebbles/)

mkdir -p ~/$backupdir

for p in $pebbles; do
  p_path="pebbles/"$p
  if [[ -d $p_path ]]
    then
      cp -r $p_path ~
    else
      mv ~/$p ~/$backupdir 2> /dev/null
      ln -s {dotfiles/pebbles/,~/}$p
  fi
done

