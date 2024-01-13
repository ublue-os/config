#!/usr/bin/bash
# Disable shellchecks for things that do not matter for
# a sourceable file
# shellcheck disable=SC2034

########
### Text Formating
########
bold=$(tput bold)
normal=$(tput sgr0)

########
### Special text formating
########
## Function to generate a clickable link, you can call this using
# url=$(urllink "https://ublue.it" "Visit the ublue website")
# echo "${url}"
function urllink (){
    URL=$1
    TEXT=$2

    # Generate a clickable hyperlink
    printf "\e]8;;%s\e\\%s\e]8;;\e\\" "$URL" "$TEXT"
}

########
## Useful functions we use a lot
########
## Function to generate a choice selection and return the selected choice
# CHOICE=$(Ui_choice option1 option2 "option 3")
# *user selects "option 3"*
# echo "$CHOICE" will return "option 3"
function Ui_choice (){
    CHOICE=$(ugum choose "$@")
    echo "$CHOICE"
}
