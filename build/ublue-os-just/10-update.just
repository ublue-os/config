# vim: set ft=make :

# Update system, flatpaks, and containers all at once
update:
  rpm-ostree update
  flatpak update -y
  distrobox upgrade -a

# Update device firmware
update-firmware:
  fwupdmgr refresh
  fwupdmgr get-updates
  fwupdmgr update

# Disable all auto-update timers
disable-updates:
  sudo systemctl disable --now flatpak-system-update.timer rpm-ostreed-automatic.timer
  systemctl disable --now --user flatpak-user-update.timer

# Enable all auto-update timers
enable-updates:
  sudo systemctl enable --now flatpak-system-update.timer rpm-ostreed-automatic.timer
  systemctl enable --now --user flatpak-user-update.timer