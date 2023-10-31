# vim: set ft=make :

# Update system, flatpaks, and containers all at once
update:
  #!/usr/bin/env bash
  if systemctl is-enabled ublue-update.timer | grep -q enabled;
  then
    echo "Starting the ublue-update service"
    sudo systemctl start ublue-update.service
  else
    rpm-ostree update
    flatpak update -y
    distrobox upgrade -a
  fi

# Update device firmware
update-firmware:
  fwupdmgr refresh --force
  fwupdmgr get-updates
  fwupdmgr update

# Disable all auto-update timers
disable-updates:
  #!/usr/bin/env bash
  if systemctl is-enabled ublue-update.timer | grep -q enabled;
  then
    sudo systemctl disable ublue-update.timer
  elif systemctl is-enabled flatpak-system-update.timer | grep -q enabled;
  then
    sudo systemctl disable --now flatpak-system-update.timer rpm-ostreed-automatic.timer
    systemctl disable --now --user flatpak-user-update.timer
  fi

# Enable all auto-update timers
enable-updates:
  #!/usr/bin/env bash
  if systemctl is-enabled ublue-update.timer | grep -q disabled;
  then
     sudo systemctl enable ublue-update.timer
  elif systemctl is-enabled flatpak-system-update.timer | grep -q disabled;
  then
    sudo systemctl enable --now flatpak-system-update.timer rpm-ostreed-automatic.timer
    systemctl enable --now --user flatpak-user-update.timer
  fi
