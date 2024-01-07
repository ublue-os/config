# vim: set ft=make :

# Configure the Nvidia driver
configure-nvidia ARG="prompt":
    #!/usr/bin/env bash
    bold=$(tput bold)
    normal=$(tput sgr0)
    OPTION={{ ARG }}
    if [ "$OPTION" == "prompt" ]; then
      echo "${bold}Configuring Nvidia drivers${normal}"
      echo 'What would you like to do?'
      OPTION=$(ugum choose "Set needed kernel arguments" "Test CUDA support" "Enable Nvidia VAAPI in Firefox Flatpak")
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: ujust configure-nvidia <option>"
      echo "  <option>: Specify the quick option - 'kargs', 'test-cuda' or 'firefox-vaapi'"
      echo "  Use 'kargs' to Set needed kernel arguments"
      echo "  Use 'test-cuda' to Test CUDA support"
      echo "  Use 'firefox-vaapi' to Enable Nvidia VAAPI in Firefox Flatpak."
      exit 0
    fi
    if [ "$OPTION" == "Set needed kernel arguments" ] || [ "${OPTION,,}" == "kargs" ]; then
      if command -v nvidia-smi; then
        rpm-ostree kargs \
          --append-if-missing=rd.driver.blacklist=nouveau \
          --append-if-missing=modprobe.blacklist=nouveau \
          --append-if-missing=nvidia-drm.modeset=1 \
          --delete-if-present=nomodeset
      else
        echo 'You do not appear to be on a Nvidia image, please refer to the README for your uBlue-OS image.'
      fi
    elif [ "$OPTION" == "Test CUDA support" ] || [ "${OPTION,,}" == "test-cuda" ]; then
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
    elif [ "$OPTION" == "Enable Nvidia VAAPI in Firefox Flatpak" ] || [ "${OPTION,,}" == "firefox-vaapi" ]; then
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
    fi
