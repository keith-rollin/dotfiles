# Some sources for what follows:
#
#   https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
#   https://github.com/webpro/dotfiles
#   https://github.com/mathiasbynens/dotfiles

# Determine what shell we're using.

HOST_SHELL=$(basename $(ps -o comm $$ | grep -v COMM | sed -Ee 's/-?(.*)/\1/'))
[ "${HOST_SHELL}" = "bash" ] && ME_BASE="${BASH_SOURCE[0]}"
[ "${HOST_SHELL}" = "zsh"  ] && ME_BASE="${(%):-%N}"
[ -z "${ME_BASE}"  ] && return 0    # We don't support this shell.

# Determine our location. If we see that MAIN_BASHRC is defined, this means
# that we're being source'd from another script and that we can find the path
# to us in that variable. Without that, we'd have to fall back to looking at
# $0, which might or might not be us, depending on the shell we're running
# under.

[ -n "${MAIN_BASHRC}" ] && BASE_ME="$MAIN_BASHRC" || BASE_ME="${0}"
ME="$(readlink "${BASE_ME}")"
[ -n "${ME}" ] || ME="${BASE_ME}"
HERE="$(dirname "${ME}")"

# Define some functions up front. Normally, function definitions are placed
# later in this file, but we'll need to call these functions before they're
# defined, so they're moved to the top of the file.

is_executable()
{
    # Determine if the given command is an actual command, alias, or shell
    # function -- that is, if it's something we can invoke.

    command -v "$1" &> /dev/null
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
    elif is_executable "${HERE}/bin/realpath"
    then
        "${HERE}/bin/realpath" "$1"
    else
        echo ""
    fi
}

maybe_source()
{
    # `source` a file if it exists, is readable, and doesn't look like binary.

    [ -r "$1" -a "$(file -b "$1")" != "data" ] && . "$1"
}

prepend_path()
{
    # Prepend the given path to PATH if it's not already there, resolving any
    # links if necessary.

    local p="$(maybe_resolve "$1")"
    [ -z "$p" ] && return 0
    echo "${PATH}" | grep -q '.*$p:.*' && return 0
    export PATH="$p:${PATH}"
}

# Bring in color definitions for PS1.

[ "$HOST_SHELL" = bash ] && maybe_source "${HERE}/bashrc.console"

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
export SHELL_SESSION_HISTORY=1

[ "$HOST_SHELL" = bash ] && PS1="${FgiRed}${UserName}@${ShortHost}:${WorkingDirPath}${Reset}\n${StdPromptPrefix} "
[ "$HOST_SHELL" = zsh  ] && PS1=$'%F{160}%n@%m:%~%f\n%# '

if [ "$HOST_SHELL" = zsh ]
then
    HISTFILE=~/.zhistory
    HISTSIZE=SAVEHIST=10000
    setopt sharehistory
    setopt extendedhistory
fi

export DEV_PATH="$(maybe_resolve "${HOME}/dev")"

if [ "$HOST_SHELL" = bash ]
then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
elif [ "$HOST_SHELL" = zsh ]
then
    bindkey "^[[A" history-beginning-search-backward
    bindkey "^[[B" history-beginning-search-forward
fi

# $PATH.

BREW_PATH="$(maybe_resolve "${DEV_PATH}/brew")"
if [ -n "${BREW_PATH}" ]
then
    prepend_path "${BREW_PATH}/sbin"
    prepend_path "${BREW_PATH}/bin"
fi
unset BREW_PATH
export HOMEBREW_TEMP="${DEV_PATH}/tmp"
mkdir -p "${HOMEBREW_TEMP}"

prepend_path "${HERE}/bin"

# Shell.

if [ "$HOST_SHELL" = bash ]
then
    shopt -s cdspell
    shopt -s checkwinsize
    shopt -s nocaseglob
    #shopt -s autocd
    #shopt -s dirspell
    #shopt -s globstar
elif [ "$HOST_SHELL" = zsh ]
then
    # setopt extendedglob
    # unsetopt CASE_GLOB
    # setopt EXTENDED_GLOB
    # setopt NO_CASE_GLOB
    # zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    # zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    # zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    # setopt MENU_COMPLETE
    # zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'
    # zstyle ':completion:*' matcher-list 'm:{a-z-}={A-Z_}' 'r:|[-_./]=* r:|=*'

    # unsetopt menu_complete   # do not autoselect the first completion entry
    # unsetopt flowcontrol
    # setopt auto_menu         # show completion menu on successive tab press
    # setopt complete_in_word
    # setopt always_to_end

    autoload -U compinit
    compinit
    zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
fi

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

df() { command df -h "$@" ; }
duh() { sudo du -h -d 1 ; }
duk() { sudo du -k -d 1 ; }
dum() { sudo du -m -d 1 ; }
dug() { sudo du -g -d 1 ; }
duh2() { sudo du -h -d 2 ; }
duk2() { sudo du -k -d 2 ; }
dum2() { sudo du -m -d 2 ; }
dug2() { sudo du -g -d 2 ; }
grep() { command grep --color=auto --devices=skip --exclude='ChangeLog*' --exclude='*.pbxproj' --exclude-dir=.git --exclude-dir=.svn "$@" ; }
#function less() { command less -IMR "$@" ; }
ls() { command ls -FGhv "$@" ; }
tree() { command tree -aCF -I '.git' "$@" ; }

..() { cd .. ; }
...() { cd ... ; }
....() { cd .... ; }
.....() { cd ..... ; }
......() { cd ...... ; }

show_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder ; }
hide_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder ; }
show_desktop() { defaults write com.apple.finder CreateDesktop -bool true && killall Finder ; }
hide_desktop() { defaults write com.apple.finder CreateDesktop -bool false && killall Finder ; }
toggle_dark_mode() { osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'; }

f()   { find -x .         -iname "$1" 2> /dev/null;   }     # find
ff()  { find -x . -type f -iname "$1" 2> /dev/null;   }     # find file
fff() { find -x . -type f -iname "*$1*" 2> /dev/null; }     # fuzzy find file
fd()  { find -x . -type d -iname "$1" 2> /dev/null;   }     # find directory
ffd() { find -x . -type d -iname "*$1*" 2> /dev/null; }     # fuzzy find directory

badge() { tput bel ; }
cleanupds() { find -x . -type f -name '*.DS_Store' -print -delete ; }
gitp() { git --no-pager "$@" ; }
la() { ll -A "$@" ; }
lart() { ls -lArt "$@" ; }
ll() { ls -o "$@" ; }
lmk() { say 'Process complete.' ; }
notify() { osascript -e "display notification \"$1\" with title \"$2\"" ; }
reload() { . ~/.bash_profile ; }

ascii()
{
    #man ascii | col -b | grep -A 55 --color=never "octal set"
    cat /usr/share/misc/ascii
}

at_home()
{
    ! at_work
}

at_work()
{
    # This is not a good test. It tells me where I am, not whether I'm using a
    # home or work computer.
    #[ $(curl -s v4.ifconfig.co) =~ 17\..*\..*\..* ]

    # Test for a volume I only have on work systems.
    [ -d /Volumes/Data ]
}

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

cdf()
{
    # Change working directory to the top-most Finder window location.

    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

cdx()
{
    # Change working directory to Xcode.

    cd "$(xcode-select -p)"
}

cheat()
{
    local TOPIC=$1
    shift
    local QUESTION=$(echo "$*" | tr ' ' '+')
    curl "cheat.sh/${TOPIC}/${QUESTION}"
}

delete_brew()
{
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
}

did()
{
    # From https://theptrk.com/2018/07/11/did-txt-file/

    vim +'normal ggO' +'r!date +"\%F \%T \%z \%a\%n\%n"' ~/Documents/did.txt
}

edit_ff()
{
    vi $(ff "$1")
}

edit_fff()
{
    vi $(fff "$1")
}

fs()
{
    # Determine size of a file or total size of a directory.

    if du -b /dev/null > /dev/null 2>&1
    then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [ -n "$@" ]
    then
        du $arg -- "$@"
    else
        du $arg .[^.]* ./*
    fi
}

git_diff()
{
    # Use Git’s colored diff.

    git diff --no-index --color-words "$@";
}

git_edit_changed()
{
    local OLD_CWD="$(pwd)"
    git_top
    vi $(git diff --name-only)
    cd "${OLD_CWD}"
}

git_edit_files_with_symbol()
{
    vi $(git grep --name-only "$1")
}

git_top()
{
    # Go To Git Top.

    cd $(git rev-parse --show-toplevel 2>/dev/null || (echo '.'; echo "Not within a git repository" >&2))
}

grc()
{
    git rebase --continue
}

grm()
{
    # "git rebase master" is typed almost all with left-handed keys. Use this
    # macro to ease the pain.

    git rebase master
}

hide_brew()
{
    local old_path="$PATH"
    export PATH="$(echo "$PATH" | sed -E -e 's|:[^:]*/brew/[^:]*||g')"
    "$@"
    export PATH="$old_path"
}

mkcd()
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

    IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
    [ "$IP" != "" ] && EXTIP=$IP || EXTIP="inactive"

    printf '%20s: %s\n' "External IP" $EXTIP
}

on_ac_power()
{
    pmset -g ps | grep -q "AC Power"
}

on_battery_power()
{
    pmset -g ps | grep -q "Battery Power"
}

path()
{
    # Show the PATH, one entry per line.

    echo "$PATH" | tr : '\n'
}

manpath()
{
    # Show the "man path", one entry per line.

    man -w | tr : '\n'
}

ql()
{
    qlmanage -p "$@" &> /dev/null &
}

rg()
{
    command rg -g '!ChangeLog*' "$@"
}

search_goog()
{
    open https://www.google.com/search?q=$(echo "$@" | tr ' ' +)
}

search_wiki()
{
    open https://en.wikipedia.org/w/index.php?search=$(echo "$@" | tr ' ' +)
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

urlencode()
{
    python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])" "$1"
}

utcdate()
{
    TZ=utc date
}

vi()
{
    # Open a file in vim, converting any parameter like this:
    #
    #   path/to/file.cpp:62
    #
    # Into:
    #
    #   path/to/file.cpp +62

    local -a ARGS
    local p
    for p in "$@"
    do
        if echo "$p" | grep -q '.*:.*'
        then
            ARGS+=($(echo $p | sed -e 's/\(.*\):\(.*\)/\1 +\2/'))
        else
            ARGS+=($p)
        fi
    done

    command vi "${ARGS[@]}"
}

wip()
{
    git commit -a -m wip
}

xsp()
{
    xcode-select -p
}

# Bring in bash completion.

# is_executable xcode-select && maybe_source "$(xcode-select -p)/usr/share/git-core/git-completion.bash"

if is_executable brew
then
    if [ "$HOST_SHELL" = bash ]
    then
        HOMEBREW_COMPLETION_DIR="$(brew --prefix)/etc/bash_completion.d"
        [ -d "${HOMEBREW_COMPLETION_DIR}" ] && maybe_source "${HOMEBREW_COMPLETION_DIR}/"*
    fi

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

# Bring in ssh keys.

[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)" &> /dev/null
ssh-add ~/.ssh/id_rsa &> /dev/null
ssh-add ~/.ssh/id_keith-rollin@github &> /dev/null
#ssh-add ~/.ssh/id_github &> /dev/null
#ssh-add -A &> /dev/null    # Slow...don't use unless you have to.

# The following was given as a tip for speeding up `git status`. I tried it out
# on an APFS volume (which seems to have slowed down `git status` a lot) and it
# seems to more than double the speed. Nice.

sudo sysctl kern.maxvnodes=$((512*1024)) &> /dev/null
