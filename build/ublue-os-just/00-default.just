# vim: set ft=make :

uid := `id -u`
shell := `grep :$(id -u): /etc/passwd | cut -d: -f7`

# Boot into this device's BIOS/UEFI screen
bios:
    #!/usr/bin/bash
    if [ -d /sys/firmware/efi ]; then
      systemctl reboot --firmware-setup
    else
      echo "Rebooting to legacy BIOS from OS is not supported."
    fi

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

alias brew := install-brew

# Install Homebrew | https://brew.sh
install-brew:
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    if [[ ! -f "/var/home/linuxbrew/.linuxbrew/bin" || ! -x "/var/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        echo "${b}Brew Installation${n}"
        echo "Please ${b}IGNORE${n} everything the installer tells you to do at the end"
        echo "We have already done it for you! You just need to close and re-open the terminal after installation"
        echo "Do you understand?"
        echo "Please type in \"YES I UNDERSTAND\" and press enter"
        read ACCEPT
        if [ "$ACCEPT" == "YES I UNDERSTAND" ]; then
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
          echo "Capitalization matters when you type \"YES I UNDERSTAND\""
        fi
    fi
    # if /etc/profile.d/brew.sh already exists, replace it with /usr/etc/profile.d/brew.sh
    if [ -f /etc/profile.d/brew.sh ]; then
        if [ -f /usr/etc/profile.d/brew.sh ]; then
            sudo cp /usr/etc/profile.d/brew.sh /etc/profile.d/brew.sh
        fi
    fi

# Removes homebrew from system
remove-brew:
    echo "Removing homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# Toggle display of the user-motd in terminal
toggle-user-motd:
    #!/usr/bin/bash
    if test -e "${HOME}/.config/no-show-user-motd"; then
      rm -f "${HOME}/.config/no-show-user-motd"
    else
      if test ! -d "${HOME}/.config"; then
        mkdir "${HOME}/.config"
      fi
      touch "${HOME}/.config/no-show-user-motd"
    fi

# Enable xwaylandvideobridge
fix-screenshare:
    cp /usr/share/applications/org.kde.xwaylandvideobridge.desktop $HOME/.config/autostart/

# Check for local overrides
check-local-overrides:
    #!/usr/bin/bash
    diff -r \
      --suppress-common-lines \
      --color="always" \
      --exclude "passwd*" \
      --exclude "group*" \
      --exclude="subgid*" \
      --exclude="subuid*" \
      --exclude="machine-id" \
      --exclude="adjtime" \
      --exclude="fstab" \
      --exclude="system-connections" \
      --exclude="shadow*" \
      --exclude="gshadow*" \
      --exclude="ssh_host*" \
      --exclude="cmdline" \
      --exclude="crypttab" \
      --exclude="hostname" \
      --exclude="localtime" \
      --exclude="locale*" \
      --exclude="*lock" \
      --exclude=".updated" \
      --exclude="*LOCK" \
      --exclude="vconsole*" \
      --exclude="00-keyboard.conf" \
      --exclude="grub" \
      --exclude="system.control*" \
      --exclude="cdi" \
      --exclude="default.target" \
      /usr/etc /etc 2>/dev/null | sed '/Binary\ files\ /d'

# Gather device info to a pastebin
device-info:
    #!/usr/bin/bash
    echo "Gathering device info..."
    fpaste <(rpm-ostree status) <(fpaste --sysinfo --printonly)
