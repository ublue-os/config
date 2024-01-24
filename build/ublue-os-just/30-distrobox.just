# vim: set ft=make :

alias assemble := distrobox-assemble

# Create distroboxes from a defined manifest
distrobox-assemble CONTAINER="prompt" ACTION="create" FILE="/etc/distrobox/distrobox.ini":
    #!/usr/bin/bash
    # Distroboxes are gathered from distrobox.ini, please add them there
    source /usr/lib/ujust/ujust.sh
    AssembleList {{ FILE }} {{ ACTION }} {{ CONTAINER }}

alias distrobox := distrobox-new

# Create a new custom distrobox
distrobox-new IMAGE="prompt" NAME="prompt" HOMEDIR="":
    #!/usr/bin/bash
    # Please only add distroboxes here if you need special checks and logins!
    source /usr/lib/ujust/ujust.sh
    # Supported images
    IMAGES='
      New
      Bazzite-arch
      Rhel8-toolbox
      Rhel9-toolbox
    '
    IMAGE={{ IMAGE }}
    NAME={{ NAME }}
    HOMEDIR={{ HOMEDIR }}
    ARGS=""
    # Ask user to select an image if we need to prompt
    if [ "$IMAGE" == "prompt" ]; then
      echo "Select what container you want to make"
      IMAGE=$(Choose $IMAGES)
    fi
    # If image is "new"
    if [ "${IMAGE,,}" == "new" ]; then
      echo -en "Please enter an image: "
      read IMAGE
      if [ "$NAME" == "prompt" ]; then
        echo -en "Please enter a name for the container: "
        read NAME
      fi
    elif [ -z "${IMAGE,,}" ]; then
      exit 1
    fi
    # Tailored image selection logic
    # Logic for bazzite-arch
    if [ ${IMAGE,,} == "bazzite-arch" ]; then
      echo "${b}Creating Bazzite distrobox ...${n}"
      if command -v /usr/bin/mutter > /dev/null; then
        IMAGE="ghcr.io/ublue-os/bazzite-arch-gnome"
        NAME="bazzite-arch"
        ARGS="--unshare-netns"
      else
        IMAGE="ghcr.io/ublue-os/bazzite-arch"
        NAME="bazzite-arch"
        ARGS="--unshare-netns"
      fi
    # Anything else
    else
      if [ "$NAME" == "prompt" ]; then
        echo -en "Please enter a name for the container: "
        read NAME
      fi
      case ${IMAGE,,} in
        rhel8-toolbox)
          if ! grep -q "registry.redhat.io" $XDG_RUNTIME_DIR/containers/auth.json; then
            echo "Please login using your Red Hat Account or Red Hat Developer Account ..."
            podman login registry.redhat.io
          fi
          if [ -z "$NAME" ]; then
            NAME="rhel8"
          fi
          echo 'Creating RHEL 8 distrobox ...'
          IMAGE="registry.redhat.io/rhel8/toolbox:latest"
          ;;
        rhel9-toolbox)
          if ! grep -q "registry.redhat.io" $XDG_RUNTIME_DIR/containers/auth.json; then
            echo "Please login using your Red Hat Account or Red Hat Developer Account ..."
            podman login registry.redhat.io
          fi
          if [ -z "$NAME" ]; then
            NAME="rhel9"
          fi
          echo 'Creating RHEL 9 distrobox ...'
          IMAGE="registry.redhat.io/rhel9/toolbox:latest"
          ;;
      esac
    fi
    # Create the distrobox
    Distrobox "$IMAGE" "$NAME" "$HOMEDIR" $ARGS
    # If IMAGE is bazzite-arch, link to documentation
    if [ "${IMAGE,,}" == "bazzite-arch" ]; then
      echo $(Urllink "https://github.com/ublue-os/bazzite-arch" "Check out the docs for exportable apps and instructions")
    fi

# Install specialized application containers (like brew)
setup-distrobox-app CONTAINER="prompt":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    AssembleList "/etc/distrobox/apps.ini" create {{ CONTAINER }}

# Install obs-studio-portable from wimpysworld, which bundles an extensive collection of 3rd party plugins
install-obs-studio-portable:
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    AssembleList "/etc/distrobox/apps.ini" create "obs-studio-portable"
