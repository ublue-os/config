# vim: set ft=make :

# Update system, flatpaks, and containers all at once
update:
  rpm-ostree update
  flatpak update -y
  distrobox upgrade -a
