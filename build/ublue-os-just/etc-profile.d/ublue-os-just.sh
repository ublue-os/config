# Add a custom justfile to users with home directories which lack a justfile.

if [ ! -z "$HOME" ] && [ -d "$HOME" ] && [ ! -f "${HOME}/.justfile" ]; then
  cat > "${HOME}/.justfile" << EOF
# You can add your own commands here!
# These commands are separate from the ujust commands.
# Learn more about just at https://github.com/casey/just

# Choose
_default:
  just --choose

# Edit the justfile
edit: 
  just -e
EOF
fi
