#!/bin/bash

create_link()
{
	local source="${HOME}/dotfiles/$1"
	local target="${HOME}/$2"

	[ -e ${target} -a ! -L ${target} ] && { echo "### File ${target} exists and is not a link. Please move it aside."; return; }

	rm -f ${target}
	ln -s ${source} ${target}
}

create_link bash.console.sh .bash.console.sh
create_link bash_profile    .bash_profile
create_link bashrc          .bashrc
create_link gitconfig       .gitconfig
create_link vim             .vim
create_link vimrc           .vimrc

# Make sure Vundle.vim is not in a "detached HEAD" state.
cd "${HOME}/dotfiles/vim/bundle/Vundle.vim"
git checkout master
