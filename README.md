[![build-ublue](https://github.com/ublue-os/confif/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/config/actions/workflows/build.yml)

# ublue-os configs

A layer for adding enhancements to your image. Use these for better hardware support and automatic updates!

# Usage

Add this to your Containerfile to copy the rules over:

    COPY --from=ghcr.io/ublue-os/udev-rules:latest /files/ublue-os-udev-rules /
    COPY --from=ghcr.io/ublue-os/udev-rules:latest /files/ublue-os-update-services /
    
Or if you prefer to install via an RPM package:

    COPY --from=ghcr.io/ublue-os/udev-rules:latest /rpms/ublue-os-udev-rules.noarch.rpm /
    COPY --from=ghcr.io/ublue-os/udev-rules:latest /rpmm/ublue-os-update-services.noarch.rpm /
    RUN rpm -ivh /ublue-os-udev-rules.noarch.rpm
    RUN rpm -ivh /ublue-os-update-services.noarch.rpm
    
# Features

Feel free to PR more rules into this repo! Ideally as they get added upstream we can remove them here. Note that this image only contains the udev rules, you must still install and configure the software that needs these rules.

## udev-rules

- Gaming controllers from [game-devices-udev](https://gitlab.com/jntesteves/game-devices-udev/) 
- Google Titan USB keys
- OpenRGB rules
- [Yubikey support](https://github.com/Yubico/libfido2/tree/main/udev)
- [Wooting Wootility](https://wooting.io/wootility)

## automatic updates

- Background flatpak updates
- Background rpm-ostree updates

# Adding rules

If you have a rule you want to contribute send a pull request by adding the rule into `files/etc/udev/rules.d`

# Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/udev-rules
