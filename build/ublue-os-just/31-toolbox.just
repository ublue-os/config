# Create toolbox containers from a defined manifest (this spec will not be expanded)
toolbox-assemble CONTAINER="prompt" ACTION="create" FILE="/etc/toolbox/toolbox.ini":
    #!/usr/bin/bash
    # Toolboxes are gathered from toolbox.ini, please add them there
    source /usr/lib/ujust/ujust.sh
    ToolboxAssembleList {{ FILE }} {{ ACTION }} {{ CONTAINER }}

# Create a new custom toolbox
toolbox-new IMAGE="prompt" NAME="prompt":
    #!/usr/bin/bash
    # Please only add distroboxes here if you need special checks and logins!
    source /usr/lib/ujust/ujust.sh
    # Prepare arguments
    IMAGE={{ IMAGE }}
    NAME={{ NAME }}
    # Ask user to select an image if we need to prompt
    if [ "$IMAGE" == "prompt" ]; then
      echo -en "Please enter an image (format \"distro:release\" or registry): "
      read IMAGE
      if [ "$NAME" == "prompt" ]; then
        echo -en "Please enter a name for the container: "
        read NAME
      fi
    elif [ -z "${IMAGE,,}" ]; then
      exit 1
    fi
    # If no name is provided and we do not use an image registry, generate one from the image name
    if [ -z "$NAME" ] && [[ ! "$IMAGE" =~ / ]]; then
        # Split IMAGE string into an array
        # shellcheck disable=SC2206
        DISTRORELEASE=(${IMAGE//:/ })
        NAME="${DISTRORELEASE[0]}"-toolbox-"${DISTRORELEASE[1]}"
    fi
    # Create the toolbox
    Toolbox create "$IMAGE" "$NAME"
