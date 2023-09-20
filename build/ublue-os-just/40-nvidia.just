# vim: set ft=make :

# Set needed kernel arguments for Nvidia GPUs
set-kargs-nvidia:
    rpm-ostree kargs \
        --append-if-missing=rd.driver.blacklist=nouveau \
        --append-if-missing=modprobe.blacklist=nouveau \
        --append-if-missing=nvidia-drm.modeset=1 \
        --delete-if-present=nomodeset

# Test CUDA support for Nvidia GPUs
test-cuda:
    podman run \
        --user 1000:1000 \
        --security-opt=no-new-privileges \
        --cap-drop=ALL \
        --security-opt label=type:nvidia_container_t  \
        docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1

# Enable VAAPI in Firefox for Nvidia GPUs
setup-firefox-flatpak-vaapi-nvidia:
    flatpak override \
        --user \
        --filesystem=host-os \
        --env=LIBVA_DRIVER_NAME=nvidia \
        --env=LIBVA_DRIVERS_PATH=/run/host/usr/lib64/dri \
        --env=LIBVA_MESSAGING_LEVEL=1 \
        --env=MOZ_DISABLE_RDD_SANDBOX=1 \
        --env=NVD_BACKEND=direct \
        --env=MOZ_ENABLE_WAYLAND=1 \
        org.mozilla.firefox
