source ~/.bash.console.sh

#export PS1='\n\W\$ '
#export PS1='\[\e]0;\w\n\e[32m\]\u@\h \[\e[36m\w\e[0m\]\n$ '
#export PS1='\[\e[32m\]\u@\h \[\e[36m\]\w\[\e[0m\]\n$ '
#export PS1="\h:\W \u\n\[$IGreen\]➜\[$Color_Off\] "
#export PS1="\e[31m\u@\h:\w\e[0m\n🍔  $ "
#export PS1="🍔  $FgRed$UserName@$ShortHost:$WorkingDirPath$Reset\n$StdPromptPrefix "
export PS1="$FgiRed$UserName@$ShortHost:$WorkingDirPath$Reset\n$StdPromptPrefix "

export EDITOR=vim
export PATH="/usr/local/bin:$PATH"
export PATH="/Users/keith/bin:$PATH"

alias ls="ls -AFG"
alias ll="ls -l"
alias la="ls -al"
alias ..="cd .."
alias df='df --si'
alias du='du --si -s'
alias tree='tree -F'
alias gitp="git --no-pager"
alias svn='xcrun svn'

alias kill_go='kill -9 $( ps ux | grep "[0-9] \.\./go" | awk "{ print \$2 }" )'

shopt -s checkwinsize
#set -o vi	# I like vim, but I don't know how to drive bash with this set.

export GREP_OPTIONS="--color=auto --exclude-dir=.svn"
export LESS="-M -I -R"
export LS_OPTIONS="-Fhv $LS_OPTIONS"

export GOROOT=$HOME/Documents/Developer/go/1.4.1
export GOPATH=$HOME/Documents/Developer/go
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"

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

# gt: Go Top
alias gt='cd $(git rev-parse --show-toplevel 2>/dev/null || (echo "."; echo "Not within a git repository" >&2))'

# From https://gist.github.com/ttscoff/893afa7acdcd6c696dc7
# Bash completion for `up` <http://brettterpstra.com/2014/05/14/up-fuzzy-navigation-up-a-directory-tree/>
#_up_complete()
#{
#	local rx
#	local token=${COMP_WORDS[$COMP_CWORD]}
#	local IFS=$'\t'
#	local words=$(dirname `pwd` | tr / "	")
# 
#	local nocasematchWasOff=0
#	shopt nocasematch >/dev/null || nocasematchWasOff=1
#	(( nocasematchWasOff )) && shopt -s nocasematch
# 
#	local w matches=()
# 
#	if [[ $token == "" ]]; then
#		matches=($words)
#	else
#		for w in $words; do
#			rx=$(ruby -e "print '$token'.gsub(/\s+/,'').split('').join('.*')")
#			if [[ "$w" =~ $rx ]]; then
#				matches+=("${w// /\ }")
#			fi
#		done
#	fi
# 
#	(( nocasematchWasOff )) && shopt -u nocasematch
# 
#	COMPREPLY=("${matches[@]}")
#}
# 
#complete -F _up_complete up

# http://brettterpstra.com/2014/05/15/tmux-even-easier-tm-with-fuzzy-completion/
#_tm_complete() {
#	local rx
#	local token=${COMP_WORDS[$COMP_CWORD]}
#	local IFS=$'\t'
#	local words
#	if [ $COMP_CWORD -eq 2 ]; then
#		words=$(tmux list-windows -t ${COMP_WORDS[1]} 2> /dev/null | awk '{print $2}' | tr -d '*-' | tr "\n" "\t")
#	elif [ $COMP_CWORD -eq 1 ]; then
#		words=$(tmux -q list-sessions 2> /dev/null | cut -f 1 -d ':' | tr "\n" "	")
#	fi
# 
#	local nocasematchWasOff=0
#	shopt nocasematch >/dev/null || nocasematchWasOff=1
#	(( nocasematchWasOff )) && shopt -s nocasematch
# 
#	local w matches=()
# 
#	if [[ $token == "" ]]; then
#		matches=($words)
#	else
#		for w in $words; do
#			rx=$(ruby -e "print '$token'.gsub(/\s+/,'').split('').join('.*')")
#			if [[ "$w" =~ $rx ]]; then
#				matches+=($w)
#			fi
#		done
#	fi
# 
#	(( nocasematchWasOff )) && shopt -u nocasematch
# 
#	COMPREPLY=("${matches[@]}")
#}
# 
#complete -F _tm_complete tm
