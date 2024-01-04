# vim: set ft=make :

# Configure gamepad drivers
configure-gamepads:
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}Configuring gamepad drivers${normal}"
    echo 'Which drivers do you want to use?'
    echo 'Note: Enabling xone and xpadneo can break some 3rd party controllers'
    OPTION=$(ugum choose "Default Fedora drivers" "Enable xone and xpadneo" )
    if [ "$OPTION" == "Enable xone and xpadneo" ]; then
      sudo rm -f /etc/modprobe.d/xone.conf
      sudo rm -f /etc/modprobe.d/xpadneo.conf
      sudo rm -f /etc/modprobe.d/xpad-noone-blacklist.conf
      sudo rm -f /etc/modules-load.d/xpad-noone.conf
    elif [ "$OPTION" == "Default Fedora drivers" ]; then
      sudo bash -c '> /etc/modprobe.d/xone.conf'
      sudo bash -c '> /etc/modprobe.d/xpadneo.conf'
      sudo bash -c '> /etc/modprobe.d/xpad-noone-blacklist.conf'
      sudo bash -c '> /etc/modules-load.d/xpad-noone.conf'
    fi

# Configure Broadcom WL driver (Enabling WL breaks numerous other Wi-Fi adapters)
configure-broadcom-wl:
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}Configuring Broadcom Wi-Fi${normal}"
    echo 'Enabling Broadcom WL driver will break numerous other Wi-Fi adapters.'
    echo 'Enable or Disable Broadcom Wl?'
    OPTION=$(ugum choose Enable Disable)
    if [ "$OPTION" == "Enable" ]; then
      sudo rm -f /etc/modprobe.d/broadcom-wl-blacklist.conf
      sudo rm -f /etc/modprobe.d/default-disable-broadcom-wl.conf
    elif [ "$OPTION" == "Disable" ]; then
      sudo bash -c '> /etc/modules-load.d/broadcom-wl-blacklist.conf'
      sudo bash -c 'echo "blacklist wl" > /etc/modules-load.d/default-disable-broadcom-wl.conf'
    fi
