#!/bin/sh

if [ "$(defaults read com.apple.Finder AppleShowAllFiles)" = "0" ]
then
	defaults write com.apple.finder AppleShowAllFiles 1
else
	defaults write com.apple.finder AppleShowAllFiles 0
fi

killall Finder
