# vim: set ft=make :

# Use stock gamepad drivers
use-stock-gamepads:
  #!/usr/bin/env bash
  sudo bash -c '> /etc/modprobe.d/xone.conf'
  sudo bash -c '> /etc/modprobe.d/xpadneo.conf'
  sudo bash -c '> /etc/modprobe.d/xpad-noone-blacklist.conf'
  sudo bash -c '> /etc/modules-load.d/xpad-noone.conf'

# Use uBlue gamepad drivers (Default)
use-ublue-gamepads:
  #!/usr/bin/env bash
  sudo rm -f /etc/modprobe.d/xone.conf
  sudo rm -f /etc/modprobe.d/xpadneo.conf
  sudo rm -f /etc/modprobe.d/xpad-noone-blacklist.conf
  sudo rm -f /etc/modules-load.d/xpad-noone.conf

# Disable Broadcom WL driver (Default - WL breaks numerous other Wi-Fi adapters)
disable-broadcom-wl:
  #!/usr/bin/env bash
  sudo bash -c '> /etc/modules-load.d/broadcom-wl-blacklist.conf'
  sudo bash -c 'echo "blacklist wl" > /etc/modules-load.d/default-disable-broadcom-wl.conf'

# Use Broadcom WL driver
use-broadcom-wl:
  #!/usr/bin/env bash
  sudo rm -f /etc/modprobe.d/broadcom-wl-blacklist.conf
  sudo rm -f /etc/modprobe.d/default-disable-broadcom-wl.conf
