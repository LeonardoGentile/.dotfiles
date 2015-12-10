#!/usr/bin/env bash

# For different version of ruby
brew update
brew install rbenv
brew install ruby-build

# !!!RUN THIS:
# rbenv install -l      # for the list of the available ruby version
# rbenv install 2.1.2   # install ruby
# rbenv global 2.1.2    # makes ruby 2.1.2 the default one
# rbenv rehash          # Run this command after you install a new version of Ruby, or install a gem that provides commands.

# rbenv Gemset (for sandboxed collection of gems, for example for a specific project)
# SEE: https://github.com/jf/rbenv-gemset
brew install rbenv-gemset

# For installing gems from github or anywhere else
gem install specific_install
# USAGE: gem specific_install -l <url to a github gem>


# COMPASS
# ===========================
gem update --system
gem install compass # For source map support (Compass 1.0.0.alpha.19): sudo gem install compass --pre


# termrc, for starting up iterm envs from shell (AMAZING)
# https://github.com/briangonzalez/termrc
gem install termrc


# System PYTHON
# ===========================
brew install python
brew install giflib jpeg

# pyenv
# ===========================
# put this in .bash_profile
# export PYENV_VERSION='system' @TOFIX: not working properly, better use:
#   'pyenv global 2.7.6'

# multiple versions of python
brew install pyenv

pyenv install 2.7.10    # install a specific version
pyenv global 2.7.10     # set default global
# If everything is ok 'which python' should be /Users/myuser/.pyenv/shims/python NOT /bin/python

# USAGE:
#   - list installed versions
#       pyenv versions
#   - current active version
#       pyenv version
#   - set a python version for the current directory
#       pyenv local 2.7.5

# pyenv and virtualenvwrapper
# ===========================
#   - Create a virtualenv with a specific version of python and virtualenvwrapper
#       mkvirtualenv -p /usr/local/bin/python3.2 my_env

# PYTHON Default packages (for currently set gloabl)
# ==================================================
# installed (for the global selected python, that it could also be 'system' btw)
pip install virtualenv virtualenvwrapper
# If virtualenvwrapper wont work just uninstall and reinstall virtualenv

pip install --allow-external PIL # Only troubles
# NOTE: double check the installation of PIL with the option --allow-external (if troubles install pillow)

# If PIL won't install just use
pip install pillow

pip install --upgrade pip
pip install --upgrade setuptools


# PostgreSQL
# ===========================
brew install postgresql
initdb /usr/local/var/postgres
# For starting it at login
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
# cp /usr/local/Cellar/postgresql/9.2.4/org.postgresql.postgres.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

# To use postgres with Python:
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
# No need for sudo most probably
sudo pip install psycopg2

# MYSQL
# ===========================
brew install mysql
unset TMPDIR
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
# for startup
ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

# launch mysql (launchroket)
# then this for setting it up corrctly
mysql_secure_installation
sudo cp $(brew --prefix mysql)/support-files/my-default.cnf /etc/my.cnf

# globally
pip install mysql-python

# config file
# /usr/local/Cellar/mysql/5.6.12/my.cnf

# Start/stop
# launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
# launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist


# apache mod_wsgi
# ===========================
brew tap homebrew/apache
brew install mod_wsgi
# If problem in compiling see: https://github.com/Homebrew/homebrew-apache
# SOLUTION:
# $ sudo ln -s /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/ /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.9.xctoolchain


# Alcatraz
# Package manager for Xcode
# http://alcatraz.io
# ===========================
curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
# uninstall with:
# rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin
# Remove all cached data:
# rm -rf ~/Library/Application\ Support/Alcatraz

# Eero
# "objective-c, evolved"
# http://eerolanguage.org/index.html
# ===========================
# After Alcatraz look for eero

# Linters
# ===========================
npm install -g jscs
npm install -g coffee-script
npm install -g jshint
npm install -g csslint
npm install -g htmlhint
gem install scss_lint

# Grunt
# ===========================
npm install -g grunt-cli


# Gulp
# ===========================
npm install --global gulp


# BOWER
# ===========================
npm install -g bower

# Node-Inspector (debugger)
# ===========================
# For Coffe: coffee -c -m myscript.coffee, then node-debug myscript.js
npm install -g node-inspector

# Coffescript (compiler and live console for coffescript)
# ===========================
npm install -g coffee-script


# Forever
# ===========================
npm install -g forever

# OAUTH.IO Daemon
# ===========================
npm install -g oauthd

# npm-check-updates
# ===========================
# USAGE:
# ALIAS ncu
# ncu # to check if your dependencies have updates
# ncu -u # to update your package.json versions
 npm install -g npm-check-updates

# YEOMAN (maybe sudo)
# ===========================
# For Yeoman
brew install optipng jpeg-turbo phantomjs
npm install -g yo

# NAVE: VIRTUALENVS FOR NODE
# ===========================
# https://github.com/isaacs/nave
# needs npm, obviously.
# TODO: I think i'd rather curl down the nave.sh, symlink it into /bin and use that for initial node install.
npm install -g nave

# NODEMON
# ===========================
# watch for file changes and restart our server when changes are detected.
# Use: nodemon server.js instead of node server.js
npm install -g nodemon

# MOONSCRIPT
# ===========================
# moonscript, compiler from moonscript to lua language
# Usage: moonc -w -t destination_directory source_directory
# This will watch an entire directory (along with it’s children) for modified moon files, compiling them to lua and saving them in destination_directory
# Warning:
#   1) New files aren’t picked up, you have to restart moonc
#   2) moonc doesn’t compile everything on start up. Use moonc without the -w flag to excplicity compile everything
luarocks install moonscript
# FIX BUG: then cd /usr/local/lib/luarocks/rocks/moonscript/version/bin and change line 168 from: require "socket" to: local socket = require "socket"  (line 168)
# See: https://github.com/leafo/moonscript/commit/a6e66737ddf5478f4010f857dfe922106e346cf5
#
#  OR
# for better moon-watch: https://github.com/yi/moon-watch
luarocks install moonrocks
brew install fsw
moonrocks install moon-watch
# USAGE: moon-watch path/to/moonscript [path/to/output/lua]


# https://github.com/rupa/z
# z, oh how i love you
cd ~/bin
git clone https://github.com/rupa/z.git
chmod +x ~/bin/z/z.sh
# also consider moving over your current .z file if possible. it's painful to rebuild :)
# z binary is already referenced from .bash_profile

# I need a better way to handle this
if [[ -d ~/code ]]; then
    # https://github.com/dronir/SpotifyControl
    # Spotify Controll Script
    cd ~/code
    git clone git://github.com/dronir/SpotifyControl.git
    # https://github.com/jeroenbegyn/VLCControl
    # VLC Controll Script
    git clone git://github.com/jeroenbegyn/VLCControl.git
fi

# for the c alias (syntax highlighted cat)
pip install Pygments
