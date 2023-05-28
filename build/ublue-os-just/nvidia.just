
set-kargs-nvidia:
    rpm-ostree kargs \
        --append-if-missing=rd.driver.blacklist=nouveau \
        --append-if-missing=modprobe.blacklist=nouveau \
        --append-if-missing=nvidia-drm.modeset=1 \
        --delete=nomodeset

enroll-secure-boot-key-legacy-nvidia:
    sudo mokutil --import /etc/pki/akmods/certs/akmods-nvidia.der

test-cuda:
    podman run \
        --user 1000:1000 \
        --security-opt=no-new-privileges \
        --cap-drop=ALL \
        --security-opt label=type:nvidia_container_t  \
        docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1

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
