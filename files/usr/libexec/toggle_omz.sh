#!/bin/bash

install_omz()
{
	if ! command -v zsh &> /dev/null
	then
		echo "Unable to install ohmyzsh. Please install zsh first."
		exit 1
	fi

	if ! command -v git &> /dev/null
	then
		# Assuming this is running on fedora atomic, this shouldn't happen on the host.
		# Unless there's an override to remove git.
		# This can also happen if this script is running in a container.
		echo "Unable to install ohmyzsh. Please install git first."
		exit 1
	fi

	# Either curl, wget or fetch are required. Only one of them will be used.
	if command -v curl &> /dev/null
	then
		request_command="curl -fsSL"
	elif command -v wget &> /dev/null
	then
		request_command="wget -O-"
	elif command -v fetch &> /dev/null
	then
		request_command="fetch -o -"
	else
		echo "Unable to install ohmyzsh. Please install either curl, wget or fetch first."
		echo "Note: fetch is not officially packaged by fedora. curl and wget are recommended."
		exit 1
	fi

	if [ "$1" = false ]
	then
		install="y"
	else
		echo "Do you want to install ohmyzsh? (y/n)"
		read install
	fi

	if [[ "$install" =~ ^([yY][eE][sS]|[yY])$ ]]
	then
		if [ "$1" = false ]
		then
			CHSH=no sh -c "$($request_command https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		else
			sh -c "$($request_command https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		fi
	fi
}

uninstall_omz()
{
	# Add missing permissions so the script can run
	# Note: You're supposed to have a command to uninstall omz,
	# but it doesn't seem to work from scripts, so I just run the script this command calls.
	chmod u+x $HOME/.oh-my-zsh/tools/uninstall.sh

	if [[ "$1" = false ]]
	then
		# Uninstalling non interactively
		yes | $HOME/.oh-my-zsh/tools/uninstall.sh
	else
		# Installing interactively
		$HOME/.oh-my-zsh/tools/uninstall.sh
	fi
}

# Initialize `$interactive` default value
interactive=true

# Main
for i in $@
do
	case $i in
		install)
			subcommand="install"
			;;
		uninstall)
			subcommand="uninstall"
			;;
		-i|--interactive)
			interactive=true
			;;
		-n|--non-interactive)
			interactive=false
			;;
		-h|--help)
			echo "Use this script to install or uninstall ohmyzsh easily!"
			echo "Subcommands:"
			echo "    install -> Install ohmyzsh"
			echo "    uninstall -> Uninstall ohmyzsh"
			echo "Flags:"
			echo "    -i / --interactive -> Use this script interactively (Default)"
			echo "    -n / --non-interactive -> Use this script non interactively"
			echo "    -h / --help -> Print this help page and exit"
			exit
			;;
		*)
			echo "Unrecognized argument: $i"
			exit 1
			;;
	esac
done



if [[ "$subcommand" == "install" ]]
then
	install_omz $interactive
elif [[ "$subcommand" == "uninstall" ]]
then
	uninstall_omz $interactive
else
	if [ -d "$HOME/.oh-my-zsh" ]
	then
		echo "ohmyzsh is already installed."
		if [ "$interactive" = false ]
		then
			echo "If you want to uninstall it, either use interactive mode, or the uninstall subcommand."
		else
			echo "Do you want to uninstall it? (y/n)"
			read uninstall

			if [[ "$uninstall" =~ ^([yY][eE][sS]|[yY])$ ]]
			then
				uninstall_omz $interactive
			fi
		fi

		# Exit since we don't need to go through the rest of the script
		exit
	fi

	install_omz $interactive
fi
