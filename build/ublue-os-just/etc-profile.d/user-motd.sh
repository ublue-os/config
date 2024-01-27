if test -d "$HOME"; then
  if test ! -e "$HOME"/.config/no-show-user-motd; then
    if test -s "/usr/share/ublue-os/user-motd"; then
      cat /usr/share/ublue-os/user-motd
    fi
  fi
fi