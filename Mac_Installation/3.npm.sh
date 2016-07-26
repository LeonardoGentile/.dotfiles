#!/usr/bin/env bash


# Mert
# ===========================
# https://github.com/eggplanetio/mert
# Substitute for termrc but still unstable
npm install -g mert
# Usage:
#   mert init [type]   # Create new .mertrc file. Options: global or local
#   mert start [name]  # Start project by name or by specifying file path (defaults to .mertrc in cwd)

# Linters
# ===========================
npm install -g jscs
npm install -g coffee-script
npm install -g jshint
npm install -g csslint
npm install -g htmlhint
# gem install scss_lint


# Grunt
# ===========================
npm install -g grunt-cli


# Gulp
# ===========================
npm install --global gulp


# Scaffolding tool for gulp (instead of yeoman)
# ===========================
npm install --global slush


# Bower
# ===========================
npm install -g bower


# Node-Inspector (debugger)
# ===========================
# For Coffe: coffee -c -m myscript.coffee, then node-debug myscript.js
# npm install -g node-inspector


# Coffescript (compiler and live console for coffescript)
# ===========================
npm install -g coffee-script


# Forever
# ===========================
npm install -g forever


# Oauth.io Daemon
# ===========================
npm install -g oauthd


# npm-check-updates
# ===========================
# USAGE:
# ALIAS ncu
# ncu # to check if your dependencies have updates
# ncu -u # to update your package.json versions
npm install -g npm-check-updates


# Nodemon
# ===========================
# watch for file changes and restart our server when changes are detected.
# Use: nodemon server.js instead of node server.js
npm install -g nodemon


# Protractor
# ===========================
npm install -g protractor
# then
webdriver-manager update
# start
# webdriver-manager start