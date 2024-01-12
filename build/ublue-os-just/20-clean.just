# vim: set ft=make :

# Clean up old containers and flatpaks
clean-system:
    #!/usr/bin/bash
    podman system prune -a
    flatpak uninstall --unused
    rpm-ostree cleanup -bm
    if [ -x "$(command -v nix-store)" ]; then
      nix-store --gc
      nix-store --optimise
    fi
