#!/usr/bin/env bash
brew update

#  =============
#  = Libraries =
#  =============
brew install giflib
brew install libjpeg
brew install jpeg
brew install jpeg-turbo
brew install optipng



#  =========
#  = RBENV =
#  =========
# For different version of ruby
# https://github.com/rbenv/rbenv
# Note: to install the latest stable version: http://stackoverflow.com/a/30183040/1191416

brew install rbenv ruby-build   # rbenv plugin that provides an rbenv install
# rbenv init                    # This will install things in my bash_profile: Nope! I do this manually, thanks.

# USAGE and INSTALLATION
# =======================
# rbenv install --list          # for the list of the available ruby version
rbenv install 2.1.2             # install ruby (globally)
rbenv global 2.1.2              # makes ruby 2.1.2 the default one
rbenv rehash                    # Run this command after you install a new version of Ruby, or install a gem that provides commands.

# NOTE: if error "Ruby Bundle Symbol not found: _SSLv2_client_method" check here:
#   http://stackoverflow.com/questions/25492787/ruby-bundle-symbol-not-found-sslv2-client-method-loaderror

# RBENV PLUGINS
# =======================
# rbenv-gemset: for sandboxed collection of gems, for example for a specific project
# SEE: https://github.com/jf/rbenv-gemset
brew install rbenv-gemset




#  =========
#  = PYENV =
#  =========
# multiple versions of python
brew install pyenv

# USAGE and INSTALLATION
# =======================
# pyenv install --list      # for the list of the available ruby version
pyenv install 2.7.10        # install a specific version
pyenv global 2.7.10         # set default global to be used in all shells by writing the version name to the ~/.pyenv/version file.
                            # This version can be overridden by an application-specific .python-version file, or by setting the PYENV_VERSION environment variable.
pyenv rehash                # to rebuild your shim files. Doing this on init makes sure everything is up to date
# pyenv versions            # list installed versions
# pyenv version             # current active version
# pyenv local 2.7.5         # set a python version for the current directory

# If everything is ok 'which python' should be /Users/myuser/.pyenv/shims/python NOT /bin/python

# PYENV AND VIRTUALENVWRAPPER
# ===========================
pip install virtualenv virtualenvwrapper    # If virtualenvwrapper wont work just uninstall and reinstall virtualenv
brew install pyenv-virtualenvwrapper        # probably not needed

# Usage:
# ======
# For the GLOBAL selected python (that it could also be 'system' or the 'brew' btw):
#   mkvirtualenv env1 -p $(which python)
# Or:
#   mkvirtualenv env1       # should work also with -p

# To create a virtualenv with a SPECIFIC VERSION of python and virtualenvwrapper:
#   mkvirtualenv env2 -p $(which python3.4)
# Or:
#   mkvirtualenv -p /usr/local/bin/python3.2 my_env




#  =======
#  = NVM =
#  =======
# https://github.com/creationix/nvm

# MANUAL INSTALLATION
# =======================
# Cause the installer write in my .bashrc and I don't want it
git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
source ~/.nvm/nvm.sh        # this will be done by default from .bash_profile

# USAGE and INSTALLATION
# ======================
nvm install node            # install latest stable node
nvm alias default node      # set as default (to be used in any new shell)
# nvm use node              # use the just installed node

# To install a new version of Node.js and migrate npm packages from a previous version:
# nvm install node --reinstall-packages-from=node

# Activation by Project: https://github.com/creationix/nvm#nvmrc
#   Create a .nvmrc file in the root folder and just write the node version, ex: '5.9' or 'system'
#   Then when cd into the project folder, just run: `nvm use`

# TODO: double check npm completions.
# With brew was just:
npm completion > /usr/local/etc/bash_completion.d/npm




#  ========
#  = GEMS =
#  ========
# gem update --system

#  Compass (nope)
# ===========================
# gem install compass


#  Specific Install
# ===========================
# For installing gems from github or anywhere else
# USAGE: gem specific_install -l <url to a github gem>
gem install specific_install


#  Termrc
# ===========================
# https://github.com/briangonzalez/termrc
# For starting up iterm panes and envs from shell (AMAZING)
gem install termrc



#  Screengif
#  ================
# To convert video into gif: https://github.com/dergachev/screengif
brew install ffmpeg imagemagick gifsicle pkg-config
gem install screengif



#  ============================
#  = PYTHON LIBS and PACKAGES =
#  ============================

# Gloabl python (Nope, using pyenv)
# =================================
# brew install python


# Default packages (for currently set gloabl)
# ============================================
pip install --upgrade pip
pip install --upgrade setuptools

# pip install --allow-external PIL # Only troubles, use Pillow!
pip install pillow          # If PIL won't install use this (more stable)

pip install mysql-python

# To use postgres with Python:
# NOTE: postgres should be ALREADY installed!
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
pip install psycopg2        # No need for sudo most probably

pip install Pygments        # for the c alias (syntax highlighted cat)




#  =======
#  = LUA =
#  =======

# Moonscript
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