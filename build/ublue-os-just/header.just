set allow-duplicate-recipes := true
set ignore-comments := true

_default:
    @just --list --list-heading $'Available commands:\n' --list-prefix $' - '
