#!/usr/bin/env bash

# See also: https://gist.github.com/xuhdev/8b1b16fb802f6870729038ce3789568f

# Install Brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Make sure we’re using the latest Homebrew
brew update
# Upgrade any already-installed formulae
brew upgrade

#  ===========
#  = TAP TAP =
#  ===========
# Install more recent versions of some OS X tools
# These formulae duplicate software provided by OS X, though may provide more recent or bugfix versions.
brew tap homebrew/dupes

brew tap homebrew/versions

# This allows me to: "brew services start/stop/restart mysql" and many other services
brew tap homebrew/services

brew tap caskroom/cask

# PHP
# ==========
# https://github.com/Homebrew/homebrew-php
# brew tap homebrew/homebrew-php


# Git
brew install git
# If bash completions don't work then try with
# brew install git --without-completions

#  ========================
#  = COREUTILS + GNU BINS =
#  ========================
# Install GNU core utilities (those that come with OS X are outdated), g-prefixed
# use --default-names option to prevent Homebrew from prepending a 'g' to each of the newly installed commands
# thus we could use these commands as default commands over the ones shipped by OS X.
brew install coreutils  # g-prefixed
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

brew install binutils
brew install diffutils
brew install ed --with-default-names
brew install findutils                          # GNU `find`, `locate`, `updatedb`, and `xargs` (g-prefixed)
brew install gawk
brew install gnu-indent --with-default-names
brew install gnu-sed                            # Gnu sed, used for pretty git diff (use it with gsed)
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names
brew install gnutls
brew install grep --with-default-names
brew install gzip
brew install screen
brew install watch
brew install wdiff --with-gettext
brew install wget --with-iri                    # Install wget with IRI support

# Install Bash 4
brew install bash
# Should work out of the box, otherwise:
#   sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
#   chsh -s /usr/local/bin/bash

brew install emacs
# brew install gdb                      # gdb requires further actions to make it work. See `brew info gdb`.
brew install gpatch
brew install m4
brew install make
brew install nano

# NON-GNU
brew install less
brew install openssh
brew install rsync
brew install unzip
brew install p7zip
brew install lzip                       # for lz compressed files, es: lzip -d compressedFile.tar.lz
brew install vim --override-system-vi
brew install macvim --override-system-vim --custom-system-icons

brew install ack
brew install nmap
brew install rename
brew install tree
brew install markdown
brew install lynx

# LUA
brew install lua                    # will also install luarocks (package manager for lua)

# Others
brew install imagemagick --with-webp
brew install testdisk
brew install archey                 # info for mac
brew install redis                  # Start it with launchrocket
brew install mongodb                # edit /usr/local/etc/mongod.conf for settings. Start it with launchrocket
brew install heroku-toolbelt
brew install rabbitmq               # Default Celery broker
brew install graphviz               # For graphviz

# GhostScript
brew install gs                     # ghostscript, needed for progressbar in terminal
cd $(brew --prefix)/share/ghostscript/
wget https://ghostscript.googlecode.com/files/ghostscript-fonts-std-8.11.tar.gz
tar xzvf ghostscript-fonts-std-8.11.tar.gz

# Libraries
brew install giflib
brew install libjpeg
brew install jpeg
brew install jpeg-turbo
brew install optipng

# Bash Completions (sometimes doesn't work so it needs to be reinstalled)
brew install bash-completion            # source it from .bash_profile

# Others (TODO)
# =============
# brew install pigz pv foremost rhino sqlmap webkit2png zopfli



#  ========
#  = JAVA =
#  ========
# To solve version mismatch, for example for installing protractor (for this issue: https://github.com/angular/protractor/issues/2638)
brew cask install java



#  ==============
#  = PostgreSQL =
#  ==============
brew install postgresql
initdb /usr/local/var/postgres -E utf8
# createuser    # create the initial postgres user

# For starting it at login:
#   ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
#   cp /usr/local/Cellar/postgresql/9.2.4/org.postgresql.postgres.plist ~/Library/LaunchAgents/
#   launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist



#  =========
#  = MYSQL =
#  =========
brew install mysql
unset TMPDIR
export TMPDIR=/tmp
mysqld --initialize-insecure --log-error-verbosity --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql
# --insecure, means it doesn't generate a pass for root

# For starting it at login:
#   ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
#   launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

# POST-INSTALL:
#   - launch mysql (launchroket)
#   - then do this for setting it up password for root and remove unsecure stuff
#       mysql_secure_installation
#       sudo cp $(brew --prefix mysql)/support-files/my-default.cnf /etc/my.cnf
#   - There is another config file into /usr/local/Cellar/mysql/VERSION/my.cnf but I guess the one on /etc/my.cnf has precedence

# START/STOP (or launchroket):
#   launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
#   launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist



#  ===================
#  = APACHE MOD_WSGI =
#  ===================
brew tap homebrew/apache
brew install mod_wsgi
# If problem in compiling see: https://github.com/Homebrew/homebrew-apache:
#   sudo ln -s /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/ /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.9.xctoolchain



# ​Disable Analytics
brew analytics off

# Remove outdated versions from the cellar
# brew cleanup