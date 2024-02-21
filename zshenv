# See /etc/zshrc_Apple_Terminal
export SHELL_SESSIONS_DISABLE=1

# From https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html:
#
#   $XDG_DATA_HOME defines the base directory relative to which user-specific
#   data files should be stored. If $XDG_DATA_HOME is either not set or empty,
#   a default equal to $HOME/.local/share should be used.
#
#   $XDG_CONFIG_HOME defines the base directory relative to which user-specific
#   configuration files should be stored. If $XDG_CONFIG_HOME is either not set
#   or empty, a default equal to $HOME/.config should be used.
#
#   $XDG_STATE_HOME defines the base directory relative to which user-specific
#   state files should be stored. If $XDG_STATE_HOME is either not set or
#   empty, a default equal to $HOME/.local/state should be used.
#
#   $XDG_CACHE_HOME defines the base directory relative to which user-specific
#   non-essential data files should be stored. If $XDG_CACHE_HOME is either not
#   set or empty, a default equal to $HOME/.cache should be used.

export XDG_CACHE_HOME=${HOME}/.cache
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_STATE_HOME=${HOME}/.local/state

# XDG_DATA_DIRS=
# XDG_CONFIG_DIRS=
# XDG_RUNTIME_DIR=

export ZSH_STATE_DIR=${XDG_STATE_HOME}/zsh
export HISTFILE=${ZSH_STATE_DIR}/zsh_history
export HISTSIZE=SAVEHIST=10000

export RUST_STATE_DIR=${XDG_STATE_HOME}/rust
export RUSTUP_HOME=${RUST_STATE_DIR}/rustup
export CARGO_HOME=${RUST_STATE_DIR}/cargo

export PYTHON_STATE_DIR=${XDG_STATE_HOME}/python
export PYTHON_HISTORY=${PYTHON_STATE_DIR}/python_history
