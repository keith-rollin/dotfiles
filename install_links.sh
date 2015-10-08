#!/bin/bash

create_link()
{
	local source="${HOME}/dotfiles/$1"
	local target="${HOME}/$2"

	[ -e ${target} -a ! -L ${target} ] && { echo "### File ${target} exists and is not a link. Please move it aside."; return; }

	rm -f ${target}
	ln -s ${source} ${target}
}

clone_file()
{
	local source="${HOME}/dotfiles/$1"
	local target="${HOME}/$2"

	[ -e ${target} ] && { echo "### File ${target} exists. Please move it aside."; return; }

	cp ${source} ${target}
	echo "### File ${target} created. Please edit it."
}

create_link vim .vim
create_link vimrc .vimrc
create_link bash.console.sh .bash.console.sh
create_link bashrc .bashrc
create_link bash_profile .bash_profile

clone_file gitconfig .gitconfig
