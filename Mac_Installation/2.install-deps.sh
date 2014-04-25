# up to you (me) if you want to run this as a file or copy paste at your leisure

# OPTIONAL:
# https://github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to my clipboard is heaven
# 
# bash < <( curl https://raw.github.com/jamiew/git-friendly/master/install.sh)

# https://rvm.io
# rvm for the rubiess
curl -L https://get.rvm.io | bash -s stable --ruby

# SEE: https://github.com/kevinrenskers/dotfiles#ruby-rvm-ruby-version-manager-and-rubygems
# $ rvm install 1.9.3
# $ rvm --default use 1.9.3
# 
# Once RVM is installed you can install your favorite packages:
# $ gem install cocoapods
# $ gem install rails
# 
# To update RVM itself:
# $ rvm get stable
# To update RubyGems itself:
# $ gem update --system


# COMPASS:
gem update --system
gem install compass


# Python (ok)
brew install python giflib jpeg
pip install virtualenv wheel virtualenvwrapper --allow-external PIL
# If virtualenvwrapper wont work just uninstall and reinstall virtualenv
pip install --upgrade pip
pip install --upgrade setuptools
# Then source: $(brew --prefix)/bin/virtualenvwrapper.sh
# If everything is ok which python should be /usr/local/bin/python NOT /bin/python 

# PostgreSQL (OK)
brew install postgresql
initdb /usr/local/var/postgres
cp /usr/local/Cellar/postgresql/9.2.4/org.postgresql.postgres.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

# To use postgres with Python:
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
sudo pip install psycopg2

# MYSQL
brew install mysql
unset TMPDIR
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
mysql_secure_installation
sudo cp $(brew --prefix mysql)/support-files/my-default.cnf /etc/my.cnf

sudo pip install mysql-python

# config file
# /usr/local/Cellar/mysql/5.6.12/my.cnf

# Start/stop
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist


# Grunt
npm install -g grunt-cli
# bower 
npm install -g bower
# yeoman (maybe sudo)
npm install yeoman -g

# NAVE: VIRTUALENVS FOR NODE  
# https://github.com/isaacs/nave
# needs npm, obviously.
# TODO: I think i'd rather curl down the nave.sh, symlink it into /bin and use that for initial node install.
npm install -g nave





# https://github.com/rupa/z
# z, oh how i love you
cd ~/code
git clone https://github.com/rupa/z.git
chmod +x ~/code/z/z.sh
# also consider moving over your current .z file if possible. it's painful to rebuild :)

# z binary is already referenced from .bash_profile

# https://github.com/dronir/SpotifyControl
# Spotify Controll Script
cd ~/code
git clone git://github.com/dronir/SpotifyControl.git

# https://github.com/jeroenbegyn/VLCControl
# VLC Controll Script
cd ~/code
git clone git://github.com/jeroenbegyn/VLCControl.git


# my magic photobooth symlink -> dropbox. I love it.
# first move Photo Booth folder out of Pictures
# then start Photo Booth. It'll ask where to put the library.
# put it in Dropbox/public

# now you can record photobooth videos quickly and they upload to dropbox DURING RECORDING
# then you grab public URL and send off your video message in a heartbeat.


# for the c alias (syntax highlighted cat)
sudo easy_install Pygments
