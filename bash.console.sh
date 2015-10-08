#!/bin/bash

# PS1 escape characters

Date="\d"
Escape="\e"
ShortHost="\h"
FullHost="\H"
Time24="\t"
Time12="\T"
UserName="\u"
WorkingDirPath="\w"
WorkingDirName="\W"
HistoryNumber="\!"
StdPromptPrefix="\$"
BeginSeq="\["
EndSeq="\]"

# Sequences to set text colors.
# See <https://en.wikipedia.org/wiki/ANSI_escape_code>
#
# In short, we want to build:
#
#	<ESC>[ attr1 ; attr2 ; attr3 code

Csi="$Escape["	# Prefix (Control Sequence Introducer -- CSI)

## Attributes for setting text colors

Rst="0"		# Reset/Normal
Bld="1"		# Bold
Dim="2"		# Dim
# ...
Fg="30"		# Foreground
Bg="40"		# Background
Fgi="90"	# Foreground - high intensity
Bgi="100"	# Background - high intensity

## Command code for setting text colors

Sgr="m"		# Set SGR (Select Graphic Rendition) parameters

## Add these to the fg/bg attributes above to specify which color you want.

Blk="0"		# Black
Red="1"		# Red
Grn="2"		# Green
Ylw="3"		# Yellow
Blu="4"		# Blue
Mgn="5"		# Magenta
Cyn="6"		# Cyan
Wht="7"		# White

# Take 1-3 attributes and return the fully-built command, bracketted by the
# sequences needed to specify non-printing characters in PS1.

function make_color {
	if (( $# == 1 )); then
		echo "$BeginSeq$Csi$1$Sgr$EndSeq"
	elif (( $# == 2 )); then
		echo "$BeginSeq$Csi$1;$2$Sgr$EndSeq"
	elif (( $# == 3 )); then
		echo "$BeginSeq$Csi$1;$2;$3$Sgr$EndSeq"
	fi
}

Reset=$(make_color $Rst)

FgBlk=$(make_color $Rst $(( $Fg + $Blk )) )
FgRed=$(make_color $Rst $(( $Fg + $Red )) )
FgGrn=$(make_color $Rst $(( $Fg + $Grn )) )
FgYlw=$(make_color $Rst $(( $Fg + $Ylw )) )
FgBlu=$(make_color $Rst $(( $Fg + $Blu )) )
FgMgn=$(make_color $Rst $(( $Fg + $Mgn )) )
FgCyn=$(make_color $Rst $(( $Fg + $Cyn )) )
FgWht=$(make_color $Rst $(( $Fg + $Wht )) )

BgBlk=$(make_color $Rst $(( $Bg + $Blk )) )
BgRed=$(make_color $Rst $(( $Bg + $Red )) )
BgGrn=$(make_color $Rst $(( $Bg + $Grn )) )
BgYlw=$(make_color $Rst $(( $Bg + $Ylw )) )
BgBlu=$(make_color $Rst $(( $Bg + $Blu )) )
BgMgn=$(make_color $Rst $(( $Bg + $Mgn )) )
BgCyn=$(make_color $Rst $(( $Bg + $Cyn )) )
BgWht=$(make_color $Rst $(( $Bg + $Wht )) )

FgiBlk=$(make_color $Rst $(( $Fgi + $Blk )) )
FgiRed=$(make_color $Rst $(( $Fgi + $Red )) )
FgiGrn=$(make_color $Rst $(( $Fgi + $Grn )) )
FgiYlw=$(make_color $Rst $(( $Fgi + $Ylw )) )
FgiBlu=$(make_color $Rst $(( $Fgi + $Blu )) )
FgiMgn=$(make_color $Rst $(( $Fgi + $Mgn )) )
FgiCyn=$(make_color $Rst $(( $Fgi + $Cyn )) )
FgiWht=$(make_color $Rst $(( $Fgi + $Wht )) )

BgiBlk=$(make_color $Rst $(( $Bgi + $Blk )) )
BgiRed=$(make_color $Rst $(( $Bgi + $Red )) )
BgiGrn=$(make_color $Rst $(( $Bgi + $Grn )) )
BgiYlw=$(make_color $Rst $(( $Bgi + $Ylw )) )
BgiBlu=$(make_color $Rst $(( $Bgi + $Blu )) )
BgiMgn=$(make_color $Rst $(( $Bgi + $Mgn )) )
BgiCyn=$(make_color $Rst $(( $Bgi + $Cyn )) )
BgiWht=$(make_color $Rst $(( $Bgi + $Wht )) )
