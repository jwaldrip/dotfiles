date=`date`

init: git-init setup-private setup-directories set-shell force-restore asdf system-setup
restore: brew-cleanup pull-changes brew-bundle
update: brew-dump push-changes
sync: restore update

install-homebrew:
	/usr/bin/ruby -e "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`" || true

force-restore:
	git fetch
	git reset --hard origin/master
	make restore

gpg:
	brew cask install gpg-suite
	sudo gpgconf --kill dirmngr
	sudo chown -R $$USER:wheel $$HOME/.gnupg
	chmod -R 0600 $$HOME/.gnupg

asdf: gpg
	rm -rf ~/.asdf
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.2
	~/.asdf/bin/asdf plugin-add nodejs
	~/.asdf/bin/asdf plugin-add erlang
	~/.asdf/bin/asdf plugin-add elixir
	~/.asdf/bin/asdf plugin-add python
	~/.asdf/bin/asdf plugin-add ruby
	~/.asdf/bin/asdf plugin-add crystal 
	~/.asdf/bin/asdf plugin-add java
	bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

set-shell:
	chsh -s /bin/zsh

system-setup:
	# Close any open System Preferences panes, to prevent them from overriding
	# settings we’re about to change
	osascript -e 'tell application "System Preferences" to quit'
	# Ask for the administrator password upfront
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	###############################################################################
	# General UI/UX                                                               #
	###############################################################################

	# Set computer name (as done via System Preferences → Sharing)
	sudo scutil --set ComputerName "Jason Waldrip's MacBook Pro"
	sudo scutil --set HostName "jwaldrip.macbook.local"
	sudo scutil --set LocalHostName "jwaldrip"
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "jwaldrip"

	# Always show scrollbars
	defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

	# Expand save panel by default
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

	# Expand print panel by default
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

	# Save to disk (not to iCloud) by default
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	# Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

	# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

	# Display ASCII control characters using caret notation in standard text views
	defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

	# Disable Resume system-wide
	defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

	# Set Help Viewer windows to non-floating mode
	defaults write com.apple.helpviewer DevMode -bool true

	# Disable automatic capitalization as it’s annoying when typing code
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

	# Disable smart dashes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

	# Disable automatic period substitution as it’s annoying when typing code
	defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

	# Disable smart quotes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

	# Disable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	###############################################################################
	# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
	###############################################################################

	# Trackpad: enable tap to click for this user and for the login screen
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

	# Trackpad: map bottom right corner to right-click
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
	defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
	defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

	# Disable “natural” (Lion-style) scrolling
	defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

	# Increase sound quality for Bluetooth headphones/headsets
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

	# Enable full keyboard access for all controls
	# (e.g. enable Tab in modal dialogs)
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

	# Disable press-and-hold for keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

	# Set a blazingly fast keyboard repeat rate
	defaults write NSGlobalDomain KeyRepeat -int 1
	defaults write NSGlobalDomain InitialKeyRepeat -int 10

	# Set language and text formats
	# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
	# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
	defaults write NSGlobalDomain AppleLanguages -array "en"
	defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
	defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
	defaults write NSGlobalDomain AppleMetricUnits -bool false

	# Set the timezone; see `sudo systemsetup -listtimezones` for other values
	sudo systemsetup -settimezone "America/Denver" > /dev/null

	# Stop iTunes from responding to the keyboard media keys
	launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

	###############################################################################
	# Screen                                                                      #
	###############################################################################

	# Require password immediately after sleep or screen saver begins
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	# Save screenshots to Dropbox
	defaults write com.apple.screencapture location -string "${HOME}/Dropbox/Screenshots"

	# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"

	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true

	###############################################################################
	# Finder                                                                      #
	###############################################################################

	# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
	defaults write com.apple.finder QuitMenuItem -bool true

	# Show icons for hard drives, servers, and removable media on the desktop
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
	defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

	# Finder: show status bar
	defaults write com.apple.finder ShowStatusBar -bool true

	# Finder: show path bar
	defaults write com.apple.finder ShowPathbar -bool true

	# Display full POSIX path as Finder window title
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

	# Keep folders on top when sorting by name
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	# When performing a search, search the current folder by default
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

	# Avoid creating .DS_Store files on network or USB volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	# Use list view in all Finder windows by default
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

	# Enable AirDrop over Ethernet and on unsupported Macs running Lion
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

	# Show the ~/Library folder
	chflags nohidden ~/Library

	# Show the /Volumes folder
	sudo chflags nohidden /Volumes

	# Expand the following File Info panes:
	# “General”, “Open with”, and “Sharing & Permissions”
	defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

	###############################################################################
	# Dock, Dashboard, and hot corners                                            #
	###############################################################################

	# Change minimize/maximize window effect
	defaults write com.apple.dock mineffect -string "scale"

	# Move the dock to the right
	defaults write com.apple.dock 'orientation' -string 'right'

	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true

	# Wipe all (default) app icons from the Dock
	defaults write com.apple.dock persistent-apps -array

	# Disable Dashboard
	defaults write com.apple.dashboard mcx-disabled -bool true

	# Don’t show Dashboard as a Space
	defaults write com.apple.dock dashboard-in-overlay -bool true

	# Don’t automatically rearrange Spaces based on most recent use
	defaults write com.apple.dock mru-spaces -bool false

	# Don’t show recent applications in Dock
	defaults write com.apple.dock show-recents -bool false

	# Disable the Launchpad gesture (pinch with thumb and three fingers)
	defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

	# Reset Launchpad, but keep the desktop wallpaper intact
	find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

	# Add iOS & Watch Simulator to Launchpad
	sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
	sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

	###############################################################################
	# Spotlight                                                                   #
	###############################################################################

	defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 1;"name" = "FONTS";}' \
	'{"enabled" = 1;"name" = "DOCUMENTS";}' \
	'{"enabled" = 1;"name" = "MESSAGES";}' \
	'{"enabled" = 1;"name" = "CONTACT";}' \
	'{"enabled" = 1;"name" = "EVENT_TODO";}' \
	'{"enabled" = 1;"name" = "IMAGES";}' \
	'{"enabled" = 1;"name" = "BOOKMARKS";}' \
	'{"enabled" = 1;"name" = "MUSIC";}' \
	'{"enabled" = 1;"name" = "MOVIES";}' \
	'{"enabled" = 1;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 1;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 1;"name" = "SOURCE";}' \
	'{"enabled" = 1;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 1;"name" = "MENU_OTHER";}' \
	'{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 1;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 1;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

	# Load new settings before rebuilding the index
	killall mds > /dev/null 2>&1 || true

	# Make sure indexing is enabled for the main volume
	sudo mdutil -i on / > /dev/null || true
	
	# Rebuild the index from scratch
	sudo mdutil -E / > /dev/null || true

	###############################################################################
	# Terminal & iTerm 2                                                          #
	###############################################################################

	# Only use UTF-8 in Terminal.app
	defaults write com.apple.terminal StringEncodings -array 4

	# Enable Secure Keyboard Entry in Terminal.app
	defaults write com.apple.terminal SecureKeyboardEntry -bool true

	# Disable the annoying line marks
	defaults write com.apple.Terminal ShowLineMarks -int 0

	# Don’t display the annoying prompt when quitting iTerm
	defaults write com.googlecode.iterm2 PromptOnQuit -bool false

	###############################################################################
	# Time Machine                                                                #
	###############################################################################

	# Prevent Time Machine from prompting to use new hard drives as backup volume
	defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

	###############################################################################
	# Activity Monitor                                                            #
	###############################################################################

	# Show the main window when launching Activity Monitor
	defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

	# Visualize CPU usage in the Activity Monitor Dock icon
	defaults write com.apple.ActivityMonitor IconType -int 5

	# Show all processes in Activity Monitor
	defaults write com.apple.ActivityMonitor ShowCategory -int 0

	# Sort Activity Monitor results by CPU usage
	defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
	defaults write com.apple.ActivityMonitor SortDirection -int 0

	###############################################################################
	# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
	###############################################################################

	# Enable the debug menu in Address Book
	defaults write com.apple.addressbook ABShowDebugMenu -bool true

	# Enable Dashboard dev mode (allows keeping widgets on the desktop)
	defaults write com.apple.dashboard devmode -bool true

	# Enable the debug menu in iCal (pre-10.8)
	defaults write com.apple.iCal IncludeDebugMenu -bool true

	# Use plain text mode for new TextEdit documents
	defaults write com.apple.TextEdit RichText -int 0

	# Open and save files as UTF-8 in TextEdit
	defaults write com.apple.TextEdit PlainTextEncoding -int 4
	defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

	# Enable the debug menu in Disk Utility
	defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
	defaults write com.apple.DiskUtility advanced-image-options -bool true

	# Auto-play videos when opened with QuickTime Player
	defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

	###############################################################################
	# Mac App Store                                                               #
	###############################################################################

	# Enable the WebKit Developer Tools in the Mac App Store
	defaults write com.apple.appstore WebKitDeveloperExtras -bool true

	# Enable Debug Menu in the Mac App Store
	defaults write com.apple.appstore ShowDebugMenu -bool true

	# Enable the automatic update check
	defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

	# Check for software updates daily, not just once per week
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

	# Download newly available updates in background
	defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

	# Install System data files & security updates
	defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

	# Automatically download apps purchased on other Macs
	defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

	# Turn on app auto-update
	defaults write com.apple.commerce AutoUpdate -bool true

	# Allow the App Store to reboot machine on macOS updates
	defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

	###############################################################################
	# Photos                                                                      #
	###############################################################################

	# Prevent Photos from opening automatically when devices are plugged in
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

	###############################################################################
	# Messages                                                                    #
	###############################################################################

	# Disable smart quotes as it’s annoying for messages that contain code
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

	# Disable continuous spell checking
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

	###############################################################################
	# Google Chrome & Google Chrome Canary                                        #
	###############################################################################

	# Disable the all too sensitive backswipe on trackpads
	defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
	defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

	# Disable the all too sensitive backswipe on Magic Mouse
	defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
	defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

	# Use the system-native print preview dialog
	defaults write com.google.Chrome DisablePrintPreview -bool true
	defaults write com.google.Chrome.canary DisablePrintPreview -bool true

	# Expand the print dialog by default
	defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
	defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

	###############################################################################
	# GPGMail 2                                                                   #
	###############################################################################

	# Disable signing emails by default
	defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false
	@echo "restarting in 10 seconds"
	@sleep 10
	sudo reboot

setup-private:
	brew cask install keybase
	keybase login
	rm -rf .private
	git clone keybase://private/jwaldrip/private .private
	chmod 0400 .private/.ssh/id_rsa
	ssh-add ~/.private/.ssh/id_rsa

setup-directories:
	for folder in Documents Music Movies ; do \
		sudo rm -rf $$folder ; \
		sudo ln -sf ./.cloud-drive/$$folder ; \
	done

git-init:
	rm -rf ./.git
	rm -rf ./.gitconfig
	rm -rf ./.private
	git init
	git remote add origin git@github.com:jwaldrip/dotfiles.git

push-changes:
	git submodule foreach --quiet --recursive git add -A
	sh -c "cd .private && git commit -am 'dotfiles update on ${date}' || true"
	sh -c "cd .private && git push origin master || true"
	git add -A
	git commit -m "dotfiles update on ${date}"
	git push origin master

pull-changes:
	git pull origin master
	git submodule update --recursive --remote

brew-bundle:
	brew bundle --verbose --global

brew-dump:
	brew bundle dump --force --global

brew-cleanup:
	brew bundle cleanup --force --global
