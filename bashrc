source ~/.bash.console.sh

export PS1="$FgiRed$UserName@$ShortHost:$WorkingDirPath$Reset\n$StdPromptPrefix "
export EDITOR=vim
export HOMEBREW_DIR="${HOME}/dev/brew"
export HOMEBREW_CACHE="${HOMEBREW_DIR}/cache"
export PATH="${HOME}/bin:${PATH}"
export PATH="${HOME}/dev/WebKit/OpenSource/Tools/Scripts:${PATH}"
export PATH="${HOME}/dev/depot_tools:${PATH}"
export PATH="${HOMEBREW_DIR}/bin:${PATH}"
export WEBKIT_OUTPUTDIR="${HOME}/dev/build"

alias ls="ls -AFGh"
alias ll="ls -o"
alias la="ls -ao"
alias ..="cd .."
alias df='df -h'
alias du='du -h -s'
alias tree='tree -F'
alias gitp="git --no-pager"
alias svn='xcrun svn'

alias build-debug="time make debug | filter-build-webkit"
alias build-release="time make release | filter-build-webkit"
alias test-release-all="time run-webkit-tests --release"
alias test-release-fast="time run-webkit-tests --release fast"
alias test-release-imported="time run-webkit-tests --release imported"
alias test-debug-all="time run-webkit-tests --debug"
alias test-debug-fast="time run-webkit-tests --debug fast"
alias test-debug-imported="time run-webkit-tests --debug imported"

shopt -s checkwinsize

export GREP_OPTIONS="--color=auto --exclude-dir=.git $GREP_OPTIONS"
export LESS="-M -I -R $LESS"
export LS_OPTIONS="-Fhv $LS_OPTIONS"

# Inspired by `up`: http://brettterpstra.com/2014/05/14/up-fuzzy-navigation-up-a-directory-tree/
# inspired by `bd`: https://github.com/vigneshwaranr/bd
function _up()
{
	local rx
	rx=$(echo "$1" | sed -e "s/\s\+//g" -e "s/\(.\)/\1[^\/]*/g")
	echo -n $(pwd | sed -e "s/\(.*\/[^\/]*${rx}\)\/.*/\1/")
}

function up()
{
	if [ $# -eq 0 ]
	then
		echo "up: traverses up the current working directory to first match and cds to it"
		echo "You need an argument"
	else
		cd $(_up "$@")
	fi
}

# gt: Go To Git Top
alias gt='cd $(git rev-parse --show-toplevel 2>/dev/null || (echo "."; echo "Not within a git repository" >&2))'
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash

[ -r "${HOME}/.bashrc.local" ] && source "${HOME}/.bashrc.local"
