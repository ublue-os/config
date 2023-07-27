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

add-flatpaks-to-path:
  #!/bin/sh
  echo 'Adding Flatpaks to $PATH'
  sudo bash -c 'cat > /etc/profile.d/flatpak-bindir.sh' <<-'EOF'
  if [ -n "$XDG_DATA_HOME" ] && [ -d "$XDG_DATA_HOME/flatpak/exports/bin" ]; then
    pathmunge "$XDG_DATA_HOME/flatpak/exports/bin"
  elif [ -n "$HOME" ] && [ -d "$HOME/.local/share/flatpak/exports/bin" ]; then
    pathmunge "$HOME/.local/share/flatpak/exports/bin"
  fi
  if [ -d /var/lib/flatpak/exports/bin ]; then
    pathmunge /var/lib/flatpak/exports/bin
  fi
  EOF
  echo 'Restart your Terminal for changes to take effect'
