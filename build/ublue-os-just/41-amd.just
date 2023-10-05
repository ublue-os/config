# vim: set ft=make :
# Set needed kernel parameters for Overclocking AMD GPUs
amd-set-oc-kargs:
  #!/usr/bin/env bash
  if lsmod | grep -wq "amdgpu"; then
    rpm-ostree kargs \
      --append-if-missing=amdgpu.ppfeaturemask=0xffffffff \
      --delete-if-present=nomodeset \
      --delete-if-present=vga
  else
    echo 'You do not appear to use a AMD GPU. The amdgpu kernel module is not loaded.'
  fi
