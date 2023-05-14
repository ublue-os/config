# Add uBlue's justfiles to users with home directories which lack a justfile.

if [ ! -z "$HOME" ] && [ -d "$HOME" ] && [ ! -f "${HOME}/.justfile" ]; then
  UBLUE_JUST=/usr/share/ublue-os/just
  USER_JUSTFILE="${HOME}/.justfile"
  touch "${USER_JUSTFILE}"
  if [ -f ${UBLUE_JUST}/main.just ]; then
    cat ${UBLUE_JUST}/main.just >> "${USER_JUSTFILE}"
  fi
  if [ -f ${UBLUE_JUST}/nvidia.just ] && [ rpm -q ublue-os-nvidia-addons ]; then
    cat ${UBLUE_JUST}/nvidia.just >> "${USER_JUSTFILE}"
  fi
  if [ -f ${UBLUE_JUST}/custom.just ]; then
    cat ${UBLUE_JUST}/custom.just >> "${USER_JUSTFILE}"
  fi
fi

