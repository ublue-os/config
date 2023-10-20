alias just="just --unstable"

# Add uBlue's justfiles to users with home directories which lack a justfile.

if [ ! -z "$HOME" ] && [ -d "$HOME" ] && [ ! -f "${HOME}/.justfile" ]; then
  cat > "${HOME}/.justfile" << EOF
!include /usr/share/ublue-os/justfile
EOF
fi

if [ -f "${HOME}/.justfile" ]; then
  if ! grep -Fxq '!include /usr/share/ublue-os/justfile' "${HOME}/.justfile"; then
    # Remove any lines we may have added previously.
    sed -i '/!include \/usr\/share\/ublue-os\/just\/.*.just/d' "${HOME}/.justfile"

    # Point to the new main justfile, place it as the first line
    echo '# You can add your own commands here! For documentation, see: https://ublue.it/guide/just/' | tee -a "${HOME}/.justfile"
    echo '!include /usr/share/ublue-os/justfile' | tee -a "${HOME}/.justfile"
  fi
fi
