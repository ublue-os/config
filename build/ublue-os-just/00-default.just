# vim: set ft=make :

uid := `id -u`
shell := `grep :$(id -u): /etc/passwd | cut -d: -f7`

set allow-duplicate-recipes
set ignore-comments

_default:
  @just --unstable --list --list-heading $'Available commands:\n' --list-prefix $' - '

# Boot into this device's BIOS/UEFI screen
bios:
  systemctl reboot --firmware-setup

# Change the user's shell
chsh new_shell:
  #!/usr/bin/env bash
  set -euo pipefail
  if [ "{{shell}}" = "{{new_shell}}" ] ; then
    printf "Your shell is already set to %s.\n" "{{new_shell}}"
  else
    if [ -x "{{new_shell}}" ] ; then
      sudo usermod $USER --shell "{{new_shell}}"
      printf "%s's shell is now %s.\n" "$USER" "{{new_shell}}"
    else
      echo "{{new_shell}} does not exist or is not executable!"
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
  sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der
  echo 'Enter password "ublue-os" if prompted'
