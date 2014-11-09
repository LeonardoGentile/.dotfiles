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
bin=~/bin                # bin directory
oldbin=~/bin_old         # old bin backup directory

# list of files/folders to symlink in homedir
files=".bash_profile .bashrc .gitattributes .gitconfig .gitignore_global .inputrc .osx .gvimrc .hushlogin .vimrc .wgetrc"


# =============================================#



# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"


################################
# NOT VERSIONED STUFF

# Moving .bashmarks_dirs file
# Not in the repository, I overwrite this using my private  .dotfiles
echo "Moving ~/.bashmarks_dirs from ~ to $olddir"
mv ~/.bashmarks_dirs $olddir
echo "Creating default .bashmarks_dirs file in home directory."
# Don't forget to configure the bash_extra
cp $dir/bashmarks/.bashmarks_dirs ~/.bashmarks_dirs


# Moving .bash_extra file
# Not in the repository
echo "Moving .bash_extra from ~ to $olddir"
mv ~/.bash_extra $olddir
echo "Creating empty .bash_extra file in home directory."
# Don't forget to configure the bash_extra
cp $dir/.bash_extra ~/.bash_extra

# Moving .git_extra file
# Not in the repository, to prevent people from accidentally committing under my name
echo "Moving DEFAULT .git_extra from ~ to $olddir (EDIT IT!!)"
mv ~/.git_extra $olddir
echo "Creating empty .bash_extra file in home directory."
# Don't forget to configure the bash_extra
cp $dir/.git_extra ~/.git_extra


# END NOT VERSIONED STUFF
################################


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

# Copying bin dir
echo "Moving $bin to $oldbin"
mkdir -p $oldbin;
cp -r $bin $oldbin
rm -r $bin
echo "Installing bin dir."
ln -s $dir/bin ~/
# cp -r

echo "Moving spotifyLauncher to /Applications/Audio&Video"
mkdir -p /Applications/Audio\&Video;
cp -r ~/apps/SpotifyLauncher.app/ /Applications/Audio\&Video/

# See here if it won't work https://github.com/ugol/pomodoro
echo "Moving pmodoro to /Applications/Tools"
mkdir -p /Applications/Tools;
cp -r ~/apps/pomodoro.app /Applications/Tools/


# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# http://lostincode.net/posts/homebrew