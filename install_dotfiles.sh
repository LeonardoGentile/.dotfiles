#!/usr/bin/env bash

#  =========
#  = USAGE =
#  =========
#   This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
#
#   git clone --recursive git@github.com:LeonardoGentile/.dotfiles.git
#   sh ./install_dotfiles.sh

# Variables
# ------------------------
dir=~/.dotfiles             # dotfiles directory
olddir=~/.dotfiles_old      # old dotfiles backup directory
bin=~/bin                   # bin directory
oldbin=~/bin_old            # old bin backup directory

# list of files/folders to symlink in homedir
files=".bash_profile .bashrc .gitattributes .gitconfig .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc .mackup.cfg .shuttle.json .iterm2_shell_integration.bash .iterm2"



# Create backup directory
# ------------------------
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"


#  ============================
#  = Copy not versioned files =
#  ============================
# Not in the repository, I overwrite these using my private .dotfiles

# bashmarks_dirs
# --------------
echo "Moving ~/.bashmarks_dirs from ~ to $olddir"
mv ~/.bashmarks_dirs $olddir
echo "Creating default .bashmarks_dirs file in home directory."
cp $dir/data/.bashmarks_dirs ~/.bashmarks_dirs
echo "========================================"


# bash_local, commented by default, to edit. Not tracked
# --------------------------------------------------
echo "Moving default .bash_local from ~ to $olddir"
echo "DON'T FORGET TO CONFIGURE .bash_local!"
mv ~/.bash_local $olddir
echo "Creating empty .bash_local file in home directory."
cp $dir/.bash_local ~/.bash_local     # Don't forget to configure the .bash_local
echo "========================================"


# gitconfig_local, commented by default, to edit. Not tracked
# --------------------------------------------------
echo "Moving default .gitconfig_local from ~ to $olddir"
echo "DON'T FORGET TO CONFIGURE .gitconfig_local!"
mv ~/.gitconfig_local $olddir
echo "Creating empty .gitconfig_local file in home directory."
cp $dir/.gitconfig_local ~/.gitconfig_local     # Don't forget to configure the .gitconfig_local
echo "========================================"



#  ======================
#  = Backup and Symlink =
#  ======================
# Change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir

# backup
# -------
# move any existing dotfiles in homedir to dotfiles_old directory
echo "Moving files:"
for file in $files; do
    # backup old dotfiles
    echo "Moving $file from ~ to $olddir"
    mv ~/$file $olddir
done
echo "========================================"

# symlink
# --------
# then create symlinks
echo "Linking:"
for file in $files; do
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/$file
done
echo "========================================"

#  ===================
#  = COPYING BIN DIR =
#  ===================
echo "Moving $bin to $oldbin"
mkdir -p $oldbin;
cp -r $bin $oldbin
rm -r $bin
echo "Installing bin dir."
ln -s $dir/bin ~/
echo "========================================"


#  ========================
#  = COPYING APPLICATIONS =
#  ========================
echo "Moving Application:"
if [ -d  /Applications ]; then
    echo "Moving spotifyLauncher to /Applications/Audio&Video"
    mkdir -p /Applications/Audio\&Video;
    cp -r $dir/apps/SpotifyLauncher.app/ /Applications/Audio\&Video/

    # Old Pomodoro app:
    #   https://github.com/ugol/pomodoro
    #   https://github.com/martakostova/pomodoro
    echo "Moving pomodoro to /Applications/Tools"
    mkdir -p /Applications/Tools;
    cp -r $dir/apps/pomodoro.app /Applications/Tools/
fi
echo "========================================"
echo "DONE."


#  ======================
#  = COPYING NVM CONFIG =
#  ======================
echo "NVM CONFIG"
mkdir -p $nvm_dir;
ln -s $dir/default-packages $nvm_dir/

echo "========================================"
echo "DONE."

# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# http://lostincode.net/posts/homebrew


