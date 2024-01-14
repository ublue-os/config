set allow-duplicate-recipes := true
set ignore-comments := true

_default:
    #!/usr/bin/bash
    source /usr/libexec/ujust/libformatting.sh
    echo "$(Urllink "https://universal-blue.discourse.group/docs?topic=42" "Click here to view the Universal Blue just documentation")"
    /usr/bin/ujust --list --list-heading $'Available commands:\n' --list-prefix $' - '

# Imports
