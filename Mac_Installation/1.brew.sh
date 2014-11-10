#!/bin/bash

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

# Node.js
brew install node
# everything installed under /usr/local/lib/node_modules
# After installation run this:
# npm completion > /usr/local/etc/bash_completion.d/npm


# Install everything else
brew install ack
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

# To check:

# brew install pigz
# brew install pv
# brew install foremost
# brew install rhino
# brew install sqlmap
# brew install webkit2png
# brew install zopfli
# brew install homebrew/versions/lua52

# Remove outdated versions from the cellar
brew cleanup

