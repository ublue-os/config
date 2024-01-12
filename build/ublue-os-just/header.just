set allow-duplicate-recipes := true
set ignore-comments := true

_default:
    #!/usr/bin/bash
    printf '\e]8;;https://universal-blue.discourse.group/docs?topic=42\e\\Click here to view the Universal Blue just documentation\e]8;;\e\\\n'
    /usr/bin/ujust --list --list-heading $'Available commands:\n' --list-prefix $' - '

# Imports
