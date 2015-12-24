#!/bin/bash

# Install system/application preferences via defaults, nvram, pmset, tmutil,
# systemsetup, scutil, mdutil, plistbuddy, etc.

# Cribbed from:
#   https://github.com/webpro/dotfiles/blob/master/osx/defaults.sh
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
#
# See also:
#   https://github.com/kevinSuttle/OSXDefaults/blob/master/REFERENCE.md

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari HomePage -string "about:blank"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true
defaults write com.apple.dock mouse-over-hilite-stack -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.helpviewer DevMode -bool true
defaults write com.apple.mail ConversationViewMarkAllAsRead -bool true
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"
defaults write com.apple.menuextra.battery -bool true
defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm:ss"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5
defaults write com.apple.sound.beep.feedback -bool false
defaults write com.apple.speech.voice.prefs SelectedVoiceName -string "Vicki"
defaults write com.apple.terminal "Bell" -bool false
defaults write com.apple.terminal "Default Window Settings" -string "Basic"
defaults write com.apple.terminal "Startup Window Settings" -string "Basic"
defaults write com.apple.terminal "VisualBell" -bool false
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.apple.universalaccess reduceTransparency -bool true

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

chflags nohidden ~/Library

sudo nvram SystemAudioVolume=" "

sudo systemsetup -setrestartfreeze on
sudo systemsetup -settimezone "America/Los_Angeles" > /dev/null

sudo tmutil disablelocal

sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
defaults write com.apple.spotlight orderedItems -array \
    '{ "enabled" = 1; "name" = "APPLICATIONS"; }' \
    '{ "enabled" = 1; "name" = "SYSTEM_PREFS"; }' \
    \
    '{ "enabled" = 0; "name" = "MENU_SPOTLIGHT_SUGGESTIONS"; }' \
    '{ "enabled" = 0; "name" = "MENU_CONVERSION"; }' \
    '{ "enabled" = 0; "name" = "MENU_EXPRESSION"; }' \
    '{ "enabled" = 0; "name" = "MENU_DEFINITION"; }' \
    '{ "enabled" = 0; "name" = "DOCUMENTS"; }' \
    '{ "enabled" = 0; "name" = "DIRECTORIES"; }' \
    '{ "enabled" = 0; "name" = "PRESENTATIONS"; }' \
    '{ "enabled" = 0; "name" = "SPREADSHEETS"; }' \
    '{ "enabled" = 0; "name" = "PDF"; }' \
    '{ "enabled" = 0; "name" = "MESSAGES"; }' \
    '{ "enabled" = 0; "name" = "CONTACT"; }' \
    '{ "enabled" = 0; "name" = "EVENT_TODO"; }' \
    '{ "enabled" = 0; "name" = "IMAGES"; }' \
    '{ "enabled" = 0; "name" = "BOOKMARKS"; }' \
    '{ "enabled" = 0; "name" = "MUSIC"; }' \
    '{ "enabled" = 0; "name" = "MOVIES"; }' \
    '{ "enabled" = 0; "name" = "FONTS"; }' \
    '{ "enabled" = 0; "name" = "MENU_OTHER"; }' \
    '{ "enabled" = 0; "name" = "MENU_WEBSEARCH"; }' \
    '{ "enabled" = 0; "name" = "SOURCE"; }'
killall mds &> /dev/null
mdutil -i on / > /dev/null
mdutil -E / > /dev/null

killall \
    "Address Book" \
    "Calendar" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Mail" \
    "Safari" \
    "SystemUIServer" \
    "iCal" \
    "iTunes" \
    &> /dev/null
