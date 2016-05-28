_work/
  Add unincorporated changes in here that is temporary or
  specific to a distro. For example, kerl & exenv needs
  commands in .bashrc to alter $PATH and init their env.
  Put it in _work/bash-extra and source it from the end
  of .bashrc.

copy/
  Everything that only needs to be copied to $HOME.

pebbles/
  Any dotfile/dir that needs to be backed up and needs a
  symlink in $HOME.

add/
  Config or supplemental files/dirs that can be referenced
  from where they are.

install-scripts/
  Install scripts that are sourced from dot-install.sh
