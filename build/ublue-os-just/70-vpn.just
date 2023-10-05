
# Install Mullvad VPN
vpn-mullvad:
  echo 'Downloading files needed for installation ...'
  wget -qnc --trust-server-names https://mullvad.net/download/app/rpm/latest -P /tmp
  wget -qnc --trust-server-names https://mullvad.net/download/app/rpm/latest/signature -P /tmp
  wget -qnc https://mullvad.net/media/mullvad-code-signing.asc -P /tmp
  echo 'Importing Mullvad GPG key ...'
  gpg --import /tmp/mullvad-code-signing.asc
  echo 'Verify the Mullvad VPN app ...'
  gpg --verify /tmp/MullvadVPN-*.rpm.asc && rpm-ostree install /tmp/MullvadVPN-*.rpm

# Install Mullvad VPN Beta
vpn-mullvad-beta:
  echo 'Downloading files needed for installation ...'
  wget -qnc --trust-server-names https://mullvad.net/download/app/rpm/latest-beta -P /tmp
  wget -qnc --trust-server-names https://mullvad.net/download/app/rpm/latest-beta/signature -P /tmp
  wget -qnc https://mullvad.net/media/mullvad-code-signing.asc -P /tmp
  echo 'Importing Mullvad GPG key ...'
  gpg --import /tmp/mullvad-code-signing.asc
  echo 'Verify the Mullvad VPN Beta app ...'
  gpg --verify /tmp/MullvadVPN-*beta*.rpm.asc && rpm-ostree install /tmp/MullvadVPN-*beta*.rpm
