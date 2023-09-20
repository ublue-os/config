# vim: set ft=make :

set allow-duplicate-recipes
set ignore-comments

_default:
  @just --unstable --list --list-heading $'Available commands:\n' --list-prefix $' - '

# Boot into this device's BIOS/UEFI screen
bios:
  systemctl reboot --firmware-setup

# Show the changelog
changelogs:
  rpm-ostree db diff --changelogs

# Enroll Nvidia driver & KMOD signing key for secure boot - Enter password "ublue-os" if prompted
enroll-secure-boot-key:
  sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der
  echo 'Enter password "ublue-os" if prompted'
