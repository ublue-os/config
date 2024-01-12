# vim: set ft=make :

uid := `id -u`
shell := `grep :$(id -u): /etc/passwd | cut -d: -f7`

# Boot into this device's BIOS/UEFI screen
bios:
    systemctl reboot --firmware-setup

# Show all messages from this boot
logs-this-boot:
    sudo journalctl -b 0

# Show all messages from last boot
logs-last-boot:
    sudo journalctl -b -1

# Change the user's shell
chsh new_shell:
    #!/usr/bin/bash
    set -euo pipefail
    if [ "{{ shell }}" = "{{ new_shell }}" ] ; then
      printf "Your shell is already set to %s.\n" "{{ new_shell }}"
    else
      if [ -x "{{ new_shell }}" ] ; then
        sudo usermod $USER --shell "{{ new_shell }}"
        printf "%s's shell is now %s.\n" "$USER" "{{ new_shell }}"
      else
        echo "{{ new_shell }} does not exist or is not executable!"
      fi
    fi

# Regenerate GRUB config, useful in dual-boot scenarios where a second operating system isn't listed
regenerate-grub:
    #!/usr/bin/bash
    if [ -d /sys/firmware/efi ]; then
      sudo grub2-mkconfig -o /etc/grub2-efi.cfg
    else
      sudo grub2-mkconfig -o /etc/grub2.cfg
    fi

# Show the changelog
changelogs:
    rpm-ostree db diff --changelogs

# Enroll Nvidia driver & KMOD signing key for secure boot - Enter password "ublue-os" if prompted
enroll-secure-boot-key:
    echo 'Enter password "ublue-os" if prompted after your user password.'
    sudo mokutil --timeout -1
    sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der
    echo 'When you reboot your computer, follow the instructions to start MOK util'
    echo 'by pressing a key, then enroll the secure boot key and enter "ublue-os" as the password'

# Install or uninstall distrobox-git
setup-distrobox-git:
    #!/usr/bin/bash
    echo 'Which version of Distrobox do you want to use?'
    OPTION=$(ugum choose "Latest distrobox-git snapshot" "uBlue provided version")
    if [ "$OPTION" == "Latest distrobox-git snapshot" ]; then
      echo 'Installing latest git snapshot of Distrobox...'
      curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --next --prefix ~/.local
    elif [ "$OPTION" == "uBlue provided version" ]; then
      echo 'Uninstalling latest git snapshot of Distrobox...'
      curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/uninstall | sh -s -- --prefix ~/.local
    else
      echo 'Cancelling...'
      exit 0
    fi

# Removes homebrew from system
remove-brew:
    echo "Removing homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
