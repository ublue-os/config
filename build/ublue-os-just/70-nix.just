# vim: set ft=make :

# Install, uninstall or configure nix
setup-nix:
    #!/usr/bin/env bash
    CURRENT_STATE="Not Installed"
    if [ -f "/etc/systemd/system/nix-daemon.socket" ]; then
      CURRENT_STATE="Installed"
    fi
    echo "Nix is currently: ${CURRENT_STATE}"
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
    
    else
      echo 'Exiting...'
      exit 0
    fi

# Install, uninstall or configure Fleek (https://getfleek.dev/)
setup-fleek:
    #!/usr/bin/env bash
    if [ ! -f "/etc/systemd/system/nix-daemon.socket" ]; then
      echo "Please install nix first by running ujust setup-nix"
      exit 0
    fi
    echo 'What would you like to do with Fleek?'
    OPTION=$(ugum choose "Install Fleek" "Uninstall Fleek" "Integrate Nix/Fleek applications with system theme")
    
    if [ "$OPTION" == "Install Fleek" ]; then
      mkdir -p $HOME/.config/nix
      echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf
      curl -fsSL https://getfleek.dev/installer | env FORCE=1 bash
    
    elif [ "$OPTION" == "Uninstall Fleek" ]; then
      if [[ -x "/var/usrlocal/bin/fleek" ]]; then
        sudo rm -f /var/usrlocal/bin/fleek
      else
        echo "Fleek is not installed or has been already removed"
      fi
    
    elif [ "$OPTION" == "Integrate Nix/Fleek applications with system theme" ]; then
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
setup-devbox:
    #!/usr/bin/env bash
    if [ ! -f "/etc/systemd/system/nix-daemon.socket" ]; then
      echo "Please install nix first by running ujust setup-nix"
      exit 0
    fi
    CURRENT_STATE="Not Installed"
    if [ -f "/var/usrlocal/bin/devbox" ]; then
      CURRENT_STATE="Installed"
    fi
    echo "Devbox is currently: ${CURRENT_STATE}"
    echo 'What would you like to do with devbox?'
    OPTION=$(ugum choose Install Uninstall)
    
    if [ "$OPTION" == "Install" ]; then
      curl -fsSL https://get.jetpack.io/devbox | bash
    
    elif [ "$OPTION" == "Uninstall" ]; then
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
