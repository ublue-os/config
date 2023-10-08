# vim: set ft=make :

# Set needed kernel arguments for Nvidia GPUs
nvidia-set-kargs:
  #!/usr/bin/env bash
  if command -v nvidia-smi; then
    rpm-ostree kargs \
      --append-if-missing=rd.driver.blacklist=nouveau \
      --append-if-missing=modprobe.blacklist=nouveau \
      --append-if-missing=nvidia-drm.modeset=1 \
      --delete-if-present=nomodeset
  else
    echo 'You do not appear to be on a Nvidia image, please refer to the README for your uBlue-OS image.'
  fi

# Test CUDA support for Nvidia GPUs
nvidia-test-cuda:
  #!/usr/bin/env bash
  if lsmod | grep -wq "nvidia"; then
    podman run \
      --user 1000:1000 \
      --security-opt=no-new-privileges \
      --cap-drop=ALL \
      --security-opt label=type:nvidia_container_t  \
      --device=nvidia.com/gpu=all \
      docker.io/nvidia/samples:vectoradd-cuda11.2.1
  else
    echo 'The Nvidia kernel module is not loaded. You may be using secure boot without the needed signing key, lacking the needed kargs, or may not be on a Nvidia image. See "just enroll-secure-boot-key" and "just nvidia-set-kargs".'
  fi

# Enable VAAPI in Firefox Flatpak for Nvidia GPUs
nvidia-setup-firefox-vaapi:
  #!/usr/bin/env bash
  if lsmod | grep -wq "nvidia"; then
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
  else
    echo 'The Nvidia kernel module is not loaded. You may be using secure boot without the needed signing key, lacking the needed kargs, or may not be on a Nvidia image. See "just enroll-secure-boot-key" and "just nvidia-set-kargs".'
  fi
