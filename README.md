# Dotfiles

This repository represents my personal "dotfiles" that basically are all the configurations files  that sits in my home folder.   
Setting up the perfect development environment could take an incredible amount of time, that is why I'm versioning all my dotfiles and writing down a reproducible  procedure to set up a good development environment. This will help me to setup again a machine after a fresh install and hopefully help someone else out there. 

These settings are mainly focused on __Mac Os X Mavericks__ but can be adapted to another Os X version with some tweaks.   
I'm also planning to create a parametric script to install and setup a dev machine for Mac, Linux Desktop and Linux Server (when I'll have 5 minutes, maybe..)

#Preparation 
Before installing the dotfiles I perform some extra steps to assure to have everything functioning for the next steps  

1. download and install:   
    - http://www.google.com/chrome/     
    - https://evernote.com/download/    
    - http://iterm2.com/    
2. `iterm2` settings:   
    - Theme:
        - download and extract http://ethanschoonover.com/solarized
        - open `iterm2-colors-solarized` folder and  double click on `Solarized Dark.itermcolors`
        - open iterm `settings/profile/colors/load presets` and choose `Solarized Dark` color scheme (or your favorite theme)
    - Fonts for `powerline`
        - download and extract https://github.com/Lokaltog/powerline-fonts/archive/master.zip
        - drag the whole folder over `Font Book` application. This will install all the fonts system wide
        - open iterm `settings/profile/text/`
            - `Regular Font` and chose `DejaVu sans mono 12pt for Powerline`
            - `Antialiased` and chose `Inconsolata 12pt for Powerline`
3. Generate github `ssh` keys:
    - `ssh-keygen -t rsa -C "your_email@example.com"`  
    - Enter a passphrase (annotate it!)
    - pbcopy < ~/.ssh/id_rsa.pub
    - Go on Github  `Profile/ account  / Edit Profile / SSH Keys / Add SSH Key` and paste the previousy copied ssh key. You can follow a similar  process for  Bitbucket
    - `ssh -T git@github.com` to verify that the settings are ok. The first time you will be asked to insert your passphrase, do it and then tell keychain to remember it. From now on you won't be asked again for the passphrase. In case everything was set up  correctly you should get a message `Hi YourUserName! You've successfully authenticated, but GitHub does not provide shell access.`
    - Reference: https://help.github.com/articles/generating-ssh-keys
4. Get Xcode from App Store
    - Open xcode to agree to the TOS (This will actually install the components)
    - This will install also git (from apple)


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

1. create two folder in your home directory called `.dotfiles_old` and `bin_old` 
2. move all existing files contained in the  `files` variable `.bash_profile .bashrc .gitattributes .gitconfig .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc` from your home folder to the `.dotfiles_old` folder (so you may recuperate your existing files if anything goes wrong). 
3. move your `~/bin` folder (if it exists) to `~/old_bin` (as of point 2 for backup reasons).    
__IMPORTANT:__ if you repeat these steps a second time your personal dotfiles and `bin` folder (and its contents) will be lost forever! So please put them in a safe place if you really need them!
4. symlink the following files `.bash_profile .bashrc .gitattributes .gitconfig .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc`
from the `.dotfiles` folder to your your home folder. Change the `files` variable if you want to change this list
5. symlink the `~/.dotfiles/bin` folder to `~/bin`

__Why symlinking?__  
Whenever you want to modify a files that you are tracking (for example your `.bash_profile`) you can just `cd ~` and edit it from there. What will be actually modified is `~/.dotfiles/.bash_profile`. This way all the dotfiles are cleaned organized in the `.dotfiles` folder and you don't have to remember which files in your home is versioned or not.

## Step 2: Dotfiles privates
Apart from my public dotfiles I keep some settings private in a bitbucket repository.
Some files I keep there, for example: 

 - "extra" dotfiles 
    - `.bashmarks_dirs`  (extra directories "bookmarks" for bashmarks)
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

        dir=~/.dotfiles-private             # dotfiles directory
        olddir=~/.dotfiles-private_old      # old dotfiles backup directory
        # list of files/folders to symlink in homedir
        files=".git_extra .shuttle.json"
        # create dotfiles_old in homedir
        echo "Creating $olddir for backup of any existing dotfiles in ~"
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

I do so because these are files that I do NOT want to versionate. The `Install.sh` copies them in home and if I edit them in `home` nothing will happens to the `.dotfiles` repo. 

## Step 1: prepare Mac OS X

1. Install Xcode from the App Store
2. Open Xcode's preferences and install the command line tools package (this will also install Git) (on OS X Mavericks you need to run `xcode-select --install` instead)
3. Install http://coderwall.com/p/dlithw *(optional)*
4. Install http://www.starryhope.com/keyfixer/ *(optional)*


## Step 2: install Homebrew

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

