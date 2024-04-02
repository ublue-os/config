# vim: set ft=make :

alias broadcom-wl := configure-broadcom-wl

# Configure Broadcom WL driver (Enabling WL breaks numerous other Wi-Fi adapters)
configure-broadcom-wl ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
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

# Configure/Add Fido/Yubi key to an Encrypted disk with key priority 
fido2:
    #!/usr/bin/bash
    if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
    fi
    clear; lsblk
    ## find default devices
    device='/dev/'$(lsblk -r --fs | grep crypto | awk '{print $1}')
    luks=$(lsblk -r --fs | grep luks | awk '{print $1}')
    echo " _______________________"
    echo Your device is $device
    echo Your crypto volume is $luks
    # add custom values if needed
    read -p "are these values correct? y/n" yn
    case $yn in
        [Nn]* ) read -p "enter the device volume? " device ; read -p "Enter value for luks volume " luks;;
    esac
    ## make sure custom value has /dev added
    [[ $device = */dev/* ]] || device=/dev/$device
    clear; lsblk
    echo Your device is $device
    echo Your crypto volume is $luks
    ## enroll a key
    read -p "do you need to enrol a new key?  if yes insert key before answering  y/n " yn
    case $yn in
        [Yy]* ) systemd-cryptenroll --fido2-device=auto --fido2-with-user-verification=true $device;;
        *) echo "not enrolling a new key" ;;
    esac
    ### edit the crypttab like for the luks volume if needed
    luksline=$(grep -r $luks /etc/crypttab)
    if [[ ! "$luksline" = *"fido2-device"* ]] ; then
        opts=$(echo $luksline | awk '{print $4}')
        newopts=$(echo $luksline | sed "s/$opts/fido2-device=auto,$opts/g")
        sed -i "s/$luksline/$newopts/g" /etc/crypttab
        echo "updated crypttab with fido"
    fi
    ### sets the password to not be used unless a key is not present
    read -p "Set the new key as the sufficient auth method? y/n " yn
    case $yn in
        [Yy]* ) cryptsetup config --key-slot 0 --priority ignore $device ; cryptsetup config --key-slot 1 --priority prefer $device;;
        *) echo "leaving slot priorities the same" ;;
    esac
    ## show deplyments to see custom initramfs options,
    rpm-ostree status
    ## rebuilds the initramfs with --fido2 then shows deployments to confirm the change
    read -p "Rebuild initramfs with fido module ? y/n " yn
    case $yn in
        [Yy]* ) rpm-ostree initramfs --enable --arg='--add' --arg='fido2' ; clear ; rpm-ostree status;;
        *) echo "initramfs not rebuilding" ;;
    esac
    echo "Fido2 setup complete,  next reboot will ask for a key"
