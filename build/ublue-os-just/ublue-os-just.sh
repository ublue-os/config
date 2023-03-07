# Add justfile to HOME if it's not already installed

if [[ ! -f "${HOME}/.justfile" && -f /usr/share/ublue-os/ublue-os-just/justfile ]]; then
  cp /usr/share/ublue-os/ublue-os-just/justfile "${HOME}/.justfile"
fi

