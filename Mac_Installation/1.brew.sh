#!/usr/bin/env bash

# For ST2
# https://github.com/mattbanks/dotfiles-syntax-highlighting-st2

# Install Brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Make sure we’re using the latest Homebrew
brew update
# Upgrade any already-installed formulae
brew upgrade

# Git
brew install git
# If bash completions don't work then try with
# brew install git --without-completions

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash
# Should work out of the box, otherwise:
#   sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
#   chsh -s /usr/local/bin/bash

# Install wget with IRI support
brew install wget --with-iri

# Install more recent versions of some OS X tools
# brew tap homebrew/dupes
# brew install homebrew/dupes/grep

# PHP: https://github.com/Homebrew/homebrew-php
# brew tap homebrew/homebrew-php

# Bash Completions (sometimes doesn't work so it needs to be reinstalled)
brew install bash-completion
# Add this to the bash_profile
# If possible, add tab completion for many more commands

# To solve version mismatch, for example for installing protractor (for this issue: https://github.com/angular/protractor/issues/2638)
brew update
brew cask install java

# Node.js
brew install node
# everything installed under /usr/local/lib/node_modules
# After installation run this:
# npm completion > /usr/local/etc/bash_completion.d/npm

# The --default-names option will prevent Homebrew from prepending gs to the newly installed commands, thus we could use these commands as default ones over the ones shipped by OS X.

# Install everything else
brew install ack
brew install nmap
brew install rename
brew install tree
brew install markdown
brew install wget
brew install install imagemagick --with-webp
brew install lynx
brew install nmap
brew install p7zip
brew install lzip # for lz compressed files, es: lzip -d compressedFile.tar.lz
brew install redis
brew install mongodb # edit /usr/local/etc/mongod.conf for settings. Start it with launchrocket
brew install testdisk
brew install heroku-toolbelt
brew install rabbitmq       # Default Celery broker
brew install archey         # info for our mac
brew install graphviz       # For graphviz
brew install lua       # package manager for lua
brew install luarocks       # package manager for lua
brew install gnu-sed       # gnu sed, used for pretty git diff (use it with gsed)
brew install gs     # ghostscript, need for progressbar in terminal
# Then
cd $(brew --prefix)/share/ghostscript/
wget https://ghostscript.googlecode.com/files/ghostscript-fonts-std-8.11.tar.gz
tar xzvf ghostscript-fonts-std-8.11.tar.gz

# To find wich and where openssl is installed
# which -a openssl
# brew upgrade openssl # should be already installed in the system, only if I need to update it!

# To check:

# brew install pigz
# brew install pv
# brew install foremost
# brew install rhino
# brew install sqlmap
# brew install webkit2png
# brew install zopfli
# brew install homebrew/versions/lua52

# for syncing the setting and pref of installed apps
brew install mackup

# Remove outdated versions from the cellar
brew cleanup

