#!/bin/bash

# Install everything, including dotfiles, Vundle, brew, and prefs.

HERE="$(dirname "$0")"
HERE="$("$HERE/bin/realpath.sh" "$HERE")"

# Get some handy functions defined.
source "$HERE/bashrc"

# Go into sudo mode and keep it alive.
sudo_keep_alive

create_link()
{
    local source="${HERE}/$1"
    local target="${HOME}/$2"

    [[ -e "${target}" && ! -L "${target}" ]] && { echo "### File ${target} exists and is not a link. Please move it aside."; return; }

    rm -f "${target}"
    ln -s "${source}" "${target}"
}

create_link bash_profile    .bash_profile
create_link bashrc          .bashrc
create_link bin             bin
create_link gitconfig       .gitconfig
create_link inputrc         .inputrc
create_link vim             .vim
create_link vimrc           .vimrc

# Make sure Vundle.vim is not in a "detached HEAD" state.
(
    echo "*** Updating Vundle"
    cd "${HERE}/vim/bundle/Vundle.vim" || exit
    git checkout master
)

maybe_source "${HERE}/install_brew.sh"
maybe_source "${HERE}/install_prefs.sh"
