alias just="just --unstable"

# Add uBlue's justfiles to users with home directories which lack a justfile.

if [ ! -z "$HOME" ] && [ -d "$HOME" ] && [ ! -f "${HOME}/.justfile" ]; then
  cat > "${HOME}/.justfile" << EOF
!include /usr/share/ublue-os/just/00-default.just
!include /usr/share/ublue-os/just/10-update.just
!include /usr/share/ublue-os/just/20-clean.just
!include /usr/share/ublue-os/just/30-distrobox.just
!include /usr/share/ublue-os/just/40-nvidia.just
!include /usr/share/ublue-os/just/50-custom.just
EOF
fi
