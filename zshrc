# Some sources for what follows:
#
#   https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
#   https://github.com/webpro/dotfiles
#   https://github.com/mathiasbynens/dotfiles

# Get the path to this script so that we can find local resources.

ME_BASE="${(%):-%N}"
ME="$(readlink "${ME_BASE}")"
[ -n "${ME}" ] || ME="${ME_BASE}"
DOTFILES="$(dirname "${ME}")"
unset ME ME_BASE

# Functions.

duh() { sudo du -h -d 1 ; }
duk() { sudo du -k -d 1 ; }
dum() { sudo du -m -d 1 ; }
dug() { sudo du -g -d 1 ; }
duh2() { sudo du -h -d 2 ; }
duk2() { sudo du -k -d 2 ; }
dum2() { sudo du -m -d 2 ; }
dug2() { sudo du -g -d 2 ; }

..() { cd .. ; }
...() { cd ../.. ; }
....() { cd ../../.. ; }
.....() { cd ../../../.. ; }
......() { cd ../../../../.. ; }

f()   { find -x .         -iname "$1" 2> /dev/null;   }     # find
ff()  { find -x . -type f -iname "$1" 2> /dev/null;   }     # find file
fff() { find -x . -type f -iname "*$1*" 2> /dev/null; }     # fuzzy find file
fd()  { find -x . -type d -iname "$1" 2> /dev/null;   }     # find directory
ffd() { find -x . -type d -iname "*$1*" 2> /dev/null; }     # fuzzy find directory

grep() { grep_core "$@" ; }
egrep() { grep_core "$@" ; }
fgrep() { grep_core "$@" ; }

v() { vim_core "$@" }
vi() { vim_core  "$@" }
vim() { vim_core  "$@" }
nvim() { vim_core  "$@" }

show_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder ; }
hide_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder ; }
show_desktop() { defaults write com.apple.finder CreateDesktop -bool true && killall Finder ; }
hide_desktop() { defaults write com.apple.finder CreateDesktop -bool false && killall Finder ; }

set_ls_options()
{
    if is_executable eza
    then
        LS_DATETIME_FORMAT="--time-style=long-iso"
        LS_EXECUTABLE="eza"
        LS_GIT_PROPS=""         # "--git" This is way too slow on large projects like WebKit or CyberArts
        LS_HIDE_GROUP=""
        LS_NATURAL_SORT=""
        LS_SHOW_COLOR=""
        LS_SHOW_EXTENDED_ATTRIBUTE_KEYS="-@"
        LS_SHOW_FILE_KIND_INDICATORS="-F"
        LS_SHOW_HIDDEN="-a"
        LS_SHOW_HUMAN_READABLE=""
        LS_SORT_BY_TIME=(-s modified)
    else
        LS_DATETIME_FORMAT=""
        LS_EXECUTABLE="/bin/ls"
        LS_GIT_PROPS=""
        LS_HIDE_GROUP="-o"
        LS_NATURAL_SORT="-v"
        LS_SHOW_COLOR="-G"
        LS_SHOW_EXTENDED_ATTRIBUTE_KEYS="-@"
        LS_SHOW_FILE_KIND_INDICATORS="-F"
        LS_SHOW_HIDDEN="-A"
        LS_SHOW_HUMAN_READABLE="-h"
        LS_SORT_BY_TIME=(-r -t)
    fi
}

la()        { set_ls_options; ls_common -l ${LS_DATETIME_FORMAT} ${LS_SHOW_HIDDEN} "$@" ; }
lart()      { set_ls_options; ls_common -l ${LS_DATETIME_FORMAT} ${LS_SHOW_HIDDEN} ${LS_SORT_BY_TIME[@]} "$@" ; }
lax()       { set_ls_options; ls_common -l ${LS_DATETIME_FORMAT} ${LS_SHOW_HIDDEN} ${LS_SHOW_EXTENDED_ATTRIBUTE_KEYS} "$@" ; }
ll()        { set_ls_options; ls_common -l ${LS_DATETIME_FORMAT} "$@" ; }
llx()       { set_ls_options; ls_common -l ${LS_DATETIME_FORMAT} ${LS_SHOW_EXTENDED_ATTRIBUTE_KEYS} "$@" ; }
ls()        { set_ls_options; ls_common "$@" ; }
ls_common() {
    "${LS_EXECUTABLE}" \
        ${LS_SHOW_FILE_KIND_INDICATORS} \
        ${LS_GIT_PROPS} \
        ${LS_HIDE_GROUP} \
        ${LS_NATURAL_SORT} \
        ${LS_SHOW_COLOR} \
        ${LS_SHOW_HUMAN_READABLE} \
        "$@"
    }

ga()   { git add "$@" ; }
gap()  { git add -p "$@" ; }
gc()   { git commit "$@" ; }
gca()  { git commit -a ; }
gcam() { git commit -am "$@" ; }
gd()   { git diff "$@" ; }
gl()   { git log "$@" ; }
glp()  { git log -p "$@" ; }
grc()  { git rebase --continue ; }
grm()  { git rebase master ; }
gs()   { git status "$@" ; }

bak()
{
    # Make backups of the given files (copy them to *.bak).

    local f
    for f in "$@"
    do
        f=${f%%/}
        ditto "$f" "$f.bak"
    done
}

brew_path()
{
    # If brew is on the path (for whatever reason), ask it where it is.

    if is_executable brew
    then
        brew --prefix
        return
    fi

    # If brew is not on the path, then used some code cribbed from brew's
    # installer to determine its location.

    # (This conditional code is taken from homebrew's install.sh.)
    local UNAME_MACHINE="$(/usr/bin/uname -m)"
    if [[ "${UNAME_MACHINE}" == "arm64" ]]
    then
        # On ARM macOS, this script installs to /opt/homebrew only
        local HOMEBREW_PREFIX="/opt/homebrew"
    else
        # On Intel macOS, this script installs to /usr/local only
        local HOMEBREW_PREFIX="/usr/local"
    fi
    echo "${HOMEBREW_PREFIX}"
}

cdd()
{
    cd "${DOTFILES}"
}

cdf()
{
    # Change working directory to the top-most Finder window location.

    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

cleanupds()
{
    local locations=(
        /Applications
        /bin
        /cores
        /Library
        /opt
        /private
        /sbin
        /Users
        /usr
        /Volumes/Data
        /Volumes/Spare
        /Volumes/Video
    )

    if [[ "${1}" == "-n" ]]
    then
        find -x "${locations[@]}" -type f -name '.DS_Store' -print         2> /dev/null
    else
        find -x "${locations[@]}" -type f -name '.DS_Store' -print -delete 2> /dev/null
    fi
}

create_link()
{
    # Create or update links in my home directory to handy things elsewhere.

    local real_file="$1"
    local sym_file="$2"

    real_file="$("${REALPATH}" "${real_file}")"

    if [ -e "${sym_file}" -a ! -L "${sym_file}" ]
    then
        echo "### File ${sym_file} exists but is not a link. Please move it aside."
        return
    fi

    rm -f "${sym_file}"
    mkdir -p "$(dirname "${sym_file}")"
    "${LNS}" "${real_file}" "${sym_file}"
}

create_link_in_home()
{
    local real_file="$1"
    local sym_file="$2"

    [ -z "${sym_file}" ] && sym_file="$(basename "${real_file}")"

    sym_file="${HOME}/${sym_file}"

    create_link "$real_file" "$sym_file"
}

delete_brew()
{
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
}

delete_lazy()
{
    rm -rf ~/.local/{share,state}/nvim/lazy
}

delete_mason() {
    rm -rf ~/.local/share/nvim/mason
}

delete_treesitter() {
    rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser/*.so
    rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser-info/*.revision
}

dont_sleep()
{
    caffeinate -dim "$@"
}

element_in_array()
{
    # See if the first parameter matches any of the subsequent parameters. Used
    # to see if an item of interest is in an array, as in:
    #
    #   if element_in_array "item-to-find" "${array-of-items[@]}"; then ...; fi
    #
    # By "patrik" on https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value

    local element_in_array element_to_find="$1"
    shift
    for element_in_array
    do
        [ "$element_to_find" = "$element_in_array" ] && return 0
    done
    return 1
}

filter()
{
    # Given the name of a list to filter and a list of items, get the items in
    # the named list and return (echo) them if they don't appear in the given
    # list of items.
    #
    # Allow for the fact that the named list may contain items in the form
    # X/Y/Z, whereas the given items may include just Z. In that case, the
    # prefix should be ignored and the item should still be removed.

    local LIST_TO_FILTER=$1
    local ITEMS_TO_FILTER=( "${(P)${LIST_TO_FILTER}[@]}" )
    shift
    local ITEMS_TO_REMOVE="$@"

    local ITEM_TO_TEST
    for ITEM_TO_TEST in "${ITEMS_TO_FILTER[@]}"
    do
        # If ITEM_TO_TEST has a prefix("*/"), remove it. Then see if the result
        # is in ITEMS_TO_REMOVE by getting its index. If it's not there (the
        # index is zero), echo it to the caller.
        #
        # TODO: I need a good way to return an array from a function. As it is,
        # any items with spaces will be split into multiple items. Probably the
        # best thing to do is pass in the name of an array to received the
        # results and populate it indirectly. Maybe see:
        # https://stackoverflow.com/a/49971213

        (( $ITEMS_TO_REMOVE[(I)${ITEM_TO_TEST##*/}] )) || echo "${ITEM_TO_TEST}"
    done
}

git_top()
{
    # Go To Git Top.

    cd $(git rev-parse --show-toplevel 2>/dev/null || (echo '.'; echo "Not within a git repository" >&2))
}

gitp()
{
    git --no-pager "$@"
}

grep_core()
{
    local caller="${funcstack[@]:1:1}"

    command ${caller} \
        --color=auto \
        --devices=skip \
        --exclude='ChangeLog*' \
        --exclude='*.pbxproj' \
        --exclude-dir=.git \
        --exclude-dir=.svn \
        "$@"
}

hide_brew()
{
    trap "PATH=$PATH; trap - INT EXIT" INT EXIT
    export PATH="$(echo "$PATH" | sed -E -e 's|^'$(brew_path)'/bin:||')"
    export PATH="$(echo "$PATH" | sed -E -e 's|^'$(brew_path)'/sbin:||')"
    export PATH="$(echo "$PATH" | sed -E -e 's|:'$(brew_path)'/bin||g')"
    export PATH="$(echo "$PATH" | sed -E -e 's|:'$(brew_path)'/sbin||g')"
    "$@"
}

hist()
{
    history -i 0 "$@"
}

is_being_sourced()
{
    # When a script is source'd, the current context is preserved, and so
    # "file" is appended.

    [[ "$ZSH_EVAL_CONTEXT" =~ toplevel:file.* ]]
}

is_executable()
{
    # Determine if the given command is an actual command, alias, or shell
    # function -- that is, if it's something we can invoke.

    whence "$1" &> /dev/null
}

# UPDATE: I've had to disable the "less" function and revert to specifying
# options in the LESS environment variable. I had moved to using a "less"
# function for consistency with the way I modified other standard commands, but
# this had problems with "git". In particular, "git" felt free to pass "-FRX"
# to less, which messed up with my preferred way of handling the altscreen.
# Moving (back) to defining my options in LESS inhibited git from setting its
# own options, thereby restoring my preferred handling of the altscreen.

# less()
# {
#     command less -IMR "$@"
# }

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

        [ "$KEY" = "Hardware Port" ] && PORT="$VALUE"
        [ "$KEY" = "Device" ]        && DEVICE="$VALUE"
        if [ -n "$PORT" -a -n "$DEVICE" ]
        then
            IP=$(ipconfig getifaddr $DEVICE)
            [ "$IP" != "" ] && printf "%20s: %s (%s)\n" "$PORT" "$IP" "$DEVICE" # len("Thunderbolt Ethernet") == 20
            PORT=""
            DEVICE=""
        fi
    done < <(networksetup -listallhardwareports)

    IPv4=$(curl -s ifconfig.me)
    IPv6=$(curl -s icanhazip.com)
    [ -n "$IPv4" -a -n "$IPv6" ] && EXTIP="$IPv4 / $IPv6"
    [ -n "$IPv4" -a -z "$IPv6" ] && EXTIP="$IPv4"
    [ -z "$IPv4" -a -n "$IPv6" ] && EXTIP="$IPv6"
    [ -z "$IPv4" -a -z "$IPv6" ] && EXTIP="inactive"

    printf '%20s: %s\n' "External IP" $EXTIP
}

wwls () # "Words with letter sequence"
{
    # Break up the command line into individual letters.

    local all_letters=()
    while [[ -n "$1" ]];
    do
        all_letters+=( $(echo "$1" | grep -o .) )
        shift
    done

    # Create a pattern of those letters separated by .*'s.

    local pattern='.*'
    for letter in "${all_letters[@]}"
    do
        pattern+="${letter}"'.*'
    done

    # Search for words with the given letter sequence.

    grep -i "$pattern" /usr/share/dict/words \
        | awk '{ print length, $0 }' \
        | sort -nr | awk '{ print $2 }'
}

maybe_resolve()
{
    # If `realpath` is available, use it to resolve the given path into a full,
    # real path (no relative directories, no symlinks). (In checking, hardcode
    # a check for realpath being in ${HOME}/bin, since ${HOME}/bin might not be
    # in $PATH yet.) Otherwise, just return what we're given.

    if is_executable realpath
    then
        realpath "$1"
    elif is_executable "${DOTFILES}/bin/realpath"
    then
        "${DOTFILES}/bin/realpath" "$1"
    else
        echo ""
    fi
}

maybe_source()
{
    # `source` a file if it exists, is readable, and doesn't look like binary.

    [ -r "$1" -a "$(file -b "$1")" != "data" ] && . "$1"
}

maybe_run()
{
    if is_executable "$1"
    then
        "$@"
    else
        return 1
    fi
}

mkcd()
{
    # Create a new directory and enter it.

    mkdir -p "$@" && cd "$@"
}

path()
{
    # Show the PATH, one entry per line.

    echo "$PATH" | tr : '\n'
}

preman() {
    mandoc -T pdf "$(/usr/bin/man -w $@)" | open -fa Preview
}

prepend_path()
{
    [ -e "$1" ] || return 0

    # Prepend the given path to PATH if it's not already there, resolving any
    # links if necessary.

    local p="$(maybe_resolve "$1")"
    [ -z "$p" ] && return 0

    element_in_array "$p" "${path[@]}" && return 0
    path=("$p" "${path[@]}")
}

py()
{
    maybe_run "/usr/local/opt/python@3.12/bin/python3.12" "$@" || \
    maybe_run "/usr/local/opt/python@3.11/bin/python3.11" "$@" || \
    maybe_run "/usr/local/opt/python@3.10/bin/python3.10" "$@" || \
    maybe_run "/usr/local/bin/python3" "$@" || \
    maybe_run "/usr/local/bin/python" "$@"
}

reload()
{
    source ~/.zshrc
}

rg()
{
    command rg -g '!ChangeLog*' "$@"
}

source_rust_env()
{
    [[ -f "${CARGO_HOME}/env" ]] && { source "${CARGO_HOME}/env"; return; }
    [[ -f "${HOME}/.cargo/env" ]] && { source "${HOME}/.cargo/env"; return; }
    [[ -f "${HOME}/.local/cargo/env" ]] && { source "${HOME}/.local/cargo/env"; return; }
}

sudo_keep_alive()
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

toggle_dark_mode()
{
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
}

tree()
{
    command tree -aCF -I '.git' "$@"
}

up()
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
        cd "$p"
    fi
}

vim_core()
{
    # Open a file in our editor, converting any parameter like this (which is
    # how compilers emit error messages):
    #
    #   path/to/file.cpp:62
    #
    # into this (which is how vim-ish like it):
    #
    #   path/to/file.cpp +62

    local -a ARGS
    local p
    for p in "$@"
    do
        if [[ "$p" =~ .*:.* ]]
        then
            ARGS+=($(echo $p | sed -e 's/\(.*\):\(.*\)/\1 +\2/'))
        else
            ARGS+=($p)
        fi
    done

    "${EDITOR}" "${ARGS[@]}"
}

vss()
{
    vi $(find src -name '*.rs' | sort)
}

xc()
{
    local CMD="$1"
    shift

    case "$CMD" in
        p|print)
            xcode-select -p
            ;;
        s|select)
            sudo xcode-select -s $(realpath "$1")
            ;;
        c|cd)
            cd "$(xcode-select -p)"
            ;;
        v|vers|version)
            if [[ "$1" == "all" ]]
            then
                sw_vers
                echo "==============================================================================="
                xcodebuild -showsdks
                echo "==============================================================================="
                xcodebuild -sdk -version
                echo "==============================================================================="
                clang -v
            else
                sw_vers
                echo
                xcodebuild -version
                echo
                clang -v
            fi
            ;;
        *)  echo "### Unknown command: $CMD" ;;
    esac
}

# Environment variables.
#
# Set up $PATH before setting $EDITOR so that we can find any brew-based
# solutions if we have them installed.

BREW_PATH="$(brew_path)"
if [ -e "${BREW_PATH}/bin/brew" ]
then
    # Suggested from the brew installation instructions printed after it's
    # installed. This sets up variables like PATH, MANPATH, and INFOPATH, as
    # well as defines HOMEBREW_PREFIX, HOMEBREW_CELLAR, and
    # HOMEBREW_REPOSITORY.

    eval "$(${BREW_PATH}/bin/brew shellenv)"

    # "curl is keg-only, which means it was not symlinked into /usr/local,
    # because macOS already provides this software and installing another version in
    # parallel can cause all kinds of trouble."
    #
    # If you need to have curl first in your PATH, run:

    # prepend_path "${BREW_PATH}/opt/curl/bin" # Do I want this?
fi
unset BREW_PATH

source_rust_env

prepend_path "${DOTFILES}/bin"

# Do I want to do this (from brew package installation ouput)?
#
# All commands have been installed with the prefix "g".
# If you need to use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
#   PATH="/usr/local/opt/libtool/libexec/gnubin:$PATH"

# Find the best-looking vim-ish.

[[ -x $(whence -p vi) ]] && export EDITOR=$(whence -p vi)
[[ -x $(whence -p vim) ]] && export EDITOR=$(whence -p vim)
[[ -x $(whence -p nvim) ]] && export EDITOR=$(whence -p nvim)
export VISUAL="${EDITOR}"

# Misc. vars.

export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';
export LESS=-IMR

# PROMPT/PS1
#
# TODO: zsh-ify this.

PS1=$'%F{red}%U%n@%m:%~%f%u\n%# '

# Shell.

autoload -U compinit
compinit -d "${ZSH_CONFIG_DIR}/zcompdump"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey -s '`' '~'
bindkey -e

setopt share_history
setopt extended_history
setopt interactive_comments

# Bring in brew-provided command-line completion.

if is_executable brew
then
    fpath=("$(brew --prefix)/share/zsh/site-functions" "${fpath[@]}")
fi

# Remove/disable git completion, since it's agonizingly slow on large
# projects like WebKit.

compdef -d git

# Define a `help` function that (mostly) works like bash's.
# Note that it won't directly bring you to documentation for low-level
# built-ins like "if" or "while". Nor will it show help for commands in
# /usr/local/zsh/<version>/functions. And it doesn't use the alt-screen.

# From: https://opensource.apple.com/source/zsh/zsh-72/zsh/StartupFiles/zshrc.auto.html

export HELPDIR=/usr/share/zsh/$ZSH_VERSION/help  # directory for run-help function to find docs
unalias run-help 2> /dev/null # Something aliases run-help to man, so remove that.
autoload -Uz run-help
alias help=run-help

true # Exit with no error.
