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
    SUDOPATHVARIABLE5=$(sudo printenv PATH)
    
    sudo tee /etc/sudoers.d/nix-sudo-env <<EOF
    Defaults  secure_path = /nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:$SUDOPATHVARIABLE5
    EOF

    sudo echo "Finished adding sudo variables for nix"

# Removes nix bin path from sudoers config
nix-sudo-undo:
    sudo rm -f /etc/sudoers.d/nix-sudo-env
