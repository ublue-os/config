#!/usr/bin/bash
# Disable shellchecks for things that do not matter for
# a sourceable file
# shellcheck disable=SC2034,SC2155

### This is one file for now just to help with testing, it will be split into
### multiple smaller files dealing with different aspects before shipping

########
### Text Formating
########
declare -r bold=$(tput bold)
declare -r normal=$(tput sgr0)

########
### Colors
### You can use cpick from https://github.com/ethanbaker/cpick to get the colors
### cpick bash varname | sed -E 's/readonly/declare/'
########
declare -r red=$'\033[38;2;255;0;0m'
declare -r blue=$'\033[38;2;0;0;255m'
declare -r green=$'\033[38;2;0;128;0m'
declare -r darkorange=$'\033[38;2;255;129;3m'

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

## Function to generate background color from foreground color
## NOTE: doublequote the color or future calls to bg will error out!
# bgblue=$(bg "$blue")
# echo "${bgblue}text now has blue background${normal} this text has no background color"
function bg (){
    COLOR="$1"
    echo "$COLOR" | sed -E 's/\[38;/\[48;/'
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
