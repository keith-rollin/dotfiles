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

show_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder ; }
hide_hidden() { defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder ; }
show_desktop() { defaults write com.apple.finder CreateDesktop -bool true && killall Finder ; }
hide_desktop() { defaults write com.apple.finder CreateDesktop -bool false && killall Finder ; }

set_ls_options()
{
    if is_executable exa
    then
        LS_EXECUTABLE="exa"
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

la()        { set_ls_options; ls_common -l ${LS_SHOW_HIDDEN} "$@" ; }
lart()      { set_ls_options; ls_common -l ${LS_SHOW_HIDDEN} ${LS_SORT_BY_TIME[@]} "$@" ; }
lax()       { set_ls_options; ls_common -l ${LS_SHOW_HIDDEN} ${LS_SHOW_EXTENDED_ATTRIBUTE_KEYS} "$@" ; }
ll()        { set_ls_options; ls_common -l "$@" ; }
llx()       { set_ls_options; ls_common -l ${LS_SHOW_EXTENDED_ATTRIBUTE_KEYS} "$@" ; }
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
    # If brew is one the path (for whatever reason), ask it where it is.

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

delete_brew()
{
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
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
    maybe_run "/usr/local/opt/python@3.10/bin/python3" "$@" || \
    maybe_run "/usr/local/opt/python@3.9/bin/python3" "$@" || \
    maybe_run "/usr/local/bin/python3" "$@" || \
    maybe_run "/usr/local/bin/python" "$@"
}

reload()
{
    source ~/.bash_profile
}

rg()
{
    command rg -g '!ChangeLog*' "$@"
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

v()
{
    # Open a file in vi|vim|nvim, converting any parameter like this:
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
        if [[ "$p" =~ .*:.* ]]
        then
            ARGS+=($(echo $p | sed -e 's/\(.*\):\(.*\)/\1 +\2/'))
        else
            ARGS+=($p)
        fi
    done

    "${EDITOR}" "${ARGS[@]}"
}

vi() { v "$@" }
vim() { v "$@" }
nvim() { v "$@" }

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
# We need to force SHELL_SESSION_HISTORY to 1 in order to override the default
# behavior where per-session shell histories are disabled if HISTTIMEFORMAT is
# defined.

_VI="/usr/bin/vi"
[[ -x $(whence -p vim) ]] && _VI=$(whence -p vim)
[[ -x $(whence -p nvim) ]] && _VI=$(whence -p nvim)

export EDITOR="${_VI}"
export HISTTIMEFORMAT="%F %T: "
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';
export LESS=-IMR
export SHELL_SESSION_HISTORY=1

unset _VI

if is_executable starship
then
    eval "$(starship init zsh)"
else
    if [[ -n "${GIT_PROMPT_SH}" ]]
    then
        setopt PROMPT_SUBST
        PS1=$'%F{red}%U%n@%m:%~$(__git_ps1 "%%f%%u %%F{green}%%U[%s]")%f%u\n%# '
    else
        PS1=$'%F{red}%U%n@%m:%~%f%u\n%# '
    fi
fi

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=SAVEHIST=10000
setopt share_history
setopt extended_history
setopt interactive_comments

# $PATH.

BREW_PATH="$(brew_path)"
if [ -n "${BREW_PATH}" ]
then
    prepend_path "${BREW_PATH}/sbin"
    prepend_path "${BREW_PATH}/bin"
fi
unset BREW_PATH

prepend_path "${DOTFILES}/bin"

# Support for 1Password as ssh-agent.

REAL_AGENT_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
HOME_AGENT_SOCK="$HOME/.config/1password/agent.sock"
mkdir -p $(dirname "$HOME_AGENT_SOCK") && ln -sf "$REAL_AGENT_SOCK" "$HOME_AGENT_SOCK"
[[ -L "$HOME_AGENT_SOCK" ]] && export SSH_AUTH_SOCK="$HOME_AGENT_SOCK"
unset HOME_AGENT_SOCK
unset REAL_AGENT_SOCK

# Shell.

autoload -U compinit
compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey -s '`' '~'
bindkey -e

# Bring in command-line completion.
if is_executable brew
then
    fpath=("$(brew --prefix)/share/zsh/site-functions" "${fpath[@]}")
fi

# Remove/disable git completion, since it's agonizingly slow on large
# projects like WebKit.
compdef -d git

# autoload -Uz run-help
# unalias run-help
# alias help=run-help

unalias run-help 2> /dev/null
autoload run-help
HELPDIR=$(echo /usr/share/zsh/*/help) # TODO: Deal with multiple matches
alias help=run-help

# The following was given as a tip for speeding up `git status`. I tried it out
# on an APFS volume (which seems to have slowed down `git status` a lot) and it
# seems to more than double the speed. Nice.

# sudo sysctl kern.maxvnodes=$((512*1024)) &> /dev/null


# VS Code support.

# Support for repeating keys in the vim extenstion to Visual Code.

# defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false &> /dev/null         # For VS Code
# defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false &> /dev/null # For VS Code Insider
# defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false &> /dev/null    # For VS Codium
# defaults delete -g ApplePressAndHoldEnabled &> /dev/null                                      # If necessary, reset global default

# code()
# {
#     "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "${@}"
# }


# Rust support.

prepend_path $HOME/.cargo/bin

# broot support.

BR_SCRIPT_PATH=$HOME/.config/broot/launcher/bash/br
[[ -e "${BR_SCRIPT_PATH}" ]] && source "${BR_SCRIPT_PATH}"


# FZF support (tab completion and key bindings)

BREW_PATH="$(brew_path)"
FZF_BASE="${BREW_PATH}/opt/fzf"
if [[ -d "${FZF_BASE}" ]]
then
    [[ $- == *i* ]] && source "${FZF_BASE}/shell/completion.zsh" 2> /dev/null
    source "${FZF_BASE}/shell/key-bindings.zsh"
fi
unset BREW_PATH
unset FZF_BASE
