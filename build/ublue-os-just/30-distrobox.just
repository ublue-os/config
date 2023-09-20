# vim: set ft=make :

# Create an Arch container
distrobox-arch:
  echo 'Creating Arch distrobox ...'
  distrobox create --nvidia --image quay.io/toolbx-images/archlinux-toolbox:latest -n arch -Y

# Create a Bazzite-Arch container
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

# Create a Fedora container
distrobox-fedora:
  echo 'Creating Fedora distrobox ...'
  distrobox create --nvidia --image registry.fedoraproject.org/fedora-toolbox:38 -n fedora -Y

# Create an openSUSE container
distrobox-opensuse:
  echo 'Creating openSUSE distrobox ...'
  distrobox create --nvidia --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y

# Create an Ubuntu container
distrobox-ubuntu:
  echo 'Creating Ubuntu distrobox ...'
  distrobox create --nvidia --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y