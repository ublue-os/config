# vim: set ft=make :

# Create an Arch container
distrobox-arch:
    echo 'Creating Arch distrobox ...'
    distrobox-create --nvidia --image ghcr.io/ublue-os/arch-distrobox:latest -n arch -Y

# Create a Bazzite-Arch container
distrobox-bazzite:
    #!/usr/bin/env bash
    echo 'Creating Bazzite distrobox ...'
    if command -v /usr/bin/mutter > /dev/null; then
      distrobox-create --unshare-netns --nvidia --image ghcr.io/ublue-os/bazzite-arch-gnome --name bazzite-arch -Y
    else
      distrobox-create --unshare-netns --nvidia --image ghcr.io/ublue-os/bazzite-arch --name bazzite-arch -Y
    fi
    echo 'Check out the docs for exportable apps and instructions: https://github.com/ublue-os/bazzite-arch'

# Create an Alpine boxkit container
distrobox-boxkit:
    echo 'Creating Boxkit distrobox ...'
    distrobox-create --nvidia --image ghcr.io/ublue-os/boxkit -n boxkit -Y

# Create a Debian container
distrobox-debian:
    echo 'Creating Debian distrobox ...'
    distrobox-create --nvidia --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

# Create a Fedora container
distrobox-fedora:
    echo 'Creating Fedora distrobox ...'
    distrobox-create --nvidia --image ghcr.io/ublue-os/fedora-distrobox:latest -n fedora -Y

# Create an openSUSE container
distrobox-opensuse:
    echo 'Creating openSUSE distrobox ...'
    distrobox-create --nvidia --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y

# Create an Ubuntu container
distrobox-ubuntu:
    echo 'Creating Ubuntu distrobox ...'
    distrobox-create --nvidia --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y

# Create an Alma Linux container
distrobox-alma:
    echo 'Creating Alma distrobox ...'
    distrobox-create --nvidia --image quay.io/toolbx-images/almalinux-toolbox:latest -n alma -Y

# Create a Centos (Stream) container
distrobox-centos:
    echo 'Creating Centos (Stream) distrobox ...'
    distrobox-create --nvidia --image quay.io/toolbx-images/centos-toolbox:latest -n centos -Y

# Create a homebrew container
distrobox-brew:
	echo 'Creating homebrew container ...'
	distrobox-create --nvidia --image ghcr.io/homebrew/brew:latest -n brew -Y

# Install obs-studio-portable from wimpysworld, which bundles an extensive collection of 3rd party plugins
install-obs-studio-portable:
    echo 'Installing obs-studio-portable...' && \
    distrobox-create --nvidia --no-entry --image ghcr.io/ublue-os/obs-studio-portable -n obs-studio-portable -Y && \
    distrobox-enter -n obs-studio-portable -- 'bash -c "distrobox-export --app obs"'
