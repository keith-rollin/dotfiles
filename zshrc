# Some sources for what follows:
#
#   https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
#   https://github.com/webpro/dotfiles
#   https://github.com/mathiasbynens/dotfiles

# Get the path to this script so that we can find local resources. This needs
# some explaining, since we can't just get our name from $0. It would be nice
# to use something like:
#
#   mypath=${0:A}
#   mydir=${0:A:h}
#
# But that requires a $0, which is not set to what we want of we're being
# invoked at shell startup ($0 is set to -zsh, and $0:A is set to $HOME/-zsh).
# So we need another approach. What we'll be doing is evaluating/expanding
# "${(%):-%N}".
#
# From "Parameter expansion flags" of `man zshexpn`:
#
#   "If the opening brace is directly followed by an opening parenthesis, the
#    string up to the matching closing parenthesis will be taken as a list of
#    flags.
#
#   "%      Expand all % escapes in the resulting words in the same way as in
#           prompts (see EXPANSION OF PROMPT SEQUENCES in zshmisc(1)). If this
#           flag is given twice, full prompt expansion is done on the resulting
#           words, depending on the setting of the PROMPT_PERCENT, PROMPT_SUBST
#           and PROMPT_BANG options."
#
# From "PARAMETER EXPANSION" of `man zshexpn`:
#
#   "${name-word}
#    ${name:-word}
#           If name is set, or in the second form is non-null, then substitute
#           its value; otherwise substitute word.  In the second form name may
#           be omitted, in which case word is always substituted."
#
# From "SIMPLE PROMPT ESCAPES" of `man zshmisc`:
#
#   "%N     The name of the script, sourced file, or shell function that zsh is
#           currently executing, whichever was started most recently.  If there
#           is none, this is equivalent to the parameter $0.  An integer may
#           follow the `%' to specify a number of trailing path components to
#           show; zero means the full path.  A negative integer specifies
#           leading components."
#
# So, "${(%):-%N}" means:
#
#   * Use "(%)" to enable prompt expansion.
#   * Use "%N" to expand to the name of this file.
#   * Use ":-" to provide that file name as the substitution value of this whole
#     ${...} expression."

export DOTFILES=$(dirname -- "$(readlink -f "%R" "${(%):-%N}")")

# Make sure add-zsh-hook is available. We don't seem to need this line when
# merely launching a new session, but if I were to SSH into my own account, I
# get a command-not-found error without this.

autoload -U add-zsh-hook

# The normal zsh startup sequence is as follows:
#
#   * /etc/zshenv   then $ZDOTDIR/.zshenv      Always
#   * /etc/zprofile then $ZDOTDIR/.zprofile    If login shell
#   * /etc/zshrc    then $ZDOTDIR/.zshrc       If interactive shell
#   * /etc/zlogin   then $ZDOTDIR/.zlogin      If login shell
#
# This means that there are places where settings in my .zshenv file can get
# overridden. And they are. /etc/zshrc is overriding my history file settings.
# So pull zshenv back in here to re-establish them.

source "${DOTFILES}"/zshenv

# Functions.

source "${DOTFILES}"/bin/shell_functions.zsh

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
fi
unset BREW_PATH

source_rust_env

prepend_path "${DOTFILES}/bin"

# Find the best-looking vim-ish.

[[ -x $(whence -p vi) ]] && export EDITOR=$(whence -p vi)
[[ -x $(whence -p vim) ]] && export EDITOR=$(whence -p vim)
[[ -x $(whence -p nvim) ]] && export EDITOR=$(whence -p nvim)
export VISUAL="${EDITOR}"

# Misc. vars.
#
# Setting SSH_AUTH_SOCK is not needed in all cases since the path is set as
# the IdentityAgent in ~/.ssh/config, but it does make `ssh-add -l` possible.

export HOMEBREW_AUTO_UPDATE_SECS=604800
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';
export LESS=-IMR
export OP_ACCOUNT='rollin-family.1password.com'
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# (From: https://www.travishinkelman.com/getting-started-with-chez-scheme-and-emacs/)
export CHEZSCHEMELIBDIRS="${HOME}/.local/share/chezscheme/lib:"
export CHEZSCHEMELIBEXTS=".sc::.so:"


# PROMPT/PS1
#
# Show two lines. The first line show the directory in red as:
#
#   ">>> /path/to/working/directory"
#
# We also prepare for the possibility of showing the git status by setting up
# subsequent text to be blue.
#
# The second line shows the prompt simply as '%' or '#' depending on whether we
# are in 'su' mode or not.
#
# If we do need to show the python virtual environment or git status, we'll
# handle that in the precmd function.

PS1_LINE1='%F{red}%B>>> %~%F{blue}'
PS1_LINE2=$'%f%b\n%# '

# If we are using brew and have git installed, then bring in __git_ps1 that we
# can use to show the git status in the prompt.

BREW_APP="$(brew_path)/bin/brew"
GIT_APP="$(whence -p git)"
if [[ -e "${BREW_APP}" && -e "${GIT_APP}" ]]
then
    GIT_VERSION=$("${GIT_APP}" --version | cut -d' ' -f3)
    GIT_PROMPT=$("${BREW_APP}" --cellar)/git/${GIT_VERSION}/etc/bash_completion.d/git-prompt.sh
    if [[ -e "${GIT_PROMPT}" ]]
    then
        source "${GIT_PROMPT}"

        GIT_BIT=' >>> %s'

        GIT_PS1_SHOWCONFLICTSTATE="yes"
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUPSTREAM="auto"

        unset GIT_PS1_COMPRESSSPARSESTATE
        unset GIT_PS1_DESCRIBE_STYLE
        unset GIT_PS1_HIDE_IF_PWD_IGNORED
        unset GIT_PS1_OMITSPARSESTATE
        unset GIT_PS1_SHOWCOLORHINTS
        unset GIT_PS1_SHOWUNTRACKEDFILES
        unset GIT_PS1_STATESEPARATOR
    fi
fi
unset BREW_APP GIT_APP GIT_VERSION GIT_PROMPT

# Now build up the prompt. If git is installed, call __git_ps1 to add the git
# status. If we have a python virtual environment, add an indicator if it's
# activated.

precmd_set_prompt () {
    if [ -n "${VIRTUAL_ENV}" ]
    then
        local LINE1_VENV="%F{green}%B>>> $(basename "${VIRTUAL_ENV}")"
        if [ -n "${GIT_BIT}" ]
        then
            __git_ps1 "$LINE1_VENV $PS1_LINE1" "$PS1_LINE2" "$GIT_BIT"
        else
            PS1="$LINE1_VENV $PS1_LINE1$PS1_LINE2"
        fi
    else
        if [ -n "${GIT_BIT}" ]
        then
            __git_ps1 "$PS1_LINE1" "$PS1_LINE2" "$GIT_BIT"
        else
            PS1="$PS1_LINE1$PS1_LINE2"
        fi
    fi
}
add-zsh-hook precmd precmd_set_prompt

# Shell.

autoload -U compinit
compinit -d "${ZSH_STATE_DIR}/zcompdump"
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
