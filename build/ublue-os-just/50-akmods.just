# vim: set ft=make :

alias gamepads := configure-gamepads

# Configure gamepad drivers
configure-gamepads ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/libjust.sh
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "${bold}Configuring gamepad drivers${normal}"
      echo 'Which drivers do you want to use?'
      echo 'Note: Enabling xone and xpadneo can break some 3rd party controllers'
      OPTION=$(ugum choose "Default Fedora drivers" "Enable xone and xpadneo")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust configure-gamepads <option>"
      echo "  <option>: Specify the quick option - 'stock' or 'ublue'"
      echo "  Use 'stock' to select Default Fedora Drivers"
      echo "  Use 'ublue' to select Enable xone and xpadneo"
      exit 0
    fi
    if [ "$OPTION" == "Enable xone and xpadneo" ] || [ "$OPTION" == "ublue" ]; then
      sudo rm -f /etc/modprobe.d/xone.conf
      sudo rm -f /etc/modprobe.d/xpadneo.conf
      sudo rm -f /etc/modprobe.d/xpad-noone-blacklist.conf
      sudo rm -f /etc/modules-load.d/xpad-noone.conf
      echo "${bold}Enabled${normal} xone and xpadneo, please reboot for changes to take effect"
    elif [ "$OPTION" == "Default Fedora drivers" ] || [ "$OPTION" == "stock" ]; then
      sudo bash -c '> /etc/modprobe.d/xone.conf'
      sudo bash -c '> /etc/modprobe.d/xpadneo.conf'
      sudo bash -c '> /etc/modprobe.d/xpad-noone-blacklist.conf'
      sudo bash -c '> /etc/modules-load.d/xpad-noone.conf'
      echo "${bold}Disabled${normal} xone and xpadneo, please reboot for changes to take effect"
    fi

alias broadcom-wl := configure-broadcom-wl

# Configure Broadcom WL driver (Enabling WL breaks numerous other Wi-Fi adapters)
configure-broadcom-wl ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/libjust.sh
    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "${bold}Configuring Broadcom Wi-Fi${normal}"
      echo 'Enabling Broadcom WL driver will break numerous other Wi-Fi adapters.'
      echo 'Enable or Disable Broadcom Wl?'
      OPTION=$(ugum choose Enable Disable)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust configure-broadcom-wl <option>"
      echo "  <option>: Specify the quick option - 'enable' or 'disable'"
      echo "  Use 'enable' to select Enable"
      echo "  Use 'disable' to select Disable"
      exit 0
    fi
    if [ "${OPTION,,}" == "enable" ]; then
      sudo rm -f /etc/modprobe.d/broadcom-wl-blacklist.conf
      sudo rm -f /etc/modprobe.d/default-disable-broadcom-wl.conf
      echo "${bold}Enabled${normal} Broadcom Wireless, please reboot for changes to take effect"
    elif [ "${OPTION,,}" == "disable" ]; then
      sudo bash -c '> /etc/modules-load.d/broadcom-wl-blacklist.conf'
      sudo bash -c 'echo "blacklist wl" > /etc/modules-load.d/default-disable-broadcom-wl.conf'
      echo "${bold}Disabled${normal} Broadcom Wireless, please reboot for changes to take effect"
    fi
