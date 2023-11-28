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

# Removes Fleek
fleek-remove:
    #!/usr/bin/env bash
    if [[ -x "/var/usrlocal/bin/fleek" ]]; then
      sudo rm -f /var/usrlocal/bin/fleek
    else
      echo "Fleek is not installed or has been already removed"
    fi

# Integrate Nix/Fleek applications with system theme
fleek-themes-install:
    #!/usr/bin/env bash
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

# Installs Devbox
devbox-install:
    #!/usr/bin/env bash
    if [[ -d "/nix" ]]; then
      curl -fsSL https://get.jetpack.io/devbox | bash
    else
      echo "Install nix with ujust nix-install before running ujust devbox-install."
    fi

# Removes Devbox
devbox-remove:
    #!/usr/bin/env bash
    if [[ -x "/var/usrlocal/bin/devbox" ]]; then
      sudo rm -f /var/usrlocal/bin/devbox
    else
      echo "Devbox is not installed or has been already removed"
    fi

# Installs nixGL
nixgl-install:
    #!/usr/bin/env bash
    if [[ -d "/nix" ]]; then
      nix profile install github:guibou/nixGL --impure
    else
      echo "NixGL requires nix to install."
    fi

# Upgrades user nix profile
nix-update-user:
    #!/usr/bin/env bash
    if [[ -d "/nix" ]]; then
      nix profile upgrade '.*'
    else
      echo "Nix is not installed"
    fi

# Upgrades both user and root nix profiles
nix-update-all:
    #!/usr/bin/env bash
    if [[ -d "/nix" ]]; then
      nix profile upgrade '.*'
      sudo nix profile upgrade '.*'
    else
      echo "Nix is not installed"
    fi
