#!/bin/bash

# Some sources for what follows:
#
#   https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
#   https://github.com/webpro/dotfiles
#   https://github.com/mathiasbynens/dotfiles

# Define some functions up front. Normally, function definitions are placed
# later in this file, but we'll need to call these functions before they're
# defined, so they're moved to the top of the file.

ME="$(readlink "${BASH_SOURCE[0]}")"
[[ -n "${ME}" ]] || ME="${BASH_SOURCE[0]}"
HERE="$(dirname "${ME}")"

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
    elif is_executable "${HERE}/bin/realpath"
    then
        "${HERE}/bin/realpath" "$1"
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

maybe_source "${HERE}/bashrc.console"

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

export DEV_PATH="$(maybe_resolve "${HOME}/dev")"

# $PATH.

BREW_PATH="$(maybe_resolve "${DEV_PATH}/brew")"
if [[ -n "${BREW_PATH}" ]]
then
    prepend_path "${BREW_PATH}/sbin"
    prepend_path "${BREW_PATH}/bin"
fi
unset BREW_PATH

prepend_path "${HERE}/bin"

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
function .....() { cd ../../../.. ; }
function ......() { cd ../../../../.. ; }

function show_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder ; }
function hide_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder ; }
function show_desktop() { defaults write com.apple.finder CreateDesktop -bool true && killall Finder ; }
function hide_desktop() { defaults write com.apple.finder CreateDesktop -bool false && killall Finder ; }

function f()   { find -x .         -iname "$1" 2> /dev/null;   }     # find
function ff()  { find -x . -type f -iname "$1" 2> /dev/null;   }     # find file
function fff() { find -x . -type f -iname "*$1*" 2> /dev/null; }     # fuzzy find file
function fd()  { find -x . -type d -iname "$1" 2> /dev/null;   }     # find directory
function ffd() { find -x . -type d -iname "*$1*" 2> /dev/null; }     # fuzzy find directory

function badge() { tput bel ; }
function cleanupds() { find -x . -type f -name '*.DS_Store' -print -delete ; }
function gitp() { git --no-pager "$@" ; }
function la() { ll -A "$@" ; }
function lart() { ls -lArt "$@" ; }
function ll() { ls -o "$@" ; }
function lmk() { say 'Process complete.' ; }
function notify() { osascript -e "display notification \"$1\" with title \"$2\"" ; }
function reload() { source ~/.bash_profile ; }

function ascii()
{
    #man ascii | col -b | grep -A 55 --color=never "octal set"
    cat /usr/share/misc/ascii
}

function at_home()
{
    ! at_work
}

function at_work()
{
    # This is not a good test. It tells me where I am, not whether I'm using a
    # home or work computer.
    #[[ $(curl -s v4.ifconfig.co) =~ 17\..*\..*\..* ]]

    # Test for a volume I only have on work systems.
    [[ -d /Volumes/Data ]]
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

function cdf()
{
    # Change working directory to the top-most Finder window location.

    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

function delete-brew()
{
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
}

function edit-ff()
{
    vi $(ff "$1")
}

function edit-fff()
{
    vi $(fff "$1")
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

function git-diff()
{
    # Use Git’s colored diff.

    git diff --no-index --color-words "$@";
}

function git-edit-changed()
{
    local OLD_CWD="$(pwd)"
    git-top
    vi $(git diff --name-only)
    cd "${OLD_CWD}"
}

function git-edit-files-with-symbol()
{
    vi $(git grep --name-only "$1")
}

function git-top()
{
    # Go To Git Top.

    cd $(git rev-parse --show-toplevel 2>/dev/null || (echo '.'; echo "Not within a git repository" >&2))
}

function mkcd()
{
    # Create a new directory and enter it.

    mkdir -p "$@" && cd "$@"
}

# l(ist)ips: Get local and WAN IP addresses
# From: http://brettterpstra.com/2017/10/30/a-few-new-shell-tricks/

lips()
{
    # Process the output from `networksetup -listallhardwareports`
    #
    #   Hardware Port: Ethernet 1
    #   Device: en0
    #   Ethernet Address: 00:3e:e1:c7:72:39
    #
    #  ...

    local KEY VALUE PORT DEVICE IP EXTIP
    while IFS=':' read KEY VALUE
    do
        # Remove the leading space from the 'VALUE' left over from splitting
        # the string on the ':'.
        VALUE="${VALUE:1}"

        [[ "$KEY" == "Hardware Port" ]] && PORT="$VALUE"
        [[ "$KEY" == "Device" ]]        && DEVICE="$VALUE"
        if [[ -n "$PORT" && -n "$DEVICE" ]]
        then
            IP=$(ipconfig getifaddr $DEVICE)
            [[ "$IP" != "" ]] && printf "%20s: %s (%s)\n" "$PORT" "$IP" "$DEVICE" # len("Thunderbolt Ethernet") == 20
            PORT=""
            DEVICE=""
        fi
    done < <(networksetup -listallhardwareports)

    IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
    [[ "$IP" != "" ]] && EXTIP=$IP || EXTIP="inactive"

    printf '%20s: %s\n' "External IP" $EXTIP
}

function on_ac_power()
{
    pmset -g ps | grep -q "AC Power"
}

function on_battery_power()
{
    pmset -g ps | grep -q "Battery Power"
}

function path()
{
    # Show the PATH, one entry per line.

    echo "$PATH" | tr : '\n'
}

function rg()
{
    command rg -g '!ChangeLog*' "$@"
}

function search_goog()
{
    open https://www.google.com/search?q=$(echo "$@" | tr ' ' +)
}

function search_wiki()
{
    open https://en.wikipedia.org/w/index.php?search=$(echo "$@" | tr ' ' +)
}

function sudo_keep_alive()
{
    # Go into sudo mode and stay in sudo mode until the current script quits.
    # (I copied this function from somewhere else. The "sudo -n true" comes
    # from that source. I don't know why it's not "sudo -v".)

    # Ask for the administrator password upfront

    sudo -v

    # Keep-alive: update existing `sudo` time stamp until this script has
    # finished.

    while true
    do
        sudo -n true
        sleep 60
        kill -0 "$$" || return
    done 2>/dev/null &
}

function up()
{
    # Move up to named parent directory, using fuzzy matching.
    # Inspired by `up`: http://brettterpstra.com/2014/05/14/up-fuzzy-navigation-up-a-directory-tree/
    # inspired by `bd`: https://github.com/vigneshwaranr/bd

    if [[ $# -eq 0 ]]
    then
        echo "up: traverses up the current working directory to first match and cds to it"
        echo "You need an argument"
    else
        local rx=$(echo "$1" | sed -e "s/\s\+//g" -e "s/\(.\)/\1[^\/]*/g")
        local p="$(echo -n "$(pwd | sed -e "s/\(.*\/[^\/]*${rx}\)\/.*/\1/")")"
        cd "$p"
    fi
}

function urlencode()
{
    python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])" "$1"
}

function utcdate()
{
    TZ=utc date
}

function vi()
{
    # Open a file in vim, converting any parameter like this:
    #
    #   path/to/file.cpp:62
    #
    # Into:
    #
    #   path/to/file.cpp +62

    local CMD="command vi"
    local p
    for p in "$@"
    do
        if [[ "$p" =~ .*:.* ]]
        then
            CMD="$CMD $(echo $p | sed -e 's/\(.*\):\(.*\)/"\1" +\2/')"
        else
            CMD="$CMD \"$p\""
        fi
    done

    eval $CMD
}

function wip()
{
    git commit -a -m wip
}

# Bring in bash completion.

is_executable xcode-select && maybe_source "$(xcode-select -p)/usr/share/git-core/git-completion.bash"

if is_executable brew
then
    HOMEBREW_COMPLETION_DIR="$(brew --prefix)/etc/bash_completion.d"
    [[ -d "${HOMEBREW_COMPLETION_DIR}" ]] && source "${HOMEBREW_COMPLETION_DIR}/"*
fi

# Bring in ssh keys.

[[ -z "$SSH_AUTH_SOCK" ]] && eval "$(ssh-agent -s)" &> /dev/null
ssh-add ~/.ssh/id_rsa &> /dev/null
ssh-add ~/.ssh/id_keith-rollin@github &> /dev/null
#ssh-add ~/.ssh/id_github &> /dev/null
#ssh-add -A &> /dev/null    # Slow...don't use unless you have to.

if is_executable brew
then
    # Bring in pyenv.

    if is_executable pyenv
    then
        export PYENV_ROOT="$(brew --prefix)/var/pyenv"
        eval "$(pyenv init -)"
    fi

    # Bring in swiftenv.

    if is_executable swiftenv
    then
        export SWIFTENV_ROOT="$(brew --prefix)/var/swiftenv"
        eval "$(swiftenv init -)"
    fi
fi
