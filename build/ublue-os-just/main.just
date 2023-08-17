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
  distrobox create --image quay.io/toolbx-images/archlinux-toolbox:latest -n arch -Y

# Create a Bazzite container (AMD and Intel GPUs only)
distrobox-bazzite:
  echo 'Creating Bazzite distrobox (AMD and Intel GPUs only) ...'
  distrobox create --image ghcr.io/ublue-os/bazzite-arch -n bazzite-arch
  echo 'Check out the docs for instructions: https://github.com/ublue-os/bazzite-arch'

# Create a Bazzite container (Nvidia GPUs only)
distrobox-bazzite-nvidia:
  echo 'Creating Bazzite distrobox (Nvidia GPUs only) ...' 
  distrobox create --image ghcr.io/ublue-os/bazzite-arch -n bazzite-arch --nvidia
  echo 'Check out the docs for instructions: https://github.com/ublue-os/bazzite-arch'

# Create an Alpine boxkit container
distrobox-boxkit:
  echo 'Creating Boxkit distrobox ...'
  distrobox create --image ghcr.io/ublue-os/boxkit -n boxkit -Y

# Create a Debian container
distrobox-debian:
  echo 'Creating Debian distrobox ...'
  distrobox create --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

# Create an openSUSE container
distrobox-opensuse:
  echo 'Creating openSUSE distrobox ...'
  distrobox create --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y

# Create an Ubuntu container
distrobox-ubuntu:
  echo 'Creating Ubuntu distrobox ...'
  distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y

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
  
# Allow current user to sudo without a password
alias iamroot := sudo-nopass
sudo-nopass:
  echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${USER}