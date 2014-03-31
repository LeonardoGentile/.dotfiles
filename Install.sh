#!/bin/bash
# See: http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/

# USAGE
# =============================================
# sh ./Install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles

# VARIABLES
# =============================================

dir=~/.dotfiles             # dotfiles directory
olddir=~/.dotfiles_old      # old dotfiles backup directory
bindir=~/bin                # bin directory
oldbindir=~/bin_old         # old bin backup directory

# list of files/folders to symlink in homedir
files=".bash_profile .bashrc .gitattributes .gitconfig .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc bin/"


# =============================================#


# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Moving $file from ~ to $olddir"
    mv ~/$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/$file
done

# Moving .bash_extra file
echo "Moving .bash_extra from ~ to $olddir"
mv ~/.bash_extra $olddir
echo "Creating empty .bash_extra file in home directory."
cp $dir/.bash_extra ~/.bash_extra