#!/bin/bash

# Install everything, including dotfiles, Vundle, brew, and prefs.

HERE="$(dirname "$0")"

REALPATH="$HERE/bin/realpath.sh"
LNS="$HERE/bin/lns"
HERE="$("$REALPATH" "$HERE")"

# Get some handy functions defined.
source "$HERE/bashrc"

create_link()
{
    [[ "$1" == "." ]] && local source="${HERE}" || local source="${HERE}/$1"
    [[ "$2" == "." ]] && local target="${HOME}" || local target="${HOME}/$2"

    [[ -e "${target}" && ! -L "${target}" ]] && {
        echo "### File ${target} exists and is not a link. Please move it aside.";
        return;
    }

    rm -f "${target}"
    "$LNS" "${source}" "${target}" > /dev/null
}

create_link bash_profile    .bash_profile
create_link bashrc          .bashrc
create_link bin             bin
create_link .               dotfiles
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

if [[ "$1" == "--all" ]]
then
    maybe_source "${HERE}/install_brew.sh"
    maybe_source "${HERE}/install_prefs.sh"
fi
