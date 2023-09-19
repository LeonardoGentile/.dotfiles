#!/usr/bin/env bash

#  ======================================
#  = PROFILING STARTUP TIME (for debug) =
#  ======================================
DEBUG=false
if $DEBUG; then
    PS4='+ $(gdate "+%s.%N")\011 '
    exec 3>&2 2>/tmp/bashstart.$$.log
    # It prints command traces before executing command.
    # The dash is used to activate a shell option and a plus to deactivate it.
    set -x  # shortcut for 'set -o xtrace'.
fi


# SETTINGS
# =====================
ACTIVATE_BREW=true
ACTIVATE_RBENV=false
ACTIVATE_COREUTILS=true
ACTIVATE_BINUTILS=true
ACTIVATE_PYENV=true
ACTIVATE_NVM=true
ACTIVATE_VIRTUALENVWRAPPER=true
ACTIVATE_BASH_FNS=true
ACTIVATE_ITERM_INTEGRATION=false

#  ============================
#  = ********* INIT ********* =
#  ============================
# get info from uname and convert to lowercase
OS="$(echo $(uname -s) | tr '[:upper:]' '[:lower:]')"  # or OS=$OSTYPE
case $OS in
    Darwin*|darwin)
        mac=true
        linux=false
        export BASH_SILENCE_DEPRECATION_WARNING=1
        case "$(uname -m)" in
            x86_64) brew_default_dir=/usr/local;; # Intel binaries
            arm64) brew_default_dir=/opt/homebrew;;  # ARM
        esac

        # COMPILATION STUFF (Set architecture flags)
        # Intel -> x86_64
        # For M1 -> arm64"
        export ARCHFLAGS="-arch $(uname -m)"
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



#  ============================
#  = ********* PATH ********* =
#  ============================

# Loading sequence:
#   1     /etc/paths
#   2     /etc/paths.d/whatever (e.g. x11, 40-XQuarts)
#   3     PATH defined in this file

# For loading HOMEBREW binaries first you might change the /etc/paths file
# putting /usr/local/bin at the beginning of the file instead of the end
# Even if we do it here sometimes could be 'too late'


# Helper Path Functions
# ---------------------
# USAGE: pathprepend /usr/local/bin /usr/local/sbin
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


# BREW PATH
# ============
# Flags for brew and coreutils

# UNREALIABLE, not yet sourced!
# brew_installed=$(command -v brew &> /dev/null && echo "true" || echo "false")

brew_installed="false"
coreutils_dir=""
if [[ $brew_installed && $mac == "true" && $ACTIVATE_BREW == "true" ]]; then
    # Cached vars
    brew_installed="true"
    pathprepend $brew_default_dir/bin $brew_default_dir/sbin
    coreutils_dir=$(brew --prefix coreutils)
    # brew bins should have priority
    HOMEBREW_PREFIX=$(brew --prefix)
fi


# (GNU) COREUTILS PATH
# ===========================
# Commands also provided by macOS and the commands dir, dircolors, vdir have been installed with the prefix "g".
# If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with.
#
# NOTE: I use the GNU ls (gls) included in COREUTILS because it lets me use dircolors command, that will use
# .dircolors file to colorize gls:
#   http://lostincode.net/posts/homebrew
#   http://www.conrad.id.au/2013/07/making-mac-os-x-usable-part-1-terminal.html
#   https://github.com/seebi/dircolors-solarized
GNU_BIN=$coreutils/libexec/gnubin
if [[ $ACTIVATE_COREUTILS == "true" && -d $coreutils_dir && -d $GNU_BIN ]]; then
    pathprepend $GNU_BIN
    # Flag to check if we are using coreutils GNU ls or Apple ls
    coreutils_installed=true
fi

# COREUTILS vs OSX MANPAGES (default to OSX Man Pages)
# ====================================================
# some man entries are different, for example osx vs gnu 'ls'.
# I still use osx 'ls' so I need the osx man pages.
GNU_MANPATH=$coreutils_dir/libexec/gnuman
if [[ $coreutils_installed == "true" && -d $GNU_MANPATH ]]; then
    MANPATH="$GNU_MANPATH:$MANPATH"
    # If I uncomment this export then the manpages comes from gnu coreutils instead of mac man
    # export MANPATH
fi


# RBENV PATH
# ===========================
# for switching ruby versions
export RBENV_ROOT="$HOME/.rbenv"
if [[ $ACTIVATE_RBENV == "true" && -d $RBENV_ROOT/shims ]]; then
    eval "$(rbenv init --no-rehash -)"      # PATH prepend
fi


# PYENV PATH
# =============================
# for switching python versions
export PYENV_ROOT="$HOME/.pyenv"
if [[ $ACTIVATE_PYENV == "true" && -d $PYENV_ROOT/shims ]]; then
    eval "$(pyenv init --no-rehash -)"              # manipulates PATH, enable shims and autocompletion
    PYENV_DEFAULT_BIN="$(pyenv prefix)/bin"         # my custom var: the executable path for my default global py version
fi


# Poetry PATH
# ==============================
# For Completion see below
POETRY_ROOT=""
POETRY_ROOT_OLD="$HOME/.local/bin"
POETRY_ROOT_NEW="$HOME/.poetry/bin"
if [[ -d $POETRY_ROOT_OLD ]]; then
    POETRY_ROOT=$POETRY_ROOT_OLD
elif [[ -d $POETRY_ROOT_NEW ]]; then
    POETRY_ROOT=$POETRY_ROOT_NEW
fi

if [[ -d $POETRY_ROOT ]]; then
    pathappend $POETRY_ROOT
fi



# NVM PATH
# ===========================
# For switching node versions
export NVM_DIR="$HOME/.nvm"
if [[ $ACTIVATE_NVM == "true" && -f $NVM_DIR/nvm.sh ]]; then
    # Lazy loading bash completions does not save meaningful shell startup time, so I won't do it
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # Find which nvm node is the default
    export DEFAULT_NODE_VER='default';
    while [ -s "$NVM_DIR/alias/$DEFAULT_NODE_VER" ]; do
        DEFAULT_NODE_VER="$(<$NVM_DIR/alias/$DEFAULT_NODE_VER)"
    done;

    # Add my default nvm node to path without loading nvm
    pathprepend "$NVM_DIR/versions/node/v${DEFAULT_NODE_VER#v}/bin"

    # Lazy-loads nvm the first time we call it
    # NVM is very slow to load so I had to use a trick to lazy load it:
    # https://gist.github.com/gfguthrie/9f9e3908745694c81330c01111a9d642
    alias nvm='unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use; nvm'
fi

# =======
# FLAGS
# =======
# Overloaded below
# https://unix.stackexchange.com/a/682930/89430
export LDFLAGS=""
export CPPFLAGS=""
# PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/other/directory
export PKG_CONFIG_PATH=""

# cURL PATH
# =============
# By default brew cUrl is not linked:
pathprepend "$HOMEBREW_PREFIX/opt/curl/bin"

# FLAGS: For compilers to find curl you may need to set:
LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/opt/curl/lib"
CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/curl/include"

# For pkg-config to find curl you may need to set:
PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/curl/lib/pkgconfig"


# OpenSSL PATH
# =============
# By default brew openssl is not linked

# Openssl@1.1
# ------------
pathprepend "$HOMEBREW_PREFIX/opt/openssl@1.1/bin"
# FLAGS: for mysql and other packages to be properly installed
LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/opt/openssl@1.1/lib"
CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/openssl@1.1/include"
PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/openssl@1.1/lib/pkgconfig"

# Openssl@3
# ----------
# pathprepend "$HOMEBREW_PREFIX/opt/openssl@3/bin"
# FLAGS: for mysql and other packages to be properly installed
# LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
# CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
# PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/openssl@3/lib/pkgconfig"


# BINUTILS PATH
# ==============
# binutils is keg-only, which means it was not symlinked into /opt/homebrew,
# because Apple's CLT provides the same tools.
BINUTILS=$HOMEBREW_PREFIX/opt/binutils/bin
if [[ $ACTIVATE_BINUTILS == "true" && -d $BINUTILS ]]; then
    pathprepend $BINUTILS
    LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/opt/binutils/lib"
    CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/opt/binutils/include"
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
elif [[ -d $HOMEBREW_PREFIX/mysql/bin && $mac == "true" ]]; then
    pathappend $HOMEBREW_PREFIX/mysql/bin
fi


# ANDROID_HOME
# =================
export ANDROID_HOME=$HOME/Library/Android/sdk
if [ -d $ANDROID_HOME ]; then
    pathappend $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools
fi

# JAVA_HOME
# =================
# version=1.8
# export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
# pathappend $JAVA_HOME $JAVA_HOME/bin


# ANACONDA PATH
# =============================
# for anaconda py distribution (installed via homebrew)
CONDA_ROOT=$HOMEBREW_PREFIX/anaconda3
if [[ -d $CONDA_ROOT ]]; then
    # Disable conda to auto-replace my other python versions
    export CONDA_AUTO_ACTIVATE_BASE=false

    # Alternative to bash_completion (see below)
    # eval "$(register-python-argcomplete conda)"

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('$CONDA_ROOT/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
            . "$CONDA_ROOT/etc/profile.d/conda.sh"
        else
            export PATH="$CONDA_ROOT/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
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
if [[ $coreutils_installed == "true" ]]; then
   alias ls=/bin/ls
   alias chmod=/bin/chmod
fi


# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then
    if [[ $coreutils_installed == "true" ]]; then
        # GNU `ls`
        alias ls='$coreutils/libexec/gnubin/ls --color=always'
        # load my color scheme, 'dircolors' only works with gnu 'ls'
        eval `dircolors  ~/.dotfiles/data/dircolors`
    else
        # for linux installation
        alias ls='ls --color=always'
    fi
else
    # OS X `ls`
    alias ls='/bin/ls -G'
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
if [[ $ACTIVATE_VIRTUALENVWRAPPER == "true" ]]; then
    # pyenv version
    if [[ -f $PYENV_DEFAULT_BIN/virtualenvwrapper_lazy.sh ]]; then
        export VIRTUALENVWRAPPER_SCRIPT=$PYENV_DEFAULT_BIN/virtualenvwrapper.sh
        source $PYENV_DEFAULT_BIN/virtualenvwrapper_lazy.sh
    # brew version
    elif [[ $brew_installed == "true" && -f $HOMEBREW_PREFIX/bin/virtualenvwrapper_lazy.sh ]]; then
        source $HOMEBREW_PREFIX/bin/virtualenvwrapper_lazy.sh
    # linux version (installed globally with pip)
    elif [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
        source /usr/local/bin/virtualenvwrapper.sh
    # This is (why?) the default location in debian
    elif [[ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]]; then
        source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    # no available
    else
        # echo "Virtualenvwrapper is not available!"
        ACTIVATE_VIRTUALENVWRAPPER=false
    fi
fi

# BASH_ALIASES
# ============
source ~/.dotfiles/.bash_aliases


# BASH FUNCTIONS
# ==============
if [[ $ACTIVATE_BASH_FNS == "true" ]]; then
    source ~/.dotfiles/.bash_functions
fi


# BASH LOCAL
# =========================
# ~/.bash_local used for settings I don't want to commit.
# It will be copied in home and the modifications there won't be committed
bash_local=~/.bash_local
[ -r "$bash_local" ] && [ -f "$bash_local" ] && source "$bash_local"


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
elif  [[ $brew_installed == "true" && -f $HOMEBREW_PREFIX/etc/profile.d/z.sh ]]; then
    source $HOMEBREW_PREFIX/etc/profile.d/z.sh
else
    echo "z is not available!"
fi

# POWERLINE SHELL (FANCY PROMPT)
# ===============================
if [[ $linux == "true" ]]; then
    pw_options="--cwd-mode fancy --cwd-max-depth 3 --cwd-max-dir-size 25 --mode patched"
elif [[ $mac == "true" ]]; then
    pw_options="--cwd-mode fancy --cwd-max-depth 3 --cwd-max-dir-size 25 --mode patched --colorize-hostname"
fi

function _update_ps1() {
   export PS1="$(~/.dotfiles/powerline-shell/powerline-shell.py $? $pw_options  2> /dev/null)"
}


if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
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
# Autocompletion for SUDO (most probably NOT needed)
# if [ "$PS1" ]; then
#     complete -cf sudo
# fi


# PYTHON STARTUP
# ================
# Completion for python command line and Custom hystory file
export PYTHONSTARTUP=~/.dotfiles/.pystartup.py


# DOCKER COMPLETION (Not working)
# =================
# Completion for Docker
# etc_docker=/Applications/Docker.app/Contents/Resources/etc
# if [[ $brew_installed == "true" && -d $etc_docker ]]; then
#     ln -sfn $etc_docker/docker $HOMEBREW_PREFIX/etc/bash_completion.d/docker
#     ln -sfn $etc_docker/docker-compose.bash-completion $HOMEBREW_PREFIX/etc/bash_completion.d/docker-compose
#     # source $etc_docker/docker.bash-completion
#     # source $etc_docker/docker-machine.bash-completion
#     # source $etc_docker/docker-compose.bash-completion
# fi


# SOURCE BASH COMPLETION
# ======================
# If possible add tab completion for many more commands
# export BASH_COMPLETION_USER_DIR=~/.dotfiles/bash-completion
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
elif [[ $brew_installed == "true" ]]; then
    # BREW bash-completion@2 (WARNING: it only works with bash>4!)
    # SLOW: https://discourse.brew.sh/t/bash-completion-is-slow-for-brew-commands/4761
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "$COMPLETION" ]] && source "$COMPLETION"
        done
    fi
fi

# POETRY COMPLETION
# =================
# Or manually install them into brew dir:
# `poetry completions bash > $HOMEBREW_PREFIX/etc/bash_completion.d/poetry`
# https://python-poetry.org/docs/#enable-tab-completion-for-bash-fish-or-zsh
# https://github.com/python-poetry/poetry/issues/2295
# Automatic solution:
# TODO: broken, wait for fix:
# https://github.com/python-poetry/poetry/issues/6384
# https://github.com/python-poetry/cleo/pull/247
# if command -v poetry &> /dev/null
# then
#     source <(poetry completions bash)
# fi


# RBENV COMPLETION
# ================
if [ -f $RBENV_ROOT/completions/rbenv.bash ]; then
    source $RBENV_ROOT/completions/rbenv.bash
fi

# NVM COMPLETION
# ================
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
# if [[ $grunt ]]; then
#     eval "$(grunt --completion=bash)"
# fi

# PIP COMPLETION
# ===========================
# if [ -f ~/.dotfiles/completions/bash_pip_completion ]; then
#     source ~/.dotfiles/completions/bash_pip_completion
# fi

# DJANGO COMPLETION
# ===========================
if [ -f ~/.dotfiles/completions/bash_django_completion ]; then
    source ~/.dotfiles/completions/bash_django_completion
fi

# FAB COMPLETION
# ===========================
# if [ -f ~/.dotfiles/completions/bash_fab_completion ]; then
#     source ~/.dotfiles/completions/bash_fab_completion
# fi

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
# By default if you type:
# shopt     # (without argument show status of all shell options)
#    -u     # short for unset
#    -s     # short for set

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# for considering dot files (turn on dot files)
shopt -s dotglob # cp or mv will work with dotfiles

# for don't considering dot files (turn off dot files)
# shopt -u dotglob

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
if [[ $brew_installed == "true" ]]; then
    # Link Homebrew casks in `/Applications` rather than `~/Applications`
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi


# # ANSIBLE
# # ===========================
# if [ -f ~/.ansible_hosts ]; then
#     # Custom ansible inventory file
#     export ANSIBLE_HOSTS=~/.ansible_hosts
# fi


# LOCALE
# ===========================
# https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/setlocale.3.html
export LC_ALL="C"
export LANG="en_US.UTF-8"
export LANGUAGE="en"
export LC_MESSAGES="en_US.UTF-8"

# EXAMPLES:
# LANG="fr_FR.UTF-8"
# LC_COLLATE="fr_FR.UTF-8"
# LC_CTYPE="fr_FR.UTF-8"
# LC_MESSAGES="fr_FR.UTF-8"
# LC_MONETARY="fr_FR.UTF-8"
# LC_NUMERIC="fr_FR.UTF-8"
# LC_TIME="fr_FR.UTF-8"
# LC_ALL=

#  =======================================
#  = ********* /MISC & EXPORTS ********* =
#  =======================================


#  ===========================
#  = ********* DEV ********* =
#  ===========================


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


# HEADERS (I guess)
# ===========================
# I added the headers from brew (/usr/local/include)
# export LIBRARY_PATH=$LIBRARY_PATH:/Developer/SDKs/MacOSX10.6.sdk/usr/lib:/usr/local/lib/

#  ============================
#  = ********* /DEV ********* =
#  ============================

#  ============================
#  = ********* iTERM2 ******* =
#  ============================
if [[ $ACTIVATE_ITERM_INTEGRATION == "true" ]]; then
    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi


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

if $DEBUG; then
    set +x # The dash is used to activate a shell option and a plus to deactivate it.
    exec 2>&3 3>&-
fi

