# Dotfiles

This repository represents my personal "dotfiles", settings and instructions to setup the perfect development environment on a Mac Os X machine. This will help me to setup again a machine after a fresh install and hopefully help someone else out there. 

These settings are mainly focused on __Mac Os X Mavericks__ but they can be adapted to another Os X version with some tweaks.   
I'm also planning to create a parametric script to install and setup a dev machine for Mac, Linux Desktop and Linux Server (when I'll have 5 minutes, maybe..)

#Preparation 
Before installing the dotfiles I perform some extra steps to assure to have everything functioning for the following steps  

1. download and install:   
http://www.google.com/chrome/     
https://evernote.com/download/    
http://iterm2.com/    
2. `iterm2` settings:   
    - Theme:
        - download and extract [Solarized Dark Theme](http://ethanschoonover.com/solarized)
        - open `iterm2-colors-solarized` folder and  double click on `Solarized Dark.itermcolors`
        - open iterm `Preferences/Profiles/Colors/Load presets` and chose `Solarized Dark` color scheme (or your favorite theme)
    - Fonts for `powerline`
        - download and extract the [fonts for powerline](https://github.com/Lokaltog/powerline-fonts/archive/master.zip) 
        - drag the whole folder over `Font Book` application. This will install all the fonts system wide
        - open iterm `Preferences/ Profiles / Text /`
            - `Regular Font` and select `DejaVu sans mono 12pt for Powerline`
            - `Antialiased` and select `Inconsolata 12pt for Powerline`
3. Generate github [`ssh` keys](https://help.github.com/articles/generating-ssh-keys):  
    - run `ssh-keygen -t rsa -C "your_email@example.com"`    
    - enter a passphrase (annotate it!)  
    - pbcopy < ~/.ssh/id_rsa.pub  
    - go on Github  `profile/account/Edit Profile/SSH Keys/Add SSH Key` and paste the previously copied ssh key. You can follow a similar  process for  Bitbucket  
    - `ssh -T git@github.com` to verify that the settings are ok
    - The first time you will be asked to insert your pass-phrase, do it and then tell keychain to remember it. From now on you won't be asked again for the pass-phrase.   
    - In case everything was set up  correctly you should get a message `Hi YourUserName! You've successfully authenticated, but GitHub does not provide shell access.`
4. Get Xcode from App Store  
    - open xcode to agree to the TOS (or it won't install the components)  
    -  install Command Line Tools: `xcode-select --install`  then click install  
    -  open Xcode's preferences and install the command line tools package (this will install also git, from apple)  


#Dotfiles installation 

## Step 1: Installation script

1. `cd ~ `
2. `git clone --recursive git@github.com:LeonardoGentile/.dotfiles.git` 
3. `cd .dotfiles`
4. `sh Install.sh`
5. `cd powerline-shell`
6. edit `config.py` (optional)
7. `python install.py`


This script will:  

1. create two directories inside your home directory called `.dotfiles_old` and `bin_old` 
2. move all existing files contained in the  `files` variable (see step 4 for the list) from your home directory to the `.dotfiles_old` directory (so you may restore your original files if anything goes wrong)
3. move your `~/bin` directory (if it exists) to `~/old_bin` (as of point 2 for backup reasons)   
__IMPORTANT:__ if you repeat these steps a second time your personal dotfiles and `bin` directory (and its contents) will be lost forever! So please put them in a safe place if you really need them!
4. symlink the following files `.bash_profile .bashrc .gitattributes .gitconfig .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc`
from the `.dotfiles` directory to your your home directory.   
Change the `files` variable if you want to change this list
5. symlink the `~/.dotfiles/bin` directory to `~/bin`

__Why symlinking?__  
Whenever you want to modify a files that you are tracking (for example your `.bash_profile`) you can just `cd ~` and edit it from there. What will be actually modified is `~/.dotfiles/.bash_profile`. This way all the dotfiles are cleaned organized in the `.dotfiles` directory and you don't have to remember which files in your home is versioned or not.

## Step 2: Dotfiles privates (optional)
Apart from my public dotfiles I keep some private settings in a bitbucket repository.
Some files I keep there: 

 - "extra" dotfiles 
    - `.bashmarks_dirs`  (extra "bookmarks" directories for bashmarks)
    - `.git_extra` 

            [user]
                name = Name Surname
                email = myemail@myprovider.com
    - ` .shuttle.json` for http://fitztrev.github.io/shuttle/
    - `.z` database for https://github.com/rupa/z
    - `config` ssh "bookmarks" config file compatible with `shuttle`  
- applications settings 
    - `betterTouchTool`  becase I hate how the default gestures have changed after snow leopard http://www.boastr.net
- Karabinier because it solves all the problem that apple will never solve https://pqrs.org/osx/karabiner/
    - `org.pqrs.KeyRemap4MacBook.plist` 
    - `private.xml`


For installing these private files I do:

- `cd ~`
- `git clone git@bitbucket.org:myusername/.dotfiles-private.git`
- `cd .dotfiles-privates`
- `sh Install.sh` where `Install.sh` is a script similar to the one you can see in the step1 that simlynks and copies files around to the right destination, for example:

        dir=~/.dotfiles-privates            # dotfiles directory
        olddir=~/.dotfiles-private_old      # old dotfiles backup directory
        
        # list of files/folders to symlink in homedir
        files=".git_extra .shuttle.json"
        
        # create dotfiles_old in homedir
        echo "Creating $olddir for backup of any existing dotfiles-privates in ~"
        mkdir -p $olddir
        # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
        for file in $files; do
            echo "Moving $file from ~ to $olddir"
            mv ~/$file $olddir
            echo "Creating symlink to $file in home directory.\n"
            ln -s $dir/$file ~/$file
        done

        # BASHMARKS DIRS
        echo "Moving .bashmarks_dirs config from ~/.bashmarks_dirs to $olddir"
        mv ~/.bashmarks_dirs $olddir
        echo "Linking bashmarks_dirs from ~/.bashmarks_dirs to $dir/.bashmarks_dirs\n"
        ln -s $dir/.bashmarks_dirs ~/.bashmarks_dirs

        # Z database
        echo "Moving .z from ~/.z to $olddir"
        mv ~/.z $olddir
        echo "Linking .z from $dir/.z to ~/.z\n "
        ln -s $dir/.z  ~/.z

        # SSH CONFIG
        echo "Moving ssh config from ~/.ssh/config to $olddir"
        mv ~/.ssh/config $olddir
        echo "Linking ssh config from .ssh/config to $dir/config\n"
        ln -s $dir/config ~/.ssh/config

        # Karabiner private.xml Config file
        mv ~/Library/Application\ Support/Karabiner/private.xml $olddir
        echo "Linking private.xml from from ~/Library/Application Support/Karabiner/private.xml to $dir/private.xml\n"
        ln -s $dir/private.xml  ~/Library/Application\ Support/Karabiner/private.xml
        
        mv ~/Library/Preferences/org.pqrs.Karabiner.plist $olddir
        echo "Linking private.xml from from ~/Library/Preferences/org.pqrs.Karabiner.plist to $dir/org.pqrs.Karabiner.plist\n"
        ln -s $dir/org.pqrs.Karabiner.plist  ~/Library/Preferences/org.pqrs.Karabiner.plist

## Wrapping it up
The `Install.sh` script from the step 1 doesn't symlink everything, in fact it will __copy__ some files instead from `~/.dotfiles` to `~/`:

- `.bashmarks_dirs`
- `.bash_extra`
- `.git_extra`

I do so because these are files that I do NOT want to track. The `Install.sh` (step 1) copies them in home and if I edit them in `home` nothing will happens to the `.dotfiles` repo.  Usually I overwrite these files with the ones coming from `.dotfiles-private` (`Install.sh` from step 2)

## Mac OS X Installation 

## Step 1: Install Homebrew 

I usually run step by step all the instruction in `~/.dotfiles/Mac_Installation/1.brew.sh` but the shortest way is to `sh 1.brew.sh`   

Install [Brew](http://brew.sh/)

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
    brew upgrade

Install brew formulae
    
    brew install git
    brew install coreutils  # they will be used by .bash_profile if installed
    brew install findutils
    brew install bash
    brew install wget --with-iri 
    brew install bash-completion # sometimes I need to run this twice to make the completions work
    brew install node

and all the other formulae that you need (see `1.brew.sh`). Finally run
    
    brew cleanup

## Step 2:  Install developer tools

Run step by step or `sh 2.install-dev.sh`

### rbenv
    brew install rbenv #for different versions of ruby
    brew install ruby-build

Then list all the available versions of ruby

    rbenv install -l 
Then select one, for example
    
    rbenv install 2.1.2   # will install ruby 2.1.2
    rbenv global 2.1.2    # makes ruby 2.1.2 the default one
    rbenv rehash          # Run this command after you install a new version of Ruby, or install a gem that provides commands
__rbenv gemset__, for sandboxed collection of gems, for example for a specific project. SEE: https://github.com/jf/rbenv-gemset

    brew install rbenv-gemset
__specific_install__ to install gem from github (or anywhere else)
    
    gem install specific_install  # USAGE: gem specific_install -l <url to a github gem>

__Gemfile__

    gem install bundler
    rbenv rehash
    bundle install
This will create a `Gemfile.lock` file

### compass

    gem update --system
    gem install compass

### termrc
[termrc](https://github.com/briangonzalez/termrc) is amazing! This little command will help you starting up iterm2 envs from shell. 
    
    gem install termrc
__Example__:

Create a `Termfile` in your project directory
    
    commands:
      django_server:    cd myproject; workon myproject; python manage.py runserver;
      grunt_server:      cd myproject; cd webapp; grunt serve
      celery_server:     cd myproject; workon myproject; celery -A myproject worker -l info;
      commands_tab:  cd myproject; workon myproject

    layout:
      - [ django_server, grunt_server ]         # row 1, with 2 panes
      - [ celery_server, commands_tab ]       # row 2, with 2 pane
then run 
    
    termrc start
This will create 4 panes in iterm2 (2 for row) with your favorite commands for your project. I created an alias in `.bash_aliases`

    alias start="termrc start"
so that I just `cd myproject; start` will launch my defined panes and commands defined in the `Termfile`. This saves me a lot of time!

### python

    brew install python giflib jpeg
    pip install virtualenv virtualenvwrapper
    pip install --upgrade pip
    pip install --upgrade setuptools
    pip install pillow    # globally installed Pillow, because PIL just creates too much installation troubles!
    pip install Pygments # for the c alias (syntax highlighted cat)
Then don't forget to source: `$(brew --prefix)/bin/virtualenvwrapper.sh`.   
If everything is ok `which python` should prompt `/usr/local/bin/python` NOT `/bin/python`

###PostgreSQL
    brew install postgresql
    initdb /usr/local/var/postgres
    # To use postgres with Python:
    export CFLAGS=-Qunused-arguments
    export CPPFLAGS=-Qunused-arguments
    pip install psycopg2

### MYSQL
    brew install mysql
    # Or if you prefer mariadb 
    # brew install mariadb 
    # then also follow the instruction for setting up php.ini (under __apache__ section)
    unset TMPDIR
    mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
For setup:

* launch mysql (I usually do so with `launchroket`, see Step 3)
* `mysql_secure_installation`
* `sudo cp $(brew --prefix mysql)/support-files/my-default.cnf /etc/my.cnf`

For python (globally)
    
        pip install mysql-python

###Apache, mod_php and mod_wsgi 
`mod_php` is already installed (but not activated) while we need to install `mod_wsgi` from brew.

#### mod_php
`cd /etc/apache2`  
`sudo vi httpd.conf`  
uncomment `# LoadModule php5_module libexec/apache2/libphp5.so`    
next find the `<IfModule dir_module>`, should be around the line 231 and substitute this block
    
    <IfModule dir_module>
        DirectoryIndex index.html
    </IfModule>
with
    
    <IfModule dir_module>
        DirectoryIndex index.html index.php
    </IfModule>
this tells apache to process `index.html` OR `index.php` if a directory is requested.  
Setup your `php.ini`

####php.ini
`cd /etc/`  
`sudo cp php.ini.default php.ini`  

In case you installed and want to use _mariadb_ instead of _mysql_ then:
`sudo chmod +w php.ini`  
`sudo vi php.ini`    
> In php.ini, change the MySQL Unix socket (MariaDB installed by Homebrew use /tmp/mysql.sock by default). If php.ini copied from php.ini.default is not writable, make it writable then replace every occurence of /var/mysql/mysql.sock with /tmp/mysql.sock (it should be at two places)  
> <cite>[Credits](http://blog.manbolo.com/2013/05/02/build-and-deploy-a-django-project-on-osx-from-scratch#4)</cite>

Search for `;date.timezone = Europe/London` and uncomment it by removing the semicolon and add your timezone, for example: `date.timezone = Europe/London`. Then test apache and restart it:

`apachectl configtest`  
`sudo apachectl graceful`

#####Php built-in web server:
Php has a built-in development server, if you just want a basic local web server you can `cd mywebsite` and launch `php -S localhost:8000`
and access it at the address `http://localhost:8000`.   
Furthermore if you are using a php web framework, for example Silex, you can specify your application entry point (routing): `php -S localhost:8000 index.php`.   
In my `.bash_functions` there is a function called `server`, when I need a server on a directory, I just cd into it and launch `server` it will also open Chrome Canary (if installed) at the specified address or the default browser if Canary was not found.




#### mod_wsgi
    brew tap homebrew/apache
    brew install mod_wsgi
If problem in compiling see: https://github.com/Homebrew/homebrew-apache  
In short:
    
    $ sudo ln -s /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/ /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.9.xctoolchain
 edit `/etc/apache2/http.conf ` and add this:  
 `LoadModule wsgi_module /usr/local/Cellar/mod_wsgi/3.4/libexec/mod_wsgi.so` or the correct version you have in Cellar  
 Then test everything is ok:
 
    apachectl configtest   
    sudo apachectl restart  

####mod_rewrite
Be also sure to uncomment `LoadModule rewrite_module libexec/apache2/mod_rewrite.so` in your `httpd.conf` file.   
Normally by default this line should be already uncommented but better to double check.  
`mod_rewrite` is what let you create websites with pretty URLs as for example applications like WordPress do.  
Open `/etc/apache2/httpd.conf` and look for all occurrences of  `AllowOverride None` and change them with `AllowOverride All` in the relevant places you want to make pretty urls. Then again:
    
    apachectl configtest   
    sudo apachectl restart  

### alcatraz
[alcatraz](http://alcatraz.io) packet manager for xcode. I don't have enough experience with this, I need to play with it a little bit more

    curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
    # uninstall with
    rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin
    # Remove all cached data:
    rm -rf ~/Library/Application\ Support/Alcatraz

### nave, virtualenvs for node
[nave](https://github.com/isaacs/nave) 
    
    # needs npm, obviously.
    npm install -g nave

### Front-end things

#### grunt
    npm install -g grunt-cli

#### bower
    npm install -g bower

#### Yeoman
    brew install optipng jpeg-turbo phantomjs
    npm install -g yo    

## Step 3: Install applications with cask
"Homebrew [Cask](http://caskroom.io/) extends Homebrew and brings its elegance, simplicity, and speed to OS X applications and large binaries alike."
Basically I can install all my GUI application just by `sh 3.cask.sh` so I don't have to find each App homepage, download them, unzip, mount the dmg, drang and drop..I have so many apps that this task could take a lot of times. And most important I never remember all the apps I had previously installed.
To Install cask
    
    brew install caskroom/cask/brew-cask
To find an application
    
    brew cask search chrome
will return a list with all matching applications.  
To install for example dropbox in `/Applications/Web` directory:
    
    brew cask install --appdir="/Applications/Web"    dropbox

I've created two aliases. In `.bash_aliases` 
    
    alias casksearch='brew cask search'
and in `.bash_functions`
    
    function caskInstall() {
        brew cask install "${@}" 2> /dev/null
    }

#### launchRocket
[LanuchRocket](https://github.com/jimbojsb/launchrocket) is a Mac PrefPane to manage all your Homebrew-installed services
    
    brew cask install launchrocket
This will make your life easier when you need to launch/stop/launch at startup services. For example you can handle `mysql` `mongodb`
`rabbitmq`, `postgresql` and so on..

#Voilà!
That's all folks! I spent and I keep on spending a lot of time on my personal dev enviroment and setting it up was not easy. I hope this will help someone. Things are a little dirty and I should clean them up a little bit. Feel free to grab my code and make some correction to the dumb things I've created or written ;)

Thanks to many people:

* https://github.com/javierjulio/dotfiles
*  https://github.com/kevinrenskers/dotfiles
*  https://github.com/paulirish/dotfiles
*  https://github.com/mathiasbynens/dotfiles/

and so many other people from whom I've taken code and inspiration and I've forgot to write them down. Sorry if I haven't included you here, I will try to do my best to remember all the sources!

# Disclaimer:
Please try to understand what you type on you terminal before copy-paste and execute. 

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

