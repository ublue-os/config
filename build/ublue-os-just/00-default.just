# vim: set ft=make :

set allow-duplicate-recipes
set ignore-comments

_default:
  @just --unstable --list --list-heading $'Available commands:\n' --list-prefix $' - '

# Boot into this device's BIOS/UEFI screen
bios:
  systemctl reboot --firmware-setup

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
