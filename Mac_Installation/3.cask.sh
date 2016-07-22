#!/usr/bin/env bash

# Install native apps with cask
# https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md

# IMPORTANT: Make sure to go to pref panel/Security & Privacy: allows apps downloaded from anywhere
# NOTE: If some applications can't be installed re-try with --force option

brew tap caskroom/cask # maybe not necessary

brew install homebrew/completions/brew-cask-completion

# main_app_dir = "/Applications"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# -p means if directory doen't exists

mkdir -p /Applications/web
mkdir -p /Applications/Coding/Db
mkdir -p /Applications/Tools
mkdir -p /Applications/Office
mkdir -p /Applications/Audio\&Video
mkdir -p /Applications/Photo\&Graphics

# "${@}" list of all parameters
function caskInstall() {
	brew cask install "${@}" 2> /dev/null
}


# This will install alfred 3. I only have the license for alfred 2. Install it manually.
# caskInstall --appdir="/Applications/Tools" alfred
# caskInstall alfred # Link alfred

caskInstall send-to-kindle launchrocket path-finder karabiner
# caskInstall virtualbox


caskInstall --appdir="/Applications/Web" dropbox google-chrome google-chrome-canary cyberduck transmission franz
# caskInstall --appdir="/Applications/Web" skype transmit shuttle tor-browser


caskInstall --appdir="/Applications/Coding" iterm2 sublime-text pycharm webstorm dash diffmerge tower arduino processing macdown
# caskInstall --appdir="/Applications/Coding" atom brackets imageoptim imagealpha gitx-rowanj macvim

# Web Debugging Proxy Application for Windows, Mac OS and Linux
# caskInstall charles

# Mou The missing Markdown editor for web developers
# caskInstall mou

caskInstall --appdir="/Applications/Coding/Db" sequel-pro mysqlworkbench mongohub
# caskInstall --appdir="/Applications/Coding/Db" robomongo


caskInstall --appdir="/Applications/Office" evernote skitch skim


caskInstall --appdir="/Applications/Tools"  the-unarchiver hyperdock appcleaner smcfancontrol bettertouchtool burn macpass ibackup clamxav flux
caskInstall --appdir="/Applications/Tools"  cakebrew --force
caskInstall --appdir="/Applications/Tools"  unetbootin detune izip tinkertool
# caskInstall --appdir="/Applications/Tools"  slate colorpicker-skalacolor rightzoom 
# caskInstall --appdir="/Applications/Tools"  synergy # share mouse between multiple computers


caskInstall --appdir="/Applications/Utilities"  xquartz


caskInstall --appdir="/Applications/Audio&Video" vlc spotify spotifree miro-video-converter


# https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package


# caskroom/fonts
brew tap caskroom/fonts
# USAGE: brew cask install font-inconsolata
# Search: ls /usr/local//Library/Taps/caskroom-fonts/Casks/ | grep <pattern>


# DELETING THE INSTALLERS:
# https://mug.im/manage-your-mac-apps-with-homebrew-cask/
# Homebrew-cask uses brew itself to manage the cache.
# $ brew cleanup -s should do the job.
# If you want to automate this you can use:
# $ rm -rf $(brew --cache)
# rm -rf $(brew --cache)

brew cask cleanup
