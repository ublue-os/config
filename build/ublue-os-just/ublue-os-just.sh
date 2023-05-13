# Add uBlue's justfiles to user HOME if they don't already have a justfile.

UBLUE_JUST=/usr/share/ublue-os/just
USER_JUSTFILE="${HOME}/.justfile"
if [ ! -f "${USER_JUSTFILE}" ]; then
  if [ -f ${UBLUE_JUST}/main.just ]; then
    cp ${UBLUE_JUST}/main.justfile "${USER_JUSTFILE}"
  fi
  if [ -f ${UBLUE_JUST}/nvidia.just ] && [ rpm -q xorg-x11-drv-nvidia ]; then
    cat ${UBLUE_JUST}/nvidia.just >> "${USER_JUSTFILE}"
  fi
  if [ -f ${UBLUE_JUST}/custom.just ]; then
    cat ${UBLUE_JUST}/custom.just >> "${USER_JUSTFILE}"
  fi
fi

