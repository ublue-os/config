#!/usr/bin/bash
########
## Useful functions we use a lot
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
        distrobox-create --nvidia --image "$IMAGE" -n "$NAME" "${@:2}" -Y
    else
        # Make the custom homedir path if it does not exist
        if [ ! -d "$HOMEDIR" ]; then
            mkdir -p "$HOMEDIR"
        fi
        # Create distrobox with custom home path
        distrobox-create --nvidia --image "$IMAGE" -n "$NAME" -H "$HOMEDIR" "${@:3}" -Y
    fi
}
