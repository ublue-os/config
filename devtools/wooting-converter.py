#!/usr/bin/env python3

from pathlib import Path
import re

# Manually copy the rules from the following site to this variable:
# https://help.wooting.io/en/article/wootility-configuring-device-access-for-wootility-under-linux-udev-rules-r6lb2o/
# Tracking ticket to improve the upstream rules:
# https://github.com/WootingKb/wootility-issues/issues/114
WOOTING_RULES = """
# Wooting One Legacy
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", MODE:="0660", GROUP="input"
# Wooting One update mode 
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", MODE:="0660", GROUP="input"

# Wooting Two Legacy
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", MODE:="0660", GROUP="input"
# Wooting Two update mode  
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", MODE:="0660", GROUP="input"

# Wooting One
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1100", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1100", MODE:="0660", GROUP="input"
# Wooting One Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1101", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1101", MODE:="0660", GROUP="input"
# Wooting One 2nd Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1102", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1102", MODE:="0660", GROUP="input"

# Wooting Two
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1200", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1200", MODE:="0660", GROUP="input"
# Wooting Two Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1201", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1201", MODE:="0660", GROUP="input"
# Wooting Two 2nd Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1202", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1202", MODE:="0660", GROUP="input"

# Wooting Lekker
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1210", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1210", MODE:="0660", GROUP="input"
# Wooting Lekker Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1211", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1211", MODE:="0660", GROUP="input"
# Wooting Lekker 2nd Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1212", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1212", MODE:="0660", GROUP="input"

# Wooting Lekker update mode  
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="121f", MODE:="0660", GROUP="input"

# Wooting Two HE
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1220", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1220", MODE:="0660", GROUP="input"
# Wooting Two HE Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1221", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1221", MODE:="0660", GROUP="input"
# Wooting Two HE 2nd Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1222", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1222", MODE:="0660", GROUP="input"

# Wooting Two HE update mode  
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="122f", MODE:="0660", GROUP="input"

# Wooting Two HE (ARM)
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1230", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1230", MODE:="0660", GROUP="input"
# Wooting Two HE Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1231", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1231", MODE:="0660", GROUP="input"
# Wooting Two HE 2nd Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1232", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1232", MODE:="0660", GROUP="input"

# Wooting Two HE (ARM) update mode  
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="123f", MODE:="0660", GROUP="input"

# Wooting 60HE
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1300", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1300", MODE:="0660", GROUP="input"
# Wooting 60HE Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1301", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1301", MODE:="0660", GROUP="input"
# Wooting 60HE 2nd Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1302", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1302", MODE:="0660", GROUP="input"

# Wooting 60HE update mode  
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="130f", MODE:="0660", GROUP="input"

# Wooting 60HE (ARM)
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1310", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1310", MODE:="0660", GROUP="input"
# Wooting 60HE (ARM) Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1311", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1311", MODE:="0660", GROUP="input"
# Wooting 60HE (ARM) 2nd Alt-gamepad mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1312", MODE:="0660", GROUP="input"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="1312", MODE:="0660", GROUP="input"

# Wooting 60HE (ARM) update mode
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", ATTRS{idProduct}=="131f", MODE:="0660", GROUP="input"
"""

# Switch everything to modern "uaccess" rules, which means that only the current,
# physically logged-in user has access, but no SSH users (remote connections).
#
# If we only use "group based access", then we'd allow keylogging where User A
# is physically logged in, User B uses SSH login at the same time, and keylogs
# everything User A is doing. That's bad.
#
# All "/dev/input" devices are owned by "root:input" (on both Workstation
# and the immutable Silverblue distros). MODE checks if the user either owns
# the file or belongs to the same group (input). The TAG is a systemd login
# feature which only gives the physically logged-in user access to the device.
#
# As a result, the user must be in the "input" group AND physically logged in.

new_rules = re.sub(
    r", MODE[^,]+, GROUP=\"[^\"]+\"", ', MODE="0660", TAG+="uaccess"', WOOTING_RULES
).strip() + "\n"

# Output file must be lexically before "73-seat-late.rules":
# https://github.com/systemd/systemd/issues/4288#issuecomment-348166161

output_file = Path(__file__).parent.parent / "files/etc/udev/rules.d/70-wooting.rules"
with output_file.open("wt", encoding="utf-8") as f:
    f.write(new_rules)

print(new_rules)

print(f"\nWritten to: {output_file}")
