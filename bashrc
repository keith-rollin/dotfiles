#!/bin/bash

# Some sources for what follows:
#
#   https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
#   https://github.com/webpro/dotfiles
#   https://github.com/mathiasbynens/dotfiles

# Define some functions up front. Normally, function definitions are placed
# later in this file, but we'll need to call these functions before they're
# defined, so they're moved to the top of the file.

function is_executable()
{
    # Determine if the given command is an actual command, alias, or shell
    # function -- that is, if it's something we can invoke.

    command -v "$1" &> /dev/null
}

function maybe_resolve()
{
    # If `realpath.sh` is available, use it to resolve the given path into a
    # full, real path (no relative directories, no symlinks). (In checking,
    # hardcode a check for realpath being in ${HOME}/bin, since ${HOME}/bin
    # might not be in $PATH yet.) Otherwise, just return what we're given.

    if is_executable realpath.sh
    then
        realpath.sh "$1"
    elif is_executable "$HOME/bin/realpath.sh"
    then
        "$HOME/bin/realpath.sh" "$1"
    else
        echo ""
    fi
}

function maybe_source
{
    # `source` a file if it exists, is readable, and doesn't look like binary.

    [[ -r "$1" && "$(file -b "$1")" != "data" ]] && source "$1"
}

function prepend_path()
{
    # Prepend the given path to PATH, resolving any links if necessary.

    local p="$(maybe_resolve "$1")"
    if [[ -n "$p" ]]
    then
        export PATH="$p:${PATH}"
    fi
}

# Bring in color definitions for PS1.
maybe_source "${HOME}/dotfiles/bashrc.console"

# Environment
export EDITOR=vim
export HISTTIMEFORMAT="%F %T: "
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';
export PS1="${FgiRed}${UserName}@${ShortHost}:${WorkingDirPath}${Reset}\n${StdPromptPrefix} "

# Applications
export GREP_OPTIONS="--color=auto --devices=skip --exclude='ChangeLog*' --exclude='*.pbxproj' --exclude-dir=.git --exclude-dir=.svn $GREP_OPTIONS"
export LESS="-IMR $LESS"
export LS_OPTIONS="-AFGhv $LS_OPTIONS"

# Homebrew. Define these before PATH, since we'll be putting one of them into
# it.
p="$(maybe_resolve "${HOME}/dev/brew")"
if [[ -n "$p" ]]
then
    export HOMEBREW_PREFIX="$p"
    export HOMEBREW_BIN="${HOMEBREW_PREFIX}/bin"
    export HOMEBREW_CACHE="${HOMEBREW_PREFIX}/cache"
    export HOMEBREW_TEMP="${HOMEBREW_PREFIX}/tmp"
fi
unset p

# $PATH.
prepend_path "${HOME}/bin"
prepend_path "${HOME}/dev/WebKit/OpenSource/Tools/Scripts"
prepend_path "${HOME}/dev/depot_tools"
prepend_path "${HOMEBREW_BIN}"

# Aliases
alias ll="ls -o"
alias la="ls -ao"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias df="df -h"
alias du="du -hs"
alias tree="tree -aCF -I '.git'"
alias gitp="git --no-pager"
alias cleanupds="find -x . -type f -name '*.DS_Store' -print -delete"
alias localip="ipconfig getifaddr en0"
alias show_hidden="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide_hidden="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias show_desktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hide_desktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias badge="tput bel"
alias lmk="say 'Process complete.'"
alias reload='source ~/.bash_profile'

# Shell
shopt -s cdspell
shopt -s checkwinsize
shopt -s nocaseglob
#shopt -s autocd
#shopt -s dirspell
#shopt -s globstar

# Functions

f()   { find .         -iname "$1";   }     # find
ff()  { find . -type f -iname "$1";   }     # find file
fff() { find . -type f -iname "*$1*"; }     # fuzzy find file
fd()  { find . -type d -iname "$1";   }     # find directory
ffd() { find . -type d -iname "*$1*"; }     # fuzzy find directory

function sudo_keep_alive()
{
    # Go into sudo mode and stay in sudo mode until the current script quits.
    # (I copied this function from somewhere else. The "sudo -n true" comes
    # from that source. I don't know why it's not "sudo -v".)

    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until this script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

function mkcd()
{
    # Create a new directory and enter it

    mkdir -p "$@" && cd "$@" || exit
}

function cdf()
{
    # Change working directory to the top-most Finder window location

    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')" || exit
}

function fs()
{
    # Determine size of a file or total size of a directory

    if du -b /dev/null > /dev/null 2>&1
    then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]
    then
        du $arg -- "$@"
    else
        du $arg .[^.]* ./*
    fi
}

function gdiff()
{
    # Use Git’s colored diff

    git diff --no-index --color-words "$@";
}

function bak()
{
    # Make backups of the given files (copy them to *.bak)

    local f
    for f in "$@"
    do
        cp -p "$f" "$f.bak"
    done
}

function path()
{
    # Show the PATH, one entry per line.

    echo "$PATH" | tr : '\n'
}

function up()
{
    # Move up to named parent directory, using fuzzy matching.
    # Inspired by `up`: http://brettterpstra.com/2014/05/14/up-fuzzy-navigation-up-a-directory-tree/
    # inspired by `bd`: https://github.com/vigneshwaranr/bd

    if [ $# -eq 0 ]
    then
        echo "up: traverses up the current working directory to first match and cds to it"
        echo "You need an argument"
    else
        local rx=$(echo "$1" | sed -e "s/\s\+//g" -e "s/\(.\)/\1[^\/]*/g")
        local p="$(echo -n "$(pwd | sed -e "s/\(.*\/[^\/]*${rx}\)\/.*/\1/")")"
        cd "$p" || exit
    fi
}

function gt()
{
    # Go To Git Top

    cd $(git rev-parse --show-toplevel 2>/dev/null || (echo '.'; echo "Not within a git repository" >&2))
}

# Bring in git completion.
maybe_source "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash"

# Bring in additional (private) definitions.
maybe_source "${HOME}/dotfiles/bashrc.private"
