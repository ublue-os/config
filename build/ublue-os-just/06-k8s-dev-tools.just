# vim: set ft=make :

# Install Kubernetes CLI dev tools
k8s-dev-tools:
    #!/usr/bin/bash
    echo "Adding Kubernetes command line tools..."
    brew bundle --file /usr/share/ublue-os/homebrew/kubernetes.Brewfile
