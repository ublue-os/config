# vim: set ft=make :

# Install, uninstall or configure nix
setup-nix:
    #!/usr/bin/env bash
    CURRENT_STATE="Not Installed"
    if [ -f "/etc/systemd/system/nix-daemon.socket" ]; then
      CURRENT_STATE="Installed"
    fi
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "Nix is currently: ${bold}${CURRENT_STATE}${normal}"
    echo 'What would you like to do with Nix?'
    OPTION=$(ugum choose \
        Install \
        Uninstall \
        "Update nix user profile" \
        "Update all nix profiles" \
        "Re-copy nix systemd units to system" \
        "Add nix path to sudo" \
        "Remove nix path from sudo" \
      )
    if [ "$OPTION" == "Install" ]; then
      curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sudo bash -s -- install --no-confirm
      sudo rm -f /etc/systemd/system/nix-daemon.service
      sudo rm -f /etc/systemd/system/nix-daemon.socket
      sudo cp /nix/var/nix/profiles/default/lib/systemd/system/nix-daemon.service /etc/systemd/system/nix-daemon.service
      sudo cp /nix/var/nix/profiles/default/lib/systemd/system/nix-daemon.socket /etc/systemd/system/nix-daemon.socket
    elif [ "$OPTION" == "Uninstall" ]; then
      sudo /nix/nix-installer uninstall
      sudo rm -f /etc/systemd/system/nix-daemon.service
      sudo rm -f /etc/systemd/system/nix-daemon.socket
    elif [ "$OPTION" == "Update nix user profile" ]; then
      nix profile upgrade '.*'
    elif [ "$OPTION" == "Update all nix profiles" ]; then
      nix profile upgrade '.*'
      sudo nix profile upgrade '.*'
    elif [ "$OPTION" == "Re-copy nix systemd units to system" ]; then
      sudo rm -f /etc/systemd/system/nix-daemon.service
      sudo rm -f /etc/systemd/system/nix-daemon.socket
      sudo cp /nix/var/nix/profiles/default/lib/systemd/system/nix-daemon.service /etc/systemd/system/nix-daemon.service
      sudo cp /nix/var/nix/profiles/default/lib/systemd/system/nix-daemon.socket /etc/systemd/system/nix-daemon.socket
    elif [ "$OPTION" == "Add nix path to sudo" ]; then
      sudo echo "Adding sudo path variables for nix"
      sudo rm -f /etc/sudoers.d/nix-sudo-env
      SUDOPATHVARIABLE5=$(sudo printenv PATH)
      sudo tee /etc/sudoers.d/nix-sudo-env <<EOF
      Defaults  secure_path = /nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$SUDOPATHVARIABLE5
    EOF
      sudo echo "Finished adding sudo variables for nix"
    elif [ "$OPTION" == "Remove nix path from sudo" ]; then
      sudo rm -f /etc/sudoers.d/nix-sudo-env
    fi

# Install, uninstall or configure Fleek (https://getfleek.dev/)
setup-fleek ARG="prompt":
    #!/usr/bin/env bash
    if [ ! -f "/etc/systemd/system/nix-daemon.socket" ]; then
      echo "Please install nix first by running ujust setup-nix"
      exit 0
    fi
    OPTION={{ARG}}
    if [ "$OPTION" == "prompt" ]; then
      echo 'What would you like to do with Fleek?'
      OPTION=$(ugum choose "Install Fleek" "Uninstall Fleek" "Integrate Nix/Fleek applications with system theme")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust setup-fleek <option>"
      echo "  <option>: Specify the quick option - 'install', 'remove', or 'integrate'"
      echo "  Use 'install' to select install"
      echo "  Use 'remove' to select uninstall"
      echo "  Use 'integrate' to integrate nix applications with system theme."
      exit 0
    fi
    if [ "$OPTION" == "Install Fleek" ] || [ "${OPTION,,} == "install" ]; then
      mkdir -p $HOME/.config/nix
      echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf
      curl -fsSL https://getfleek.dev/installer | env FORCE=1 bash
    elif [ "$OPTION" == "Uninstall Fleek" ] || [ "${OPTION,,} == "remove" ]; then
      if [[ -x "/var/usrlocal/bin/fleek" ]]; then
        sudo rm -f /var/usrlocal/bin/fleek
      else
        echo "Fleek is not installed or has been already removed"
      fi
    elif [ "$OPTION" == "Integrate Nix/Fleek applications with system theme" ] || [ "${OPTION,,} == "integrate" ]; then
      if [[ -x "/var/usrlocal/bin/fleek" ]]; then
        if command -v mutter; then
          fleek add adw-gtk3 --apply
        else
          fleek add breeze-icons
          fleek add libsForQt5.breeze-qt5
          fleek apply
        fi
      else
        echo "Install fleek with ujust fleek-install before running ujust fleek-themes-install."
      fi
    fi

# Install or uninstall devbox
setup-devbox ARG="prompt":
    #!/usr/bin/env bash
    if [ ! -f "/etc/systemd/system/nix-daemon.socket" ]; then
      echo "Please install nix first by running ujust setup-nix"
      exit 0
    fi
    CURRENT_STATE="Not Installed"
    if [ -f "/var/usrlocal/bin/devbox" ]; then
      CURRENT_STATE="Installed"
    fi
    bold=$(tput bold)
    normal=$(tput sgr0)
    OPTION={{ARG}}
    if [ "$OPTION" == "prompt" ]; then
      echo "Devbox is currently: ${bold}${CURRENT_STATE}${normal}"
      echo 'What would you like to do with devbox?'
      OPTION=$(ugum choose Install Uninstall)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust toggle-updates <option>"
      echo "  <option>: Specify the quick option - 'install' or 'remove'"
      echo "  Use 'install' to Install devbox"
      echo "  Use 'remove' to Remove devbox."
      exit 0
    fi
    if [ "${OPTION,,}" == "Install" ]; then
      curl -fsSL https://get.jetpack.io/devbox | bash
    elif [ "${OPTION,,}" == "Uninstall" ] || [ "${OPTION,,}" == "remove" ]; then
      if [[ -x "/var/usrlocal/bin/devbox" ]]; then
        sudo rm -f /var/usrlocal/bin/devbox
      else
        echo "Devbox is not installed or has been already removed"
      fi
    fi

# Installs nixGL
install-nixgl:
    #!/usr/bin/env bash
    if [ ! -f "/etc/systemd/system/nix-daemon.socket" ]; then
      echo "Please install nix first by running ujust setup-nix"
      exit 0
    fi
    nix profile install github:guibou/nixGL --impure
