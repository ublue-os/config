default:
    @just --unstable --list
    
bios:
  systemctl reboot --firmware-setup

clean:
  podman system prune -a
  flatpak uninstall --unused
  rpm-ostree cleanup -bm

changelogs:
  rpm-ostree db diff --changelogs

distrobox-arch:
  echo 'Creating Arch distrobox ...'
  distrobox create --image quay.io/toolbx-images/archlinux-toolbox:latest -n arch -Y

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
  
