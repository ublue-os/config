default:
    @just --unstable --list
    
bios:
  systemctl reboot --firmware-setup

changelogs:
  rpm-ostree db diff --changelogs

distrobox-boxkit:
  echo 'Creating Boxkit distrobox ...'
  distrobox create --image ghcr.io/ublue-os/boxkit -n boxkit -Y

distrobox-debian:
  echo 'Creating Debian distrobox ...'
  distrobox create --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

distrobox-opensuse:
  echo 'Creating openSUSE distrobox ...'
  distrobox create --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y
 
distrobox-ubuntu:
  echo 'Creating Ubuntu distrobox ...'
  distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y

enroll-secure-boot-key:
    sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der
 
update:
  rpm-ostree update
  flatpak update -y
  distrobox upgrade -a

fixscreenshare:
  cp /usr/share/applications/org.kde.xwaylandvideobridge.desktop $HOME/.config/autostart/
  
nix-me-up:
  #!/bin/bash
  echo "Immutable Fedora variants which use SELinux require a custom script to install Nix properly."
  echo "This script is downloaded from github.com/dnkmmr69420/nix-installer-scripts."
  echo "The script has been confirmed to work but is not regularly audited by uBlue."
  echo "The script will use sudo which gives it full power over your Linux installation."
  read -p "Type \"y\" if you trust this script to run. " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo
    echo "Installing Nix..."
    curl https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/silverblue-nix-installer.sh | bash
  else
    echo
    echo "Aborting..."
  fi
