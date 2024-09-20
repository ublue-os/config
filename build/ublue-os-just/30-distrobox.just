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

# Install/update DaVinci Resolve, a closed-source video editing utility
install-resolve ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    set -eo pipefail
    SCRIPT_URL="https://raw.githubusercontent.com/zelikos/davincibox/3e51fa38ac7512a26d644d0f48d8cf99921d80de/setup.sh"
    DOWNLOADDIR=$(xdg-user-dir DOWNLOAD || echo ${HOME})
    tmpdir=/var/tmp/bazzite_davincibox_setup.tmp
    mkdir -p $tmpdir
    trap "rm -rf ${tmpdir}" INT EXIT HUP
    OPTION={{ ACTION }}
    if [ "$OPTION" == "help" ]; then
      echo "Usage: ujust install-resolve <option>"
      echo "  <option>: Specify the quick option to skip the prompt"
      echo "  Use 'install' to select Install/upgrade davincibox"
      echo "  Use 'uninstall' to select Uninstall davincibox"
      exit 0
    elif [ "$OPTION" == "" ]; then
      # Display install state and show options
      INSTALL_STATE=0
      INSTALL_STATE=$(podman container exists davincibox; echo $?)
      if (( $INSTALL_STATE == 0 )); then
        echo "Installed?: ${green}yes${n}"
      else
        echo "Installed?: ${red}no${n}"
      fi
      OPTION=$(Choose \
        "Install/upgrade davincibox" \
        "Uninstall davincibox" \
      )
      if [[ "${OPTION,,}" =~ (^install/upgrade[[:space:]]davincibox) ]]; then
        echo "This script requires you to download the DaVinci Resolve installer (should be a zip file) manually from their website and place it in ${HOME} or ${DOWNLOADDIR}"
        echo "https://www.blackmagicdesign.com/event/davinciresolvedownload"
        echo ""
        echo -e "${b}\033[3mDo not\033[0m ${b}extract the .zip contents, the script will handle everything${n}"
        echo "${lightgrey}TIP: For manual installation, see https://github.com/zelikos/davincibox${n}"
        # Get sure user reads instructions
        ugum confirm || exit 0
        # Download davincibox setup script
        SETUPSCRIPT=/tmp/davincibox_setup.sh
        wget -O $SETUPSCRIPT ${SCRIPT_URL}
        chmod +x $SETUPSCRIPT
        # Check if the installer is in HOME or DOWNLOAD
        shopt -s nullglob && possible_installers=({$HOME,$DOWNLOADDIR}/DaVinci_Resolve_{,Studio_}*_Linux.{zip,run}) \
            && shopt -u nullglob
        runfile=$(Choose ${possible_installers[@]})
        if [[ ! -z $runfile && -f $runfile ]]; then
          if [[ $runfile =~ .zip$ ]]; then
            unzip -o -d "$tmpdir" "$runfile"
            RUNFILE=$(find $tmpdir -executable -name "DaVinci_Resolve_*.run")
          else
            RUNFILE="$runfile"
          fi
          echo "Installer found: ${RUNFILE}"
        else
          echo "${red}Installer not found${n}"; 
          echo "${red}Please place the file DaVinci_Resolve_*_Linux.run in ${HOME} or ${DOWNLOADDIR}${n}";
          exit 1
        fi
        bash <<< "env -C ${tmpdir} $SETUPSCRIPT $RUNFILE"
        echo "davincibox was successfully installed"
      elif [[ "${OPTION,,}" =~ (^uninstall[[:space:]]davincibox) ]]; then
        ugum confirm "Confirm davincibox uninstall?" || exit 0
        # Remove the existing container
        if podman container exists davincibox >/dev/null 2>&1; then 
          echo "Removing existing davincibox container"
          distrobox enter davincibox -- add-davinci-launcher remove
          podman stop davincibox
          podman rm davincibox
        else
          echo "davincibox is not installed, skip..."
          exit 0
        fi
      fi
    else
      echo "Incorrect option"
      exit 1
    fi

alias install-resolve-studio := install-resolve
