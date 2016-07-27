#Dotfiles

This repository represents my personal "dotfiles", settings and instructions to setup the perfect development environment on a Mac Os X machine. This will help me to setup again a machine after a fresh install and hopefully help someone else out there. 

These settings have been tested on __Mac Os X Mavericks__ and __El Capitan__ but they can be adapted to another Os X version with some tweaks.   

#Preparation 
Before installing the dotfiles I perform some extra steps to assure to have everything functioning for the following steps  

1. If installing under Mac Os then open the files [osx_installation/README.md](./osx_installation/README.md) and follow the instruction under the __Preparation__ section.
2. Generate github and bitbucket [`ssh` keys](https://help.github.com/articles/generating-ssh-keys):  
    - run `ssh-keygen -t rsa -C "your_email@example.com"`    
    - enter a passphrase (annotate it!)  
    - pbcopy < ~/.ssh/id_rsa.pub  
    - go to __Github__  `profile/account/Edit Profile/SSH Keys/Add SSH Key` and paste the previously copied ssh key. You can follow a similar  process for  Bitbucket  
        - `ssh -T git@github.com` to verify that the settings are ok
        - The first time you will be asked to insert your pass-phrase, do it and then tell keychain to remember it. From now on you won't be asked again for the pass-phrase.   
        - In case everything was set up  correctly you should get a message `Hi YourUserName! You've successfully authenticated, but 
        GitHub does not provide shell access.`
    - go to __BitBucket__ `Profile/ Bitbucket Settings/ SSH Keys/ Add Key`
        + switch the default url scheme from https to ssh


#Dotfiles installation 

## Step 1: Installation script

1. `cd ~ `
2. `git clone --recursive git@github.com:LeonardoGentile/.dotfiles.git`   
    if you forgot `--recursive` option then `cd .dotfiles; git submodule update --init`
3. `cd .dotfiles`
4. `sh install_dotfiles.sh`
5. `cd powerline-shell`
6. edit `config.py` (optional)
7. `python install.py`


This script will:  

1. create two directories inside your home directory called `.dotfiles_old` and `bin_old` 
2. move all existing files contained in the  `files` variable (see step 4 for the list) from your home directory to the `.dotfiles_old` directory (so you may restore your original files if anything goes wrong)
3. move your `~/bin` directory (if it exists) to `~/old_bin` (as of point 2 for backup reasons)   
__IMPORTANT:__ if you repeat these steps a second time your personal dotfiles and `bin` directory (and its contents) will be lost forever! So please put them in a safe place if you really need them!
4. symlink the following files `.bash_profile .bashrc .gitattributes .gitconfig .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc`
from the `~/.dotfiles` directory to your your home directory.   
__NOTE__: change the `files` variable if you want to change this list
5. symlink the `~/.dotfiles/bin` directory to `~/bin`

__Why symlinking?__  
Whenever you want to modify a files that you are tracking (for example your `.bash_profile`) you can just `cd ~` and edit it from there. What will be actually modified is `~/.dotfiles/.bash_profile`. This way all the dotfiles are cleaned organized in the `.dotfiles` directory and you don't have to remember which files in your home is versioned or not.

## Step 2: Dotfiles privates (optional)
Apart from my public dotfiles I keep some private settings in a private repository.
Some files I keep there: 

 - "extra" dotfiles 
    - `.bashmarks_dirs`  (extra "bookmarks" directories for bashmarks)
    - `.git_extra` 

            [user]
                name = Name Surname
                email = myemail@myprovider.com
    - ` .shuttle.json` for [shuttle](http://fitztrev.github.io/shuttle/)
    - `.z` database for [z](https://github.com/rupa/z)
    - `config` ssh "bookmarks" config file compatible with `shuttle`  
- applications settings 
    + [betterTouchTool](http://www.boastr.net) becase I hate how the default gestures have changed after snow leopard 
    + [Karabinier](https://pqrs.org/osx/karabiner/) because it solves all the problems that apple will never solve 
        + `org.pqrs.KeyRemap4MacBook.plist` 
        + `private.xml`

For installing these private files I do:

- `cd ~`
- `git clone my-private-repo-url.git`
- `cd .dotfiles-privates`
- `sh install_private.sh` where `install_private.sh` is a script similar to the one you can see in the step1 that simlynks and copies files around to the right destination, for example:

        dir=~/.dotfiles-privates            # dotfiles directory
        olddir=~/.dotfiles-private_old      # old dotfiles backup directory
        
        # list of files/folders to symlink in homedir
        files=".git_extra .shuttle.json"
        
        # create dotfiles-private_old in homedir
        echo "Creating $olddir for backup of any existing dotfiles-privates in ~"
        mkdir -p $olddir
        # move any existing dotfiles in homedir to dotfiles-private_old directory, then create symlinks
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
The `install_dotfiles.sh` script from the step 1 doesn't symlink everything, in fact it will __copy__ some files instead from `~/.dotfiles` to `~/`:

- `.bashmarks_dirs`
- `.git_extra`

I do so because these are files that I do NOT want to track. The `install_dotfiles.sh` (step 1) copies them in home and if I edit them in `home` nothing will happens to the `.dotfiles` repo.  Usually I overwrite these files with the ones coming from `.dotfiles-private` (`install_private.sh` from step 2)

#OsX Installation Instruction
Follow the instruction listed under the __Installation Steps__ of the [./osx_installation/README.md](./osx_installation/README.md) file.

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

