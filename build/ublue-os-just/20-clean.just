# vim: set ft=make :

# Clean up old up unused podman images, flatpak packages and rpm-ostree content
clean-system:
    #!/usr/bin/bash
    podman image prune -af
    flatpak uninstall --unused
    rpm-ostree cleanup -bm
