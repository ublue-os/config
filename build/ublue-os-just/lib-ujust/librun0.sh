#!/usr/bin/bash

# Function to use run0 instead of sudo, if installed (since F41)
# run0 is more secure than using sudo, so it's recommend to use it instead of sudo
# The current caveat is that run0 always requires password authentication per root-call (--no-ask-password doesn't work at the moment)
# so use it only for one-liner commands (bash -c can help here, with potential of less readable code)
# See:
# https://github.com/systemd/systemd/issues/33366
# https://github.com/polkit-org/polkit/issues/472

run0() {
if command -v run0 &> /dev/null; then
  run0 "${@}"
else
  sudo "${@}"
fi  
}
