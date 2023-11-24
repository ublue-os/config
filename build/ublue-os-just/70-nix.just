# vim: set ft=make :

# Install Nix with the Determinate Nix Installer
nix-install:
    #!/usr/bin/env bash
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sudo bash -s -- install --no-confirm

# Uninstall Nix
nix-remove:
    sudo /nix/nix-installer uninstall

# Adds the nix bin path to the sudoers config
nix-sudo:
    #!/usr/bin/env bash
    sudo echo "Adding sudo path variables for nix"
    sudo rm -f /etc/sudoers.d/nix-sudo-env
    SUDOPATHVARIABLE5=$(sudo printenv PATH)
    
    sudo tee /etc/sudoers.d/nix-sudo-env <<EOF
    Defaults  secure_path = /nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$SUDOPATHVARIABLE5
    EOF

    sudo echo "Finished adding sudo variables for nix"

# Removes nix bin path from sudoers config
nix-sudo-undo:
    sudo rm -f /etc/sudoers.d/nix-sudo-env

# Install Fleek (https://getfleek.dev/)
fleek-install:
    #!/usr/bin/env bash
    if [[ -d "/nix" ]]; then
      mkdir -p $HOME/.config/nix
      echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf
      curl -fsSL https://getfleek.dev/installer | env FORCE=1 bash
    else
      echo "Install nix with ujust nix-install before running ujust fleek-install."
    fi

# Integrate Nix/Fleek applications with system theme
fleek-themes-install:
    #!/usr/bin/env bash
    if [[ -x "/var/usrlocal/bin/fleek" ]]; then
      IMAGE_INFO="/usr/share/ublue-os/image-info.json"
      BASE_IMAGE_NAME=$(jq -r '."base-image-name"' < $IMAGE_INFO)
      if [[ ${BASE_IMAGE_NAME} == 'silverblue' ]]; then
        fleek add adw-gtk3 --apply
      else
        fleek add breeze-icons
        fleek add libsForQt5.breeze-qt5
        fleek apply
      fi
    else
      echo "Install fleek with ujust fleek-install before running ujust fleek-themes-install."
    fi
