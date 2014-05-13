#!/usr/bin/env bash
# Install native apps with cask
# https://github.com/phinze/homebrew-cask/blob/master/USAGE.md

main_app_dir = "/Applications"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# -p means if directory doen't exists

mkdir -p /Applications/web
mkdir -p /Applications/Coding
mkdir -p /Applications/Tools
mkdir -p /Applications/Office


brew tap phinze/homebrew-cask
brew install brew-cask

# "${@}" list of all parameters
function installcask() {
        brew cask install "${@}" 2> /dev/null
}

installcask --appdir="/Applications/Tools" alfred
# Link alfred
brew cask alfred link
installcask --appdir="/Applications/Web" 	dropbox
installcask --appdir="/Applications/Web" 	google-chrome
installcask --appdir="/Applications/Web" 	google-chrome-canary
installcask --appdir="/Applications/Web" 	cyberduck
installcask --appdir="/Applications/Web" 	skype
installcask --appdir="/Applications/Web"    transmission
installcask --appdir="/Applications/Web"    transmit
installcask --appdir="/Applications/Web" 	transmit

installcask --appdir="/Applications/Coding" iterm2
installcask --appdir="/Applications/Coding" sublime-text
installcask --appdir="/Applications/Coding" atom
installcask --appdir="/Applications/Coding" virtualbox
installcask --appdir="/Applications/Coding" pycharm
installcask --appdir="/Applications/Coding" dash
installcask --appdir="/Applications/Coding" sequel-pro
installcask --appdir="/Applications/Coding" imageoptim
installcask --appdir="/Applications/Coding" imagealpha
installcask --appdir="/Applications/Coding" diffmerge
installcask --appdir="/Applications/Coding" tower
installcask --appdir="/Applications/Coding" shuttle

installcask --appdir="/Applications/Office" evernote
installcask --appdir="/Applications/Office" skitch

installcask --appdir="/Applications/Tools" 	keyremap4macbook
installcask --appdir="/Applications/Tools" 	the-unarchiver
installcask --appdir="/Applications/Tools" 	xquartz
installcask --appdir="/Applications/Tools" 	slate
installcask --appdir="/Applications/Tools" 	launchrocket
installcask --appdir="/Applications/Tools"  colorpicker-skalacolor
installcask --appdir="/Applications/Tools" 	cakebrew


installcask ukelele
installcask vlc
installcask spotify
installcask path-finder

# https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package

# caskroom/fonts
brew tap caskroom/fonts
# USAGE: brew cask install font-inconsolata
# Search: ls /usr/local//Library/Taps/caskroom-fonts/Casks/ | grep <pattern>


# Others
#
# installcask imagealpha
# installcask imageoptim
# installcask macvim
# installcask miro-video-converter
# installcask tor-browser
#
# Web Debugging Proxy Application for Windows, Mac OS and Linux
# installcask charles
#
# Mou The missing Markdown editor for web developers
# installcask mou


# DELETING THE INSTALLERS:
# https://mug.im/manage-your-mac-apps-with-homebrew-cask/
# Homebrew-cask uses brew itself to manage the cache.
# $ brew cleanup -s should do the job.
# If you want to automate this you can use:
# $ rm -rf $(brew --cache)
# rm -rf $(brew --cache)

brew cask cleanup