#!/usr/bin/env bash


#  ========
#  = GEMS =
#  ========
# gem update --system

#  Compass (nope)
# ===========================
# gem install compass



#  =============================
#  = PYTHON  PACKAGES (GLOBAL) =
#  =============================
# For current set gloabal (pyenv)

# PIL(low)
# =============
# pip install --allow-external PIL # Only troubles, use Pillow!
pip install pillow                  # If PIL won't install use this (more stable)

# mysql-python
# =============
pip install mysql-python

# psycopg2
# =============
# To use postgres with Python (postgres has to be ALREADY installed!)
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
pip install psycopg2                # No need for sudo most probably

# Pygments
# =============
pip install Pygments                # for the c alias (syntax highlighted cat)



#  ================
#  = LUA PACKAGES =
#  ================

# Moonscript (superset of lua language)
# =====================================
luarocks install moonscript
# This will provide the moon and moonc executables along with the moonscript and moon Lua module.

# Moonwatch (for osx)
# ===================
brew install fsw
luarocks install moon-watch         # better -watch for moonscript(moonc) for MacOS, use fsw
# Usage:
#   moon-watch path/to/moonscript [path/to/output/lua]



#  ===========
#  = LINTERS =
#  ===========
npm install -g coffee-script
npm install -g sass-lint
npm install -g csslint
npm install -g eslint
# npm install eslint-plugin-you-dont-need-lodash-underscore

pip install pylint
# [sudo] pip-3.x install pylint     # For python 3.x

# tidy should be preinstall in osx
brew install tidy-html5             # html5 version


#  ==========
#  = Mackup =
#  ==========
# for syncing the setting and pref of installed apps
brew install mackup



#  ==========
#  = Termrc =
#  ==========
# https://github.com/briangonzalez/termrc
# For starting up iterm panes and envs from shell (AMAZING)
gem install termrc



#  ========
#  = Mert =
#  ========
# https://github.com/eggplanetio/mert
# Substitute for termrc but still unstable
npm install -g mert
# Usage:
#   mert init [type]   # Create new .mertrc file. Options: global or local
#   mert start [name]  # Start project by name or by specifying file path (defaults to .mertrc in cwd)



#  =============
#  = Screengif =
#  =============
# To convert video into gif: https://github.com/dergachev/screengif
brew install ffmpeg imagemagick gifsicle pkg-config
gem install screengif



#  ======================
#  = Spotify Controller =
#  ======================
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


#  ============
#  = Alcatraz =
#  ============
# Package manager for Xcode
# http://alcatraz.io
# Install:
#   curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/deploy/Scripts/install.sh | sh
# Uninstall:
#   rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin
#   rm -rf ~/Library/Application\ Support/Alcatraz # Remove all cached data

# Eero
# "objective-c, evolved"
# http://eerolanguage.org/index.html
# ===========================
# After Alcatraz look for eero
#