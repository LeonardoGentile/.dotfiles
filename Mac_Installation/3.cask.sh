#!/usr/bin/env bash
# Install native apps with cask
# https://github.com/phinze/homebrew-cask/blob/master/USAGE.md

# NO: old procedure
# brew tap phinze/homebrew-cask
# Message:
# It looks like you tapped a private repository. To avoid entering your
# credentials each time you update, you can use git HTTP credential caching
# or issue the following command:
# cd /usr/local/Library/Taps/phinze/homebrew-cask
# git remote set-url origin git@github.com:phinze/homebrew-cask.git
# cd /usr/local/Library/Taps/phinze/homebrew-cask
# git remote set-url origin git@github.com:phinze/homebrew-cask.git
# brew install brew-cask


# OK
# maybe not necessary
# brew tap caskroom/cask
# brew install caskroom/cask/brew-cask

# IMPORTANT: Make sure to go to pref panel/Security & Privacy: allows apps downloaded from anywhere
# !! If some applications can't be installed re-try with --force option


# main_app_dir = "/Applications"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# -p means if directory doen't exists

mkdir -p /Applications/web
mkdir -p /Applications/Coding
mkdir -p /Applications/Tools
mkdir -p /Applications/Office
mkdir -p /Applications/Audio\&Video
mkdir -p /Applications/Photo\&Graphics

# "${@}" list of all parameters
function caskInstall() {
        brew cask install "${@}" 2> /dev/null
}

caskInstall --appdir="/Applications/Tools" alfred

# Link alfred
brew cask alfred link

# path-finder
caskInstall path-finder

caskInstall --appdir="/Applications/Web" 	dropbox
caskInstall --appdir="/Applications/Web" 	google-chrome
caskInstall --appdir="/Applications/Web" 	google-chrome-canary
caskInstall --appdir="/Applications/Web" 	cyberduck
caskInstall --appdir="/Applications/Web" 	skype
caskInstall --appdir="/Applications/Web"    transmission
caskInstall --appdir="/Applications/Web"    transmit

caskInstall send-to-kindle
caskInstall virtualbox
caskInstall launchrocket

caskInstall --appdir="/Applications/Coding" iterm2
caskInstall --appdir="/Applications/Coding" sublime-text
caskInstall --appdir="/Applications/Coding" atom
caskInstall --appdir="/Applications/Coding" pycharm
caskInstall --appdir="/Applications/Coding" dash
caskInstall --appdir="/Applications/Coding" sequel-pro
caskInstall --appdir="/Applications/Coding" imageoptim
caskInstall --appdir="/Applications/Coding" imagealpha
caskInstall --appdir="/Applications/Coding" diffmerge
caskInstall --appdir="/Applications/Coding" tower
caskInstall --appdir="/Applications/Coding" shuttle
caskInstall --appdir="/Applications/Coding" mysqlworkbench
caskInstall --appdir="/Applications/Coding" gitx-rowanj
caskInstall --appdir="/Applications/Coding" mongohub
caskInstall --appdir="/Applications/Coding" arduino
caskInstall --appdir="/Applications/Coding" processing
caskInstall --appdir="/Applications/Coding" brackets

caskInstall --appdir="/Applications/Office" evernote
caskInstall --appdir="/Applications/Office" skitch

# caskInstall --appdir="/Applications/Tools" 	keyremap4macbook
caskInstall --appdir="/Applications/Tools" 	karabiner
caskInstall --appdir="/Applications/Tools" 	the-unarchiver
caskInstall --appdir="/Applications/Tools" 	slate
caskInstall --appdir="/Applications/Tools"  colorpicker-skalacolor
caskInstall --appdir="/Applications/Tools"  cakebrew --force
caskInstall --appdir="/Applications/Tools"  appcleaner
caskInstall --appdir="/Applications/Tools"  rightzoom
caskInstall --appdir="/Applications/Tools"  ukelele
caskInstall --appdir="/Applications/Tools"  smcfancontrol
caskInstall --appdir="/Applications/Tools"  bettertouchtool
caskInstall --appdir="/Applications/Tools"  burn
# Antivirus
caskInstall --appdir="/Applications/Tools"  clamxav
caskInstall --appdir="/Applications/Tools"  ibackup
caskInstall --appdir="/Applications/Tools"  synergy # share mouse between multiple computers

caskInstall --appdir="/Applications/Tools"  unetbootin
caskInstall --appdir="/Applications/Tools"  detune
caskInstall --appdir="/Applications/Tools"  izip
caskInstall --appdir="/Applications/Tools"  tinkertool

caskInstall --appdir="/Applications/Audio\&Video" vlc
caskInstall --appdir="/Applications/Audio\&Video" spotify
caskInstall --appdir="/Applications/Audio\&Video" spotifree
caskInstall --appdir="/Applications/Audio\&Video" miro-video-converter

caskInstall --appdir="/Applications/Photo\&Graphics" adobe-photoshop-lightroom

caskInstall --appdir="/Applications/Utilities" 	xquartz

# https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package

# caskroom/fonts
brew tap caskroom/fonts
# USAGE: brew cask install font-inconsolata
# Search: ls /usr/local//Library/Taps/caskroom-fonts/Casks/ | grep <pattern>


# Others
#
# caskInstall macvim
# caskInstall miro-video-converter
# caskInstall tor-browser
#
# Web Debugging Proxy Application for Windows, Mac OS and Linux
# caskInstall charles
#
# Mou The missing Markdown editor for web developers
# caskInstall mou


# DELETING THE INSTALLERS:
# https://mug.im/manage-your-mac-apps-with-homebrew-cask/
# Homebrew-cask uses brew itself to manage the cache.
# $ brew cleanup -s should do the job.
# If you want to automate this you can use:
# $ rm -rf $(brew --cache)
# rm -rf $(brew --cache)

brew cask cleanup
