# vim: set ft=make :

# Configure gamepad drivers
configure-gamepads:
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}Configuring gamepad drivers${normal}"
    echo 'uBlue (default and good for official controllers):'
    echo ' - xpad-noone (xpad without Xbox One support), xpadneo, xone'
    echo 'Stock:'
    echo ' - Xbox one support and fixes a lot of third party controllers'
    echo 'Which driver do you want to use?'
    OPTION=$(ugum choose uBlue Stock)
    if [ "$OPTION" == "uBlue" ]; then
      sudo rm -f /etc/modprobe.d/xone.conf
      sudo rm -f /etc/modprobe.d/xpadneo.conf
      sudo rm -f /etc/modprobe.d/xpad-noone-blacklist.conf
      sudo rm -f /etc/modules-load.d/xpad-noone.conf
    elif [ "$OPTION" == "Stock" ]; then
      sudo bash -c '> /etc/modprobe.d/xone.conf'
      sudo bash -c '> /etc/modprobe.d/xpadneo.conf'
      sudo bash -c '> /etc/modprobe.d/xpad-noone-blacklist.conf'
      sudo bash -c '> /etc/modules-load.d/xpad-noone.conf'
    else
      echo 'Exiting...'
      exit 0
    fi

# Configure Broadcom WL driver (Enabling WL breaks numerous other Wi-Fi adapters)
configure-broadcom-wl:
    #!/usr/bin/env bash
    echo 'Enabling Broadcom WL driver will break numerous other Wi-Fi adapters.'
    echo 'Enable or Disable Broadcom Wl?'
    OPTION=$(ugum choose Enable Disable)
    if [ "$OPTION" == "Enable" ]; then
      sudo rm -f /etc/modprobe.d/broadcom-wl-blacklist.conf
      sudo rm -f /etc/modprobe.d/default-disable-broadcom-wl.conf
    elif [ "$OPTION" == "Disable" ]; then
      sudo bash -c '> /etc/modules-load.d/broadcom-wl-blacklist.conf'
      sudo bash -c 'echo "blacklist wl" > /etc/modules-load.d/default-disable-broadcom-wl.conf'
    else
      echo 'Exiting...'
      exit 0
    fi
