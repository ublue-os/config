# vim: set ft=make :

uid := `id -u`
shell := `grep :$(id -u): /etc/passwd | cut -d: -f7`

set allow-duplicate-recipes := true
set ignore-comments := true

_default:
    @just --unstable --list --list-heading $'Available commands:\n' --list-prefix $' - '

# Boot into this device's BIOS/UEFI screen
bios:
    systemctl reboot --firmware-setup

# Change the user's shell
chsh new_shell:
    #!/usr/bin/env bash
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
    #!/usr/bin/env bash
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
    sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der

# Upgrade Distrobox to the latest git version
distrobox-git:
    echo 'Installing latest git snapshot of Distrobox...'
    curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --next --prefix ~/.local

# Downgrades Distrobox to the Fedora version
remove-distrobox-git:
    echo 'Uninstalling latest git snapshot of Distrobox...'
    curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/uninstall | sh -s -- --prefix ~/.local

# Install Homebrew for Linux
install-brew:
    echo "Installing homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to shell rc files
install-brew-to-shell:
    #!/usr/bin/env bash
    set -euxo pipefail
    echo "Adding homebrew to shell configuration"
    touch $HOME/.zprofile
    touch $HOME/.bash_profile
    if grep -q "linuxbrew" $HOME/.zprofile
    then
      echo "Brew configuration already present in .zprofile"
    else 
      echo "Adding Brew configuration to .zprofile"
      echo 'eval "$(/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zprofile
    fi
    if grep -q "linuxbrew" $HOME/.bash_profile
    then
      echo "Brew configuration already present in .bash_profile"
    else 
      echo "Adding Brew configuration to .bash_profile"
      echo 'eval "$(/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bash_profile
    fi

# Removes homebrew from system
remove-brew:
    sudo rm -rf /var/home/linuxbrew
