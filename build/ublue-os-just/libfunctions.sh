#!/usr/bin/bash
# shellcheck disable=SC2154
########
## Useful functions we use a lot, if you want to use them, source libjust.sh
## Dependencies libformatting.sh and libcolors.sh
########
## Function to generate a choice selection and return the selected choice
# CHOICE=$(Choice option1 option2 "option 3")
# *user selects "option 3"*
# echo "$CHOICE" will return "option 3"
function Choose (){
    CHOICE=$(ugum choose "$@")
    echo "$CHOICE"
}

########
## Function to generate a confirm dialog and return the selected choice
########
# CHOICE=$(Confirm "Are you sure you want to do this?")
# *user selects "No"*
# echo "$CHOICE" will return "1"
# 0 = Yes
# 1 = No
function Confirm (){
    ugum confirm "$@"
    echo $?
}

########
## Function to create a distrobox with standardized args
########
## Create a distrobox using default fedora:latest, name the box "my-fedora-box" and give it a custom homedir
# Distrobox "fedora:latest" "my-fedora-box" "$HOME/.var/containers/fedora-box"
## Create a debian toolbox distrobox named debian-unstable
# Distrobox "quay.io/toolbx-images/debian-toolbox:unstable" "debian-unstable"
## Create an ubuntu distrobox named someubuntubox with no custom homedir and unshare network namespace
## ($3 is required if supplying extra args, using "" makes the function skip it)
# Distrobox "ubuntu:latest" "someubuntubox" "" --unshare-ns
function Distrobox (){
    IMAGE="$1"
    NAME="$2"
    HOMEDIR=""
    # If custom home directory is supplied
    if [ -n "$3" ]; then
        HOMEDIR="$3"
    fi

    # If a custom home directory is not specified
    if [ -z "$HOMEDIR" ]; then
        distrobox create --nvidia -Y --image "$IMAGE" -n "$NAME" "${@:2}"
    else
        # Make the custom homedir path if it does not exist
        if [ ! -d "$HOMEDIR" ]; then
            mkdir -p "$HOMEDIR"
        fi
        # Create distrobox with custom home path
        distrobox create --nvidia -Y --image "$IMAGE" -n "$NAME" -H "$HOMEDIR" "${@:3}"
    fi
}

########
## Function to assemble pre-defined distrobox containers from manifest files
########
# 
function Assemble(){
    # Set defaults
    ACTION="create"
    FILE="/etc/distrobox/distrobox.ini"
    NAME=""

    # If an action is provided
    if [ -n "$1" ]; then
        # Set ACTION to the action specified
        # and remove "noconfirm" from $1 when assigning it to ACTION
        ACTION="${1/noconfirm/}"
    fi

    # If a filename is provided
    if [ -n "$2" ]; then
        # Set FILE to the provided filename
        FILE="$2"
    fi

    # If a container name is provided
    if [ -n "$3" ]; then
        # Set distrobox name to provided name
        NAME="$3"
    else
        if [[ ! "$1" =~ ^noconfirm ]]; then
            # Ask user if they REALLY want to assemble all the containers
            echo -e "${b}WARNING${n}: This will assemble and ${u}replace${n}\nALL containers defined in ${b}$FILE${n}."
            CONFIRM=$(Confirm "Are you sure you want to do this?")
            if [ "$CONFIRM" == "1" ]; then
                echo "Aborting..."
                return 1
            fi
        fi
        # Run the distrobox assemble command
        distrobox assemble "$ACTION" --file "$FILE" --replace --dry-run
    fi
    
    # If we do not want confirmations
    if [[ ! "$1" =~ ^noconfirm ]]; then
        # Ask the user if they really want to replace $NAME container
        echo -e "${b}WARNING${n}: This will assemble and ${u}replace${n} the container ${b}$NAME${n}\nwith the one defined in ${b}$FILE${n}."
        CONFIRM=$(Confirm "Are you sure you want to do this?")
        if [ "$CONFIRM" == "1" ]; then
            echo "Aborting..."
            return 1
        fi
    fi

    # Run the distrobox assemble command
    distrobox assemble "$ACTION" --file "$FILE" --name "$NAME" --replace --dry-run
}
