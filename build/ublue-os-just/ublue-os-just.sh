alias just="just --unstable"

# Add uBlue's justfiles to users with home directories which lack a justfile.

if [ ! -z "$HOME" ] && [ -d "$HOME" ] && [ ! -f "${HOME}/.justfile" ]; then
  cat > "${HOME}/.justfile" << EOF
!include /usr/share/ublue-os/just/main.just
!include /usr/share/ublue-os/just/nvidia.just
!include /usr/share/ublue-os/just/custom.just
EOF
fi
