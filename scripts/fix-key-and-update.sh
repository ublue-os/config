#!/usr/bin/bash
#
# This is a tool to provide easy change to the new Universal Blue image signing key, updated July 2, 2024.
#
# Note: this is required for upgrades to images published after July 1, 2024, and will prevent downgrading
# to images published before July 2, 2024.
#
set -eu

# Require root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Fetch the new public key from ublue-os's github repo, updating the local copy.
echo "Fetching the new public key from ublue-os's github repo..."
curl https://raw.githubusercontent.com/ublue-os/main/main/cosign.pub > /etc/pki/containers/ublue-os.pub

# Ensure the path to the public key matches the local copy location.
echo "Updating the path to the public key in the container policy..."
sed -i.bak "s#/usr/etc/pki/containers/ublue-os.pub#/etc/pki/containers/ublue-os.pub#" /etc/containers/policy.json

# Update system, respecting new public signing key.
echo "Updating the system..."
rpm-ostree update
