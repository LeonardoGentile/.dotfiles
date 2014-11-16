# up to you (me) if you want to run this as a file or copy paste at your leisure


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


# PYTHON
# ===========================
brew install python giflib jpeg
pip install virtualenv virtualenvwrapper
# If virtualenvwrapper wont work just uninstall and reinstall virtualenv
pip install --allow-external PIL
# NOTE: double check the installation of PIL with the option --allow-external (if troubles install pillow)
# If PIL won't install just use
pip install pillow

pip install --upgrade pip
pip install --upgrade setuptools
# Then source: $(brew --prefix)/bin/virtualenvwrapper.sh
# If everything is ok 'which python' should be /usr/local/bin/python NOT /bin/python


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


# Grunt
# ===========================
npm install -g grunt-cli

# BOWER
# ===========================
npm install -g bower


# OAUTH.IO Daemon
# ===========================
npm install -g forever oauthd

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
