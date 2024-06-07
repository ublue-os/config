alias brew := install-brew

# Install Homebrew | https://brew.sh
install-brew:
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    if [[ ! -f "/var/home/linuxbrew/.linuxbrew/bin" || ! -x "/var/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        echo "${b}Brew Installation${n}"
        echo "Please ${b}IGNORE${n} everything the installer tells you to do at the end"
        echo "We have already done it for you! You just need to close and re-open the terminal after installation"
        echo "Do you understand?"
        echo "Please type in \"YES I UNDERSTAND\" and press enter"
        read ACCEPT
        if [ "$ACCEPT" == "YES I UNDERSTAND" ]; then
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
          echo "Capitalization matters when you type \"YES I UNDERSTAND\""
        fi
    fi
    # if /etc/profile.d/brew.sh already exists, replace it with /usr/etc/profile.d/brew.sh
    if [ -f /etc/profile.d/brew.sh ]; then
        if [ -f /usr/etc/profile.d/brew.sh ]; then
            sudo cp /usr/etc/profile.d/brew.sh /etc/profile.d/brew.sh
        fi
    fi

# Removes homebrew from system
remove-brew:
    echo "Removing homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

alias brew-command-not-found := install-brew-command-not-found

# Suggest Homebrew packages to install when a command is not found
install-brew-command-not-found:
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    if ! brew -h > /dev/null; then
      echo "Install Homebrew with ${b}ojust install-brew${n} first!"
      exit 
    fi
    HOMEBREW_NO_ENV_HINTS=true brew tap homebrew/command-not-found
    sudo tee /etc/profile.d/brew-command-not-found.sh > /dev/null <<EOF
    # Check for interactive bash or zsh and that we haven't already been sourced
    if [ "x${BASH_VERSION-}" != x -o "x${ZSH_VERSION-}" != x ] && [ "x${PS1-}" != x -a "x${BREW_COMMAND_NOT_FOUND-}" = x ]; then
      HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
      if [ -f "$HB_CNF_HANDLER" ]; then
        source "$HB_CNF_HANDLER"
      fi
      export BREW_COMMAND_NOT_FOUND=1
    fi
    EOF
    sudo tee /etc/fish/conf.d/homebrew-command-not-found.fish > /dev/null <<EOF
    set HB_CNF_HANDLER (brew --repository)"/Library/Taps/homebrew/homebrew-command-not-found/handler.fish"
    if test -f $HB_CNF_HANDLER
      source $HB_CNF_HANDLER
    end
    EOF
    echo Suggestions will begin when you start a new terminal session.
