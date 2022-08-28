#!/usr/bin/env bash

# See also: https://gist.github.com/xuhdev/8b1b16fb802f6870729038ce3789568f

# Install Brew
# =============
# https://docs.brew.sh/Installation

# Make sure we’re using the latest Homebrew
brew update
# Upgrade any already-installed formulae
brew upgrade


# BREW BUNDLE
# =====================
# RESTORE BREW PACKAGES
# https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f
# https://github.com/MikeMcQuaid/strap

# brew bundle dump --file=~/.dotfiles/Brewfile    # -> Creates Brewfile
brew bundle install --file=~/.dotfiles/Brewfile   # -> Restore from a Brewfile

# SERVICES
# ========
# brew services is automatically installed when first run
# https://docs.brew.sh/Manpage#services-subcommand
# This allows me to: "brew services start/stop/restart mysql" and many other services


#  TAPS
#  ====
# https://docs.brew.sh/Taps
# The brew tap command adds more repositories to the list of formulae


# PHP
# ==========
# To install major version of php
brew install php
# Switch versions of php
brew install brew-php-switcher
# USAGE:
# brew-php-switcher 56
# brew-php-switcher 70


# Git
brew install git
# If bash completions don't work then try with
# brew install git --without-completions
# brew install mercurial

#  ========================
#  = COREUTILS + GNU BINS =
#  ========================
# Commands also provided by macOS and the commands dir, dircolors, vdir have been installed with the prefix "g".
# If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
# `PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"`
brew install coreutils  # g-prefixed
echo "Don't forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

# ALL 'g' prefixed
brew install binutils     # https://en.wikipedia.org/wiki/GNU_Binutils
brew install diffutils    # https://www.gnu.org/software/diffutils/
brew install ed
brew install findutils    # https://www.gnu.org/software/findutils/ (`find`, `locate`, `updatedb`, and `xargs`)
brew install gawk
brew install gnu-indent
brew install gnu-sed      # Gnu sed, used for pretty git diff (call it with `gsed`)
brew install gnu-tar
brew install gnu-which
brew install gnutls
brew install grep
brew install gzip
brew install screen
brew install watch
brew install wdiff        # --with-gettext
brew install wget

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
brew install micro                      # Super cool text editor: https://github.com/zyedidia/micro

# NON-GNU
brew install less
brew install openssh
brew install rsync
brew install unzip
brew install p7zip
brew install lzip                       # for lz compressed files, es: lzip -d compressedFile.tar.lz
brew install vim
# brew install macvim

brew install ack
brew install nmap
brew install rename
brew install tree
brew install markdown
brew install lynx
brew install pstree

# LUA
# brew install lua                    # will also install luarocks (package manager for lua)

# Others
# brew install imagemagick --with-webp
brew install testdisk
brew install archey4                 # info for mac
# ALL OF THESE VIA DOCKER
brew install redis                  # Start it with launchrocket
brew install mongodb                # edit /usr/local/etc/mongod.conf for settings. Start it with launchrocket
brew install heroku-toolbelt
brew install rabbitmq               # Default Celery broker
brew install graphviz               # For graphviz
brew install memcached

# GhostScript
brew install gs                     # ghostscript, needed for progressbar in terminal
# Doesn't exist anymore
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

# Other Apps
# =================
# brew install pigz foremost rhino sqlmap webkit2png zopfli nnn

# n³ The unorthodox terminal file manager
# ---------------------------------------
# https://github.com/jarun/nnn
brew install nnn

# pipeviewer
# ----------
# Useful to check long processes (i.e. sql import progress)
# Example `pv sqlfile.sql | mysql -uxxx -pxxxx dbname`
brew install pv

# fzf: a general-purpose command-line fuzzy finder.
# https://github.com/junegunn/fzf
# brew install fzf
# To install useful key bindings and fuzzy completion:
# $(brew --prefix)/opt/fzf/install

# bat: A cat(1) clone with wings.
# supports syntax highlighting for a large number of programming and markup languages
# https://github.com/sharkdp/bat
brew install bat


#  ==========
#  = ffmpeg =
#  ==========
brew install ffmpeg --with-fdk-aac --with-tools --with-freetype --with-libass --with-libvorbis --with-libvpx --with-x265


#  ========
#  = JAVA =
#  ========
# To solve version mismatch, for example for installing protractor (for this issue: https://github.com/angular/protractor/issues/2638)
# brew cask install java  # As I remeber java is not a cask anymore! ==> "java has been moved to Homebrew."
# Follow this:
# https://dev.to/gabethere/installing-java-on-a-mac-using-homebrew-and-jevn-12m8
# https://elisabethirgens.github.io/notes/2019/07/java-versions/



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


#  ===================
#  = Django Starters =
#  ===================
brew install cookiecutter


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
#  = MYSQL ON MOJAVE =
#  ===================
# WARNING: In Mojave MySql 8 doesn't work properly
# https://medium.com/@at0dd/install-mysql-5-7-on-mac-os-mojave-cd07ec936034
#
# Remove any previous version
#
# brew uninstall mysql
# brew uninstall mysql@5.7
# Optional. WARNING!! It will remove all your db
# rm -rf /usr/local/var/mysql #
# rm /usr/local/etc/my.cnf
#
# Install MySQL 5.7
# brew install mysql@5.7
# brew link --force mysql@5.7
# brew services start mysql@5.7




#  ===================
#  = APACHE MOD_WSGI =
#  ===================
brew tap homebrew/apache
brew install mod_wsgi
# If problem in compiling see: https://github.com/Homebrew/homebrew-apache:
#   sudo ln -s /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/ /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.9.xctoolchain


# YARN
# If you use nvm or similar, you should exclude installing Node.js so that nvm’s version of Node.js is used.
brew install yarn --without-node


# ​Disable Analytics
brew analytics off

# Remove outdated versions from the cellar
# brew cleanup