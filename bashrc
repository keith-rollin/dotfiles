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
    # If `realpath` is available, use it to resolve the given path into a full,
    # real path (no relative directories, no symlinks). (In checking, hardcode
    # a check for realpath being in ${HOME}/bin, since ${HOME}/bin might not be
    # in $PATH yet.) Otherwise, just return what we're given.

    if is_executable realpath
    then
        realpath "$1"
    elif is_executable "$HOME/bin/realpath"
    then
        "$HOME/bin/realpath" "$1"
    else
        echo ""
    fi
}

function maybe_source()
{
    # `source` a file if it exists, is readable, and doesn't look like binary.

    [[ -r "$1" && "$(file -b "$1")" != "data" ]] && source "$1"
}

function prepend_path()
{
    # Prepend the given path to PATH if it's not already there, resolving any
    # links if necessary.

    local p="$(maybe_resolve "$1")"
    [[ -z "$p" ]] && return 0
    [[ "${PATH}" =~ .*$p:.* ]] && return 0
    export PATH="$p:${PATH}"
}

# Bring in color definitions for PS1.

maybe_source "${HOME}/dotfiles/bashrc.console"

# Environment.
#
# We need to force SHELL_SESSION_HISTORY to 1 in order to override the default
# behavior where per-session shell histories are disabled if HISTTIMEFORMAT is
# defined.

export EDITOR=vim
export HISTTIMEFORMAT="%F %T: "
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';
export LESS=-IMR
export PS1="${FgiRed}${UserName}@${ShortHost}:${WorkingDirPath}${Reset}\n${StdPromptPrefix} "
export SHELL_SESSION_HISTORY=1

# Homebrew. Define these before PATH, since we'll be putting one of them into
# it.

p="$(maybe_resolve "${HOME}/dev/brew")"
if [[ -n "$p" ]]
then
    export HOMEBREW_PREFIX="$p"
    export HOMEBREW_BIN="${HOMEBREW_PREFIX}/bin"
    export HOMEBREW_CACHE="${HOMEBREW_PREFIX}/cache"
    export HOMEBREW_TEMP="${HOMEBREW_PREFIX}/tmp"
    export HOMEBREW_CASK_OPTS="--caskroom=\"${HOMEBREW_PREFIX}/Caskroom\""
fi
unset p

# $PATH.

prepend_path "${HOME}/bin"
prepend_path "${HOME}/dev/WebKit/OpenSource/Tools/Scripts"
prepend_path "${HOME}/dev/depot_tools"
prepend_path "${HOMEBREW_BIN}"

# Shell.

shopt -s cdspell
shopt -s checkwinsize
shopt -s nocaseglob
#shopt -s autocd
#shopt -s dirspell
#shopt -s globstar

# Functions. The first of these are dangerous, since they replace/alias/hide
# underlying commands with the same name.
#
# UPDATE: I've had to disable the "less" function and revert to specifying
# options in the LESS environment variable. I had moved to using a "less"
# function for consistency with the way I modified other standard commands, but
# this had problems with "git". In particular, "git" felt free to pass "-FRX"
# to less, which messed up with my preferred way of handling the altscreen.
# Moving (back) to defining my options in LESS inhibited git from setting its
# own options, thereby restoring my preferred handling of the altscreen.

function df() { command df -h "$@" ; }
function du() { command du -hs "$@" ; }
function grep() { command grep --color=auto --devices=skip --exclude='ChangeLog*' --exclude='*.pbxproj' --exclude-dir=.git --exclude-dir=.svn "$@" ; }
#function less() { command less -IMR "$@" ; }
function ls() { command ls -FGhv "$@" ; }
function tree() { command tree -aCF -I '.git' "$@" ; }

function ..() { cd .. ; }
function ...() { cd ../.. ; }
function ....() { cd ../../.. ; }

function show_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder ; }
function hide_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder ; }
function show_desktop() { defaults write com.apple.finder CreateDesktop -bool true && killall Finder ; }
function hide_desktop() { defaults write com.apple.finder CreateDesktop -bool false && killall Finder ; }

function f()   { find -x .         -iname "$1" 2> /dev/null;   }     # find
function ff()  { find -x . -type f -iname "$1" 2> /dev/null;   }     # find file
function fff() { find -x . -type f -iname "*$1*" 2> /dev/null; }     # fuzzy find file
function fd()  { find -x . -type d -iname "$1" 2> /dev/null;   }     # find directory
function ffd() { find -x . -type d -iname "*$1*" 2> /dev/null; }     # fuzzy find directory

function ackc() { ack --type cc "$@" ; }
function ackcpp() { ack --type cpp "$@" ; }
function badge() { tput bel ; }
function cleanupds() { find -x . -type f -name '*.DS_Store' -print -delete ; }
function gitp() { git --no-pager "$@" ; }
function la() { ll -A "$@" ; }
function ll() { ls -o "$@" ; }
function lmk() { say 'Process complete.' ; }
function localip() { ipconfig getifaddr en0 ; }
function reload() { source ~/.bash_profile ; }

function sudo_keep_alive()
{
    # Go into sudo mode and stay in sudo mode until the current script quits.
    # (I copied this function from somewhere else. The "sudo -n true" comes
    # from that source. I don't know why it's not "sudo -v".)

    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until this script has
    # finished.
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

function mkcd()
{
    # Create a new directory and enter it.

    mkdir -p "$@" && cd "$@" || exit
}

function cdf()
{
    # Change working directory to the top-most Finder window location.

    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')" || exit
}

function fs()
{
    # Determine size of a file or total size of a directory.

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
    # Use Git’s colored diff.

    git diff --no-index --color-words "$@";
}

function bak()
{
    # Make backups of the given files (copy them to *.bak).

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
    # Go To Git Top.

    cd $(git rev-parse --show-toplevel 2>/dev/null || (echo '.'; echo "Not within a git repository" >&2))
}

function goog()
{
    open https://www.google.com/search?q=$(echo "$@" | tr ' ' +)
}

function wiki()
{
    open https://en.wikipedia.org/w/index.php?search=$(echo "$@" | tr ' ' +)
}

# Bring in git completion.

is_executable xcode-select && maybe_source "$(xcode-select -p)/usr/share/git-core/git-completion.bash"

# Bring in ssh keys.

[[ -z "$SSH_AUTH_SOCK" ]] && eval "$(ssh-agent -s)" &> /dev/null
ssh-add &> /dev/null
ssh-add ~/.ssh/id_github &> /dev/null

# Bring in additional (private) definitions.

maybe_source "${HOME}/dotfiles/bashrc.private"
