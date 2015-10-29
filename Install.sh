#!/bin/bash
#  =========
#  = USAGE =
#  =========
#   This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
#
#   git clone --recursive git@github.com:LeonardoGentile/.dotfiles.git
#   sh ./Install.sh

# Variables
# ------------------------
dir=~/.dotfiles             # dotfiles directory
olddir=~/.dotfiles_old      # old dotfiles backup directory
bin=~/bin                # bin directory
oldbin=~/bin_old         # old bin backup directory

# list of files/folders to symlink in homedir
files=".bash_profile .bashrc .gitattributes .gitconfig .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc .mackup.cfg .shuttle.json"

# Create backup directory
# ------------------------
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# Copy not versioned files
# ------------------------
# Not in the repository, I overwrite these using my private .dotfiles
echo "Moving ~/.bashmarks_dirs from ~ to $olddir"
mv ~/.bashmarks_dirs $olddir
echo "Creating default .bashmarks_dirs file in home directory."
cp $dir/bashmarks/.bashmarks_dirs ~/.bashmarks_dirs # Don't forget to configure the bash_extra

echo "Moving .bash_extra from ~ to $olddir"
mv ~/.bash_extra $olddir
echo "Creating empty .bash_extra file in home directory."
cp $dir/.bash_extra ~/.bash_extra   # Don't forget to configure the bash_extra

# Not in the repository, to prevent people from accidentally committing under my name
echo "Moving default .git_extra from ~ to $olddir (EDIT IT!!)"
mv ~/.git_extra $olddir
echo "Creating empty .bash_extra file in home directory."
cp $dir/.git_extra ~/.git_extra     # Don't forget to configure the bash_extra


# Backup and Symlink
# ------------------------
# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    # backup old dotfiles
    echo "Moving $file from ~ to $olddir"
    mv ~/$file $olddir
    # create symlinks from .dotfiles to ~
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/$file
done

# Copying bin dir
# ------------------------
echo "Moving $bin to $oldbin"
mkdir -p $oldbin;
cp -r $bin $oldbin
rm -r $bin
echo "Installing bin dir."
ln -s $dir/bin ~/
# cp -r

# Copying application
# ------------------------
if [[ -d  /Applications ]]; then
    echo "Moving spotifyLauncher to /Applications/Audio&Video"
    mkdir -p /Applications/Audio\&Video;
    cp -r ~/apps/SpotifyLauncher.app/ /Applications/Audio\&Video/

    # See here if it won't work https://github.com/ugol/pomodoro
    echo "Moving pomodoro to /Applications/Tools"
    mkdir -p /Applications/Tools;
    cp -r ~/apps/pomodoro.app /Applications/Tools/
fi


# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# http://lostincode.net/posts/homebrew