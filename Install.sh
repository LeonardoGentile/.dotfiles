#!/bin/bash
# See: http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/

# USAGE
# =============================================
# sh ./Install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles

# git clone --recursive git@github.com:LeonardoGentile/.dotfiles.git

# VARIABLES
# =============================================

dir=~/.dotfiles             # dotfiles directory
olddir=~/.dotfiles_old      # old dotfiles backup directory
bindir=~/bin                # bin directory
oldbindir=~/bin_old         # old bin backup directory

# list of files/folders to symlink in homedir
files=".bash_profile .bashrc .gitattributes .gitconfig .gitconfig_name .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc"


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
# Not in the repository, to prevent people from accidentally committing under my name
echo "Moving .bash_extra from ~ to $olddir"
mv ~/.bash_extra $olddir
echo "Creating empty .bash_extra file in home directory."
# Don't forget to configure the bash_extra
cp $dir/.bash_extra ~/.bash_extra


# Copying bin dir
echo "Moving $bin to $olbin"
mv $bindir $oldbindir
echo "Installing bin dir."
cp -r ~/.dotfiles/bin ~/

# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# http://lostincode.net/posts/homebrew