#!/usr/bin/env bash
#
# NOTE: '#!/usr/bin/env NAME'
# is used when we aren't aware of the absolute path of bash or don't want to search for it.


#  ======================================
#  = PROFILING STARTUP TIME (for debug) =
#  ======================================
# PROFILE_STARTUP=false
# if $PROFILE_STARTUP; then
#     # PS4='+ $(date "+%s.%N")\011 '
#     PS4='$(date "+%s.%N")\011 '
#     exec 3>&2 2>/tmp/bashstart.$$.log
#     # exec 3>&2 2> >( tee /tmp/bashstart-$$.log |
#     #               gsed -u 's/^.*$/now/' |
#     #               date -f - +%s.%N >/tmp/bashstart-$$.tim)
#     set -x # shortcut for 'set -o xtrace'.
#     # It prints command traces before executing command.
#     # The dash is used to activate a shell option and a plus to deactivate it.
# fi


#  ============================
#  = ********* INIT ********* =
#  ============================
# get info from uname and convert to lowercase
OS="$(echo $(uname -s) | tr '[:upper:]' '[:lower:]')"
# or OS=$OSTYPE
case $OS in

    Darwin*|darwin)
        # Compilation stuff (Set architecture flags)
        export ARCHFLAGS="-arch x86_64"
        mac=true
        linux=false
    ;;

    linux*)
        mac=false
        linux=true
    ;;
    # OTHERS:
#    solaris*)  echo "SOLARIS" ;;
#    bsd*)      echo "BSD" ;;
#    Windows*)  echo "Win" ;;
#    cygwin*)   echo "Win" ;;
#    *)         echo "unknown: $OSTYPE" ;;
esac


# Helper Functions
# ----------------
# USAGE:
# pathprepend /usr/local/bin /usr/local/sbin

pathprepend() {
    for ((i=$#; i>0; i--));
    do ARG=${!i}
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="$ARG${PATH:+":$PATH"}"
        fi
    done
}

pathappend() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}



#  ============================
#  = ********* PATH ********* =
#  ============================

# Loading sequence:
#   1     /etc/paths
#   2     /etc/paths.d/whatever (e.g. x11, 40-XQuarts)
#   3     ~/.MacOSX/environment.plist (AVOID!)
#   4     PATH defined in this file
#
#   BEWARE: Avoid (3) cause it overrides the default PATH set in /etc/paths and it is deprecated

# For loading HOMEBREW binaries first you might change the /etc/paths file
# putting /usr/local/bin at the beginning of the file instead of the end
# Even if we do it here sometimes could be 'too late'


# BREW PATH
# ============
# brew bins should have priority
pathprepend /usr/local/bin /usr/local/sbin

# Flags for brew and coreutils
if $mac; then
    if hash brew 2>/dev/null; then
        brew=true
        # Cache vars
        coreutils=$(brew --prefix coreutils)
        pfx=$(brew --prefix)
    else
        brew=false
        coreutils=false
    fi
elif $linux; then
    brew=false
fi


# (GNU) COREUTILS PATH
# ===========================
# I use the GNU ls (gls) included in COREUTILS (downloaded with BREW)
# This let me use dircolors command, that will use .dircolors file to colorize gls:
#   http://lostincode.net/posts/homebrew
#   http://www.conrad.id.au/2013/07/making-mac-os-x-usable-part-1-terminal.html
#   https://github.com/seebi/dircolors-solarized

# Flag to check if we are using coreutils GNU ls or Apple ls
coreutils_installed=false
if [[  $coreutils && -d  $coreutils/libexec/gnubin  ]]; then
    pathprepend $coreutils/libexec/gnubin
    coreutils_installed=true
fi

# COREUTILS vs OSX MANPAGES (default to OSX Man Pahes)
# ====================================================
# some man entries are different, for example osx vs gnu 'ls'.
# I still use osx 'ls' so I need the osx man pages.
if [[ $coreutils && -d $coreutils/libexec/gnuman ]]; then
    MANPATH="$coreutils/libexec/gnuman:$MANPATH"
    # If I uncomment this export then the manpages comes from gnu coreutils instead of mac man
    # export MANPATH
fi


# RBENV PATH
# ===========================
# for switching ruby versions
export RBENV_ROOT="$HOME/.rbenv"
if [ -d $RBENV_ROOT/shims ]; then
    eval "$(rbenv init -)"  # PATH prepend
fi


# PYENV PATH
# =============================
# for switching python versions
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d $PYENV_ROOT/shims ]; then
    # export PYENV_VERSION='2.7.6'      # no needed, the global version is already set during installation
    eval "$(pyenv init -)"              # manipulates PATH, enable shims and autocompletion
    export PYVER_ROOT=`pyenv prefix`    # Custom var: it is the root for the global version
    export PYVER_BIN="$PYVER_ROOT/bin"  # Custom var: the executable path for our global version
fi


# NVM PATH
# ===========================
# for switching node versions
export NVM_DIR="$HOME/.nvm"
if [ -f $NVM_DIR/nvm.sh ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
fi

# ~/bin PATH
# =============================
# Local bin in my home (scripts various stuff)
pathappend ~/bin


# Heroku Toolbelt
# =================
if [[ -d /usr/local/heroku/bin ]]; then
    pathappend /usr/local/heroku/bin
fi


# MYSQL
# =================
# if installed with DMG
if [ -d /usr/local/opt/mysql/lib ]; then
    pathappend /usr/local/opt/mysql/bin
# if installed with brew
elif [ -d /usr/local/mysql/bin ]; then
    pathappend $pfx/mysql/bin
fi

export PATH

#  =============================
#  = ********* /PATH ********* =
#  =============================



#  =============================
#  = ********* ALIAS ********* =
#  =============================

# use the standard APPLE ls and chmod
# because coreutils version can't handle attributes and ACL
if $coreutils_installed; then
   alias ls=/bin/ls
   alias chmod=/bin/chmod
fi


# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then
    if  $coreutils_installed; then
        # GNU `ls`
        alias ls='$coreutils/libexec/gnubin/ls --color=always'
    else
        # for linux installation
        alias ls='ls --color=always'
    fi
    # load my color scheme, 'dircolors' only works with gnu 'ls'
    eval `dircolors  ~/.dotfiles/data/dircolors`
else
    # OS X `ls`
    alias ls='/bin/ls -G'
fi


# PRETTY GIT DIFF
# =================
# @TODO: to finiSH
if [[ $brew && -f  $pfx/opt/git/share/git-core/contrib/diff-highlight/diff-highlight  ]]; then
    ln -sf "$pfx/opt/git/share/git-core/contrib/diff-highlight/diff-highlight" ~/bin/diff-highlight
fi

#  ==============================
#  = ********* /ALIAS ********* =
#  ==============================


#  ================================
#  = ********* SOURCING ********* =
#  ================================

# VIRTUALENVWRAPPER
# ======================
# this needs to come before bash_functions
export WORKON_HOME="$HOME/.virtualenvs"

# pyenv version
if [[ -f $PYVER_BIN/virtualenvwrapper.sh ]]; then
    source $PYVER_BIN/virtualenvwrapper.sh
# brew version
elif [[ $brew && -f $pfx/bin/virtualenvwrapper.sh ]]; then
    source $pfx/bin/virtualenvwrapper.sh
# linux varsion (installed globally with pip)
elif [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
# no available
else
    echo "Virtualenvwrapper is not available!"
fi


# BASH_ALIASES
# ============
source ~/.dotfiles/.bash_aliases


# BASH FUNCTIONS
# ==============
source ~/.dotfiles/.bash_functions


# BASH EXTRA (not using it)
# =========================
# ~/.bash_extra used for settings I don't want to commit.
# It will be copied in home and the modifications there won't be committed
bash_extra=~/.bash_extra
[ -r "$bash_extra" ] && [ -f "$bash_extra" ] && source "$bash_extra"


# MYSQL-COLORIZE
# ==============
# Not so important, commented for now.
# Important: use gnu-sed: brew install gnu-sed
# source ~/.dotfiles/mysql-colorize.bash/mysql-colorize.bash

# to know how many colors are supported by the terminal (it is based on the terminfo database):
# if [ $(tput colors) -ge 256 ] ; then
# PS1="your 256 color prompt"
# else
# PS1="your default prompt"
# fi

#  =================================
#  = ********* /SOURCING ********* =
#  =================================



#  ==============================
#  = ********* PROMPT ********* =
#  ==============================

# BASHMARKS
# ==============
# http://bilalh.github.com/2012/01/14/enchanted-bashmarks-terminal-directory-bookmarks/
# https://github.com/LeonardoGentile/bashmarks
source ~/.dotfiles/bashmarks/bashmarks.sh

# RUPA Z
# ==============
# if command -v brew >/dev/null 2>&1; then
# Load rupa's z if installed
if [[ -f ~/.dotfiles/z/z.sh ]]; then
    source ~/.dotfiles/z/z.sh
elif  [[ $brew && -f $pfx/etc/profile.d/z.sh ]]; then
    source $pfx/etc/profile.d/z.sh
else
    echo "z is not available!"
fi

# POWERLINE SHELL (FANCY PROMPT)
# ===============================
if $linux ; then
    pw_options="--cwd-mode fancy --cwd-max-depth 3 --cwd-max-dir-size 25 --mode patched --colorize-hostname"
elif $mac ; then
    pw_options="--cwd-mode fancy --cwd-max-depth 3 --cwd-max-dir-size 25 --mode patched --colorize-hostname"
fi

function _update_ps1() {
   export PS1="$(~/.dotfiles/powerline-shell/powerline-shell.py $? $pw_options  2> /dev/null)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# Alternative Prompts:

# 1) bash-powerline
# source ~/.dotfiles/bash-powerline/bash-powerline.sh # @TOFIX

# 2) Manual
# function color_my_prompt {
#     local __user_and_host="\[\033[01;32m\]\u@\h"
#     local __cur_location="\[\033[01;34m\]\w"
#     local __git_branch_color="\[\033[31m\]"
#     local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
#     local __prompt_tail="\[\033[35m\]$"
#     local __last_color="\[\033[00m\]"
#     export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
# }
# color_my_prompt

# 3) promptastic (don't user install.py, just uncomment the lines below)
# function _update_ps1() { export PS1="$(~/.dotfiles/promptastic/promptastic.py $?)"; }
# export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"

#  ===============================
#  = ********* /PROMPT ********* =
#  ===============================



#  ===================================
#  = ********* COMPLETIONS ********* =
#  ===================================
# Autocompletion for SUDO (most probably NOT neeeded)
# if [ "$PS1" ]; then
#     complete -cf sudo
# fi


# PYTHON STARTUP
# ================
# Completion for python command line and Custom hystory file
export PYTHONSTARTUP=~/.dotfiles/.pystartup.py

# BASH COMPLETION
# ================
# If possible add tab completion for many more commands
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
# Or if Installed with Brew
elif [ -f $pfx/etc/bash_completion ]; then
    source $pfx/etc/bash_completion
fi

# RBENV COMPLETION
# ================
# If possible add tab completion for many more commands
if [ -f $RBENV_ROOT/completions/rbenv.bash ]; then
    source $RBENV_ROOT/completions/rbenv.bash
fi

# NVM COMPLETION
# ================
# If possible add tab completion for many more commands
if [ -f $NVM_DIR/bash_completion ]; then
    source $NVM_DIR/bash_completion
fi

# NPM TAB COMPLETION
# ================
# if npm -v >/dev/null 2>&1; then
#     .  <(npm completion)
# fi
#
# Or simply (with brew was this, to check):
# npm completion > /usr/local/etc/bash_completion.d/npm

# GRUNT COMPLETION
# ===========================
if [[ $grunt ]]; then
    eval "$(grunt --completion=bash)"
fi

# PIP COMPLETION
# ===========================
if [ -f ~/.dotfiles/completions/bash_pip_completion ]; then
    source ~/.dotfiles/completions/bash_pip_completion
fi

# DJANGO COMPLETION
# ===========================
if [ -f ~/.dotfiles/completions/bash_django_completion ]; then
    source ~/.dotfiles/completions/bash_django_completion
fi

# FAB COMPLETION
# ===========================
if [ -f ~/.dotfiles/completions/bash_fab_completion ]; then
    source ~/.dotfiles/completions/bash_fab_completion
fi

# SSH HOSTNAMES COMPLETION
# ===========================
# ssh hostnames tab completion based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# KILLALL COMPLETION
# ===========================
# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter Chrome" killall

# CYCLIC TAB-COMPLETION (meh)
# ===========================
# bind '"\t":menu-complete'

#  ====================================
#  = ********* /COMPLETIONS ********* =
#  ====================================


#  ======================================
#  = ********* MISC & EXPORTS ********* =
#  ======================================

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Autocorrect typos in path names when using `cd`
# shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Make vim the default editor
export EDITOR="vim"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"


# COLORIZED GREP
# ===========================
# Sometimes could break with git completion
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# Specify the TERM variable. Otherwise it will throw an error when running scripts in non-interactive mode
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

# MAN COLORS
# ===========================
# Less Colors for Man Pages
#
# A SSH command line that specifies a remote command will normally run in "non-interactive mode". One of the consequences is that no pseudo-TTY will be assigned for the connection in the remote host.
# This happens because /etc/profile, ~/.profile or some other login script on those nodes contains a tput command that is executed unconditionally - even if the session does not have a TTY
# associated with it. (The HP-UX default login scripts have had this issue for ages.)
# The true fix would be to find the tput commands on those nodes and make them conditional. For example, on sh, ksh, bash and other Bourne-style shells, you could replace the command:
# (tput) with (tty -s && tput)
# This will run the tput command only if the session is interactive and has a TTY assigned. ("tput" is a terminal initialization/configuration command, so running it when there is no TTY makes no sense anyway.)
if tput setaf 1 &> /dev/null; then
    export LESS_TERMCAP_mb=$(tty -s && tput bold; tty -s && tput setaf 2) # green
    export LESS_TERMCAP_md=$(tty -s && tput bold; tty -s && tput setaf 6) # cyan
    export LESS_TERMCAP_me=$(tty -s && tput sgr0)
    export LESS_TERMCAP_so=$(tty -s && tput bold; tty -s && tput setaf 3; tput setab 4) # yellow on blue
    export LESS_TERMCAP_se=$(tty -s && tput rmso; tty -s && tput sgr0)
    export LESS_TERMCAP_us=$(tty -s && tput smul; tty -s && tput bold; tput setaf 7) # white
    export LESS_TERMCAP_ue=$(tty -s && tput rmul; tty -s && tput sgr0)
    export LESS_TERMCAP_mr=$(tty -s && tput rev)
    export LESS_TERMCAP_mh=$(tty -s && tput dim)
    export LESS_TERMCAP_ZN=$(tty -s && tput ssubm)
    export LESS_TERMCAP_ZV=$(tty -s && tput rsubm)
    export LESS_TERMCAP_ZO=$(tty -s && tput ssupm)
    export LESS_TERMCAP_ZW=$(tty -s && tput rsupm)
fi

# For vi use of pagination in manpages
# export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu' -c 'nnoremap i <nop>' -c 'nnoremap <Space> <C-f>' -"

# using less for manpages.
# This will highlight the search result one at time
export MANPAGER="less -isg"


# BASH HISTORY
# ===========================
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# Larger bash history (default is 500)
export HISTSIZE=1000
export HISTFILESIZE=2000

# Don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth
# ignore only duplicates
# export HISTCONTROL=ignoredups

# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"


# HOMEBREW CASK
# ===========================
if [[ $brew ]]; then
    # Link Homebrew casks in `/Applications` rather than `~/Applications`
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi


# LOCALE
# ===========================
# https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/setlocale.3.html
export LANG="en_US"
export LC_ALL="en_US.UTF-8"

#  =======================================
#  = ********* /MISC & EXPORTS ********* =
#  =======================================


#  ===========================
#  = ********* DEV ********* =
#  ===========================

# FIX MySQLdb ERROR (Still needed?)
# ==================================
# Fix problem when importing mysql-python (MySQLdb)
# http://stackoverflow.com/questions/4559699/python-mysqldb-and-library-not-loaded-libmysqlclient-16-dylib

# if [ -d /usr/local/opt/mysql/lib ]; then
#     export DYLD_LIBRARY_PATH=/usr/local/opt/mysql/lib:$DYLD_LIBRARY_PATH
# elif [ -d /usr/local/mysql/lib ]; then
#     export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH
# fi


# SET COMPILER VERSION
# ===========================
# export CC="gcc-4.0"
# export CXX="g++-4.0"

# FIX RANDOM COMPILATION ERROR
# ===========================
# Because sometimes it doesn't
# find the libs that are actually
# here (e.g: crt1.10.6.o)
# export MACOSX_DEPLOYMENT_TARGET=10.6

# To Solve I problem I DON'T REMEMBER!
# ===========================
# export C_INCLUDE_PATH=$C_INCLUDE_PATH:/Developer/SDKs/MacOSX10.6.sdk/usr/include:/usr/local/include

# HEADERS (I guess)
# ===========================
# I added the headers from brew (/usr/local/include)
# export LIBRARY_PATH=$LIBRARY_PATH:/Developer/SDKs/MacOSX10.6.sdk/usr/lib:/usr/local/lib/

#  ============================
#  = ********* /DEV ********* =
#  ============================


# Dotfiles inspired by many people:
#   https://github.com/javierjulio/dotfiles
#   https://github.com/kevinrenskers/dotfiles
#   https://github.com/paulirish/dotfiles
#   https://github.com/mathiasbynens/dotfiles/
#   Others I don't rememeber


#  ======================================
#  = PROFILING STARTUP TIME (for debug) =
#  ======================================
# Uncomment this block and the block at the beginning of the file to have debug info on this file

# if $PROFILE_STARTUP; then
#     set +x # The dash is used to activate a shell option and a plus to deactivate it.
#     exec 2>&3 3>&-
# fi

