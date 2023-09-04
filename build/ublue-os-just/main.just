default:
    @just --unstable --list

# Boot into this device's BIOS/UEFI screen
bios:
  systemctl reboot --firmware-setup

# Clean up old containers and flatpaks
clean:
  podman system prune -a
  flatpak uninstall --unused
  rpm-ostree cleanup -bm

# Show the changelog
changelogs:
  rpm-ostree db diff --changelogs

# Create an Arch container
distrobox-arch:
  echo 'Creating Arch distrobox ...'
  distrobox create --nvidia --image quay.io/toolbx-images/archlinux-toolbox:latest -n arch -Y

# Create a Bazzite container
distrobox-bazzite:
  #!/usr/bin/env bash
  echo 'Creating Bazzite distrobox ...'
  if command -v /usr/bin/mutter > /dev/null; then
    distrobox create --nvidia --image ghcr.io/ublue-os/bazzite-arch-gnome --name bazzite-arch
  else
    distrobox create --nvidia --image ghcr.io/ublue-os/bazzite-arch --name bazzite-arch
  fi
  echo 'Check out the docs for exportable apps and instructions: https://github.com/ublue-os/bazzite-arch'

# Create an Alpine boxkit container
distrobox-boxkit:
  echo 'Creating Boxkit distrobox ...'
  distrobox create --nvidia --image ghcr.io/ublue-os/boxkit -n boxkit -Y

# Create a Debian container
distrobox-debian:
  echo 'Creating Debian distrobox ...'
  distrobox create --nvidia --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

# Create an openSUSE container
distrobox-opensuse:
  echo 'Creating openSUSE distrobox ...'
  distrobox create --nvidia --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y

# Create an Ubuntu container
distrobox-ubuntu:
  echo 'Creating Ubuntu distrobox ...'
  distrobox create --nvidia --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y

# Enroll secure boot key
enroll-secure-boot-key:
    sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der

# Update system, flatpaks, and containers all at once
update:
  rpm-ostree update
  flatpak update -y
  distrobox upgrade -a

# Enable xwaylandvideobridge
fixscreenshare:
  cp /usr/share/applications/org.kde.xwaylandvideobridge.desktop $HOME/.config/autostart/
  
