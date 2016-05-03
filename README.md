_work/
  Add unincorporated changes in here, such as kerl, exenv etc needs to alter the path, add extra commands in .bashrc.

copy/
  Everything that only needs to be copied to ~

copy/.vim/
  Any static files that only needs to be copied to the active
  .vim directory. (E.g., colorscheme etc)

pebbles/
  Any dotfile and config directory that needs to be backed up
  and needs a symlink.

pebbles/.vim/
  Dynamic content for vim, such as plugins installed on first
  startup, etc.

add/
  Modules for ./dot-install.sh

add/git-prompt.sh
  Sourced in ./.bashrc to enable git completion in bash

add/fzf-setup.sh
  Sourced in ./dot-install.sh
