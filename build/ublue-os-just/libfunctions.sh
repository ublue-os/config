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

## Function to generate a confirm dialog and return the selected choice
# CHOICE=$(Confirm "Are you sure you want to do this?")
# *user selects "No"*
# echo "$CHOICE" will return "1"
# 0 = Yes
# 1 = No
function Confirm (){
    PROMPT=$(ugum confirm "$@")
    echo $?
}

### Function to create a distrobox
# Distrobox "fedora:latest" "my-fedora-box" "$HOME/.var/containers/fedora-box"
# Distrobox "quay.io/toolbx-images/debian-toolbox:unstable" "debian-unstable"
function Distrobox (){
    IMAGE="$1"
    NAME="$2"
    HOMEDIR=""
    # If custom home directory is supplied
    if [ -n "$3" ]; then
        HOMEDIR="$3"
    fi

    if [ -z "$HOMEDIR" ]; then
        distrobox-create --nvidia --image "$IMAGE" -n "$NAME" -Y
    else
        # Make the custom homedir path if it does not exist
        if [ ! -d "$HOMEDIR" ]; then
            mkdir -p "$HOMEDIR"
        fi
        # Create distrobox with custom home path
        distrobox-create --nvidia --image "$IMAGE" -n "$NAME" -H "$HOMEDIR" -Y
    fi
}
