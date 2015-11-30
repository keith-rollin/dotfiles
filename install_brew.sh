#!/bin/bash

# Install homebrew (if missing) or update it (if not). Install or update
# desired packages. Also install/update cask along with desired packages.
#
# See https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/El_Capitan_and_Homebrew.md
# regarding being able to install into /usr/local. Because of the SIP issue on
# El Capitan and because I've got other things installing themselves into
# /usr/local, I'm installing homebrew into its own dedicated directory.

# First check to see if it's already installed. If not, prepare a place for it
# and install it.

if ! is_executable brew
then
    echo "*** Installing Homebrew"

    # Download the brew installer script.

    INSTALLER="/tmp/install"
    curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install" \
        -o "$INSTALLER" # (Should check for errors.)

    # If HOMEBREW_PREFIX and/or HOMEBREW_CACHE are defined, substitute them
    # into the installer script.

    if [[ -n "$HOMEBREW_PREFIX" ]]
    then
        sed -E -i '' \
            -e "s#(HOMEBREW_PREFIX[[:space:]]*=[[:space:]]*).*#\1'$HOMEBREW_PREFIX'#" \
            "$INSTALLER"
    fi
    if [[ -n "$HOMEBREW_CACHE" ]]
    then
        sed -E -i '' \
            -e "s#(HOMEBREW_CACHE[[:space:]]*=[[:space:]]*).*#\1'$HOMEBREW_CACHE'#" \
            "$INSTALLER"
    fi

    # Run and remove the installer.

    ruby "$INSTALLER"
    rm "$INSTALLER"
fi


# Second, install the apps we want.

if is_executable brew
then
    # Make sure this exists; homebrew doesn't seem to do that.
    mkdir -p "$HOMEBREW_TEMP"

    echo "*** Updating Homebrew"
    brew update

    echo "*** Upgrading installed Homebrew apps"
    brew upgrade

    echo "*** Installing new Homebrew apps"

    # Some tools to consider from:
    #
    #   https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
    #
    # coreutils, moreutils, findutils, gnu-sed, bash, bash-completion2, wget,
    # vim, grep, openssh, screen, git, git-lfs, lynx, pigz, pv, speedtest-cli,
    # zopfli

    apps=(
        ack
        brew-cask
        git-crypt
        hub
        shellcheck
        ssh-copy-id
        tree
    )
    casks=(
        # 1Password doesn't work with Homebrew-cask-installed versions of these
        # browsers.
        #firefox
        #google-chrome

        # Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
        # TODO: Add suspicious-package when unar is fixed. See
        # https://github.com/caskroom/homebrew-cask/issues/15025

        betterzipql
        qlcolorcode
        qlmarkdown
        qlprettypatch
        qlstephen
        quicklook-csv
        quicklook-json
    )

    brew tap caskroom/cask
    brew install "${apps[@]}"
    brew cask install "${casks[@]}"
    qlmanage -r &> /dev/null
fi
