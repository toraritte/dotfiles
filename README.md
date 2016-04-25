copy/
  Everything that only needs to be copied to ~

pebbles/
  Any dotfile and config directory that needs to be backed up
  and needs a symlink.

pebbles/.vim/
  Any static files that only needs to be copied to the active
  .vim directory. (E.g., colorscheme etc)

add/
  Modules for ./dot-install.sh
  
add/git-prompt.sh
  Sourced in ./.bashrc to enable git completion in bash

add/fzf-setup.sh
  Sourced in ./dot-install.sh
