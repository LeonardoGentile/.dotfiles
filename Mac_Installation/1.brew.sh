#!/bin/bash

# For ST2
# https://github.com/mattbanks/dotfiles-syntax-highlighting-st2

# Install Brew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

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
brew install wget --enable-iri

# Install more recent versions of some OS X tools
# brew tap homebrew/dupes
# brew install homebrew/dupes/grep

# PHP: https://github.com/Homebrew/homebrew-php
# brew tap homebrew/homebrew-php

# For Yeoman
brew install optipng jpeg-turbo phantomjs

# Bash Completions
brew install bash-completion
# Add this to the bash_profile
# If possible, add tab completion for many more commands

# Node.js
brew install node
# everything installed under /usr/local/lib/node_modules
# After installation run this:
# npm completion > /usr/local/etc/bash_completion.d/npm

# For different version of ruby
brew install rbenv
brew install ruby-build
# rbenv install -l  # for the list of the available ruby version
# rbenv global 2.1.2 # makes ruby 2.1.2 the default one
# rbenv rehash # Run this command after you install a new version of Ruby, or install a gem that provides commands.

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
brew install redis
brew install testdisk
brew install heroku-toolbelt
# Default Celery broker
brew install rabbitmq

# info for our mac
brew install archey

# For graphviz
brew install graphviz

#
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

