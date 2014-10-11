#!/usr/bin/env bash

# Compialtion stuff (Set architecture flags)
export ARCHFLAGS="-arch x86_64"

# =============================================
# PATHS
# =============================================
# Loading sequence:
#   1     /etc/paths
#   2     /etc/paths./whatever (e.g. x11)
#   3     ~/.MacOSX/environment.plist (AVOID!)
#   4     PATH defined in this file
#
#   BEWARE: Avoid (3) cause it overrides the default PATH set in /etc/paths and it is deprecated

# For loading HOMEBREW binaries first change the /etc/paths file
# putting /usr/local/bin at the beginning of the file instead of the end
# Even if we do it here it will be 'too late'

PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# rbenv for switching ruby versions
export RBENV_ROOT="$HOME/.rbenv"

if [ -d $RBENV_ROOT ]; then
    PATH="$RBENV_ROOT/shims:$PATH"
    eval "$(rbenv init -)"
fi

# COREUTILS (GNU)
# ===========================
# I use the GNU ls (gls) included in COREUTILS (downloaded with BREW)
# This let me use dircolors command, that will use .dircolors file to colorize gls
# http://lostincode.net/posts/homebrew
# http://www.conrad.id.au/2013/07/making-mac-os-x-usable-part-1-terminal.html
# https://github.com/seebi/dircolors-solarized

if [  -d /usr/local/opt/coreutils/libexec/gnubin  ]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

if [ -d /usr/local/opt/coreutils/libexec/gnuman ]; then
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

#TODO: better this way: $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

# Local bin in my home (scripts various stuff)
PATH="$PATH:~/bin"

# Heroku Toolbelt
if [[ -d /usr/local/heroku/bin ]]; then
    PATH="$PATH:/usr/local/heroku/bin"
fi

# MySql bin
if [ -d /usr/local/opt/mysql/lib ]; then
    PATH="${PATH}:/usr/local/opt/mysql/bin"
elif [ -d /usr/local/mysql/bin ]; then
    PATH="${PATH}:/usr/local/mysql/bin"
fi

# SenchaSDKTools
if [[ -d /Applications/SenchaSDKTools ]]; then
    PATH="${PATH}:/Applications/SenchaSDKTools"
    export SENCHA_SDK_TOOLS_2_0_0_BETA3="/Applications/SenchaSDKTools"
fi

# Redis (manually installed)
# PATH="$PATH:~/bin/redis"

# gcc and other dev stuff
# PATH="${PATH}:/Developer/usr/bin"
# PATH="${PATH}:/Developer/usr/bin"

# PATH for Python 2.7
# PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.7/bin"
#
# PATH="${PATH}:/usr/local/share/python"
# No needed with python installed from brew

export PATH


# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    alias ls='ls --color=always'
    # load my color scheme (it only works with GNU ls)
    # dircolors only work with coreutils
    eval `dircolors  ~/.dotfiles/data/dircolors`
else # OS X `ls`
    alias ls='ls -G'
fi



# VIRTUALENVWRAPPER (should go before bash_functions)
# =============================================
# Check the workon_cwd function in bash_prompt or the .virtualenv/postactivate file
# to customize the shell prompt after the virtualenv activation
export WORKON_HOME="$HOME/.virtualenvs"
if [[ -f /Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh ]]; then
    source /Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh
elif [ -f $(brew --prefix)/bin/virtualenvwrapper.sh ]; then
    source $(brew --prefix)/bin/virtualenvwrapper.sh
fi


# BASH_ALIASES
# =============================================
source ~/.dotfiles/.bash_aliases


# BASH FUNCTIONS
# =============================================
source ~/.dotfiles/.bash_functions


# EXTRA (settings I don't want to commit)
# =============================================
# ~/.bash_extra used for settings I don't want to commit.
# It will be copied in home and the modification there won't be committed
bash_extra=~/.bash_extra
[ -r "$bash_extra" ] && [ -f "$bash_extra" ] && source "$bash_extra"


# BASHMARKS
# =============================================
# http://bilalh.github.com/2012/01/14/enchanted-bashmarks-terminal-directory-bookmarks/
source ~/.dotfiles/bashmarks/bashmarks.sh


# RUPA Z
# =============================================
if command -v brew >/dev/null 2>&1; then
    # Load rupa's z if installed
    [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi


# PYTHON STARTUP
# =============================================
# Completion for python command line (commented out right now)
# Custom hystory file
export PYTHONSTARTUP=~/.dotfiles/.pystartup.py



# BASH PROMPT (powerline shell)
# =============================================

function _update_ps1() {
   export PS1="$(~/.dotfiles/powerline-shell/powerline-shell.py $? --cwd-max-depth 3 --colorize-hostname  2> /dev/null)"
}
export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"


# to know how many colors are supported by the terminal (it is based on the terminfo database):
# if [ $(tput colors) -ge 256 ] ; then
# PS1="your 256 color prompt"
# else
# PS1="your default prompt"
# fi

# source utils/bash-powerline.sh


# =============================================
# COMPLETIONS
# =============================================

# SOURCE BASH COMPLETION
# =============================================
# If possible, add tab completion for many more commands
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
# Or if Installed with Brew
elif [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi


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
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall


# CYCLIC TAB-COMPLETION
# ===========================
# bind '"\t":menu-complete'


# =============================================
# MISC & EXPORTS
# =============================================

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

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


# COLORIZED GREP (could break things with git completion)
# ===========================
alias grep="grep --color=always"
alias egrep="egrep --color=always"
alias egrep="fgrep --color=always"

# # Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# Specify the TERM variable. Otherwise it will throw an error when running scripts in non-interactive mode
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi


# MAN COLORS (Less Colors for Man Pages)
# ===========================
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



# BASH HISTORY
# ===========================
# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"


# HOMEBREW
# ===========================
# Link Homebrew casks in `/Applications` rather than `~/Applications`
export HOMEBREW_CASK_OPTS="--appdir=/Applications"


# =============================================
# LOCALE
# =============================================
# https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/setlocale.3.html
export LANG="en_US"
export LC_ALL="en_US.UTF-8"


# =============================================
# DEV
# =============================================

# FIX MySQLdb ERROR
# ===========================
# Fix problem when importing
# mysql-python (MySQLdb)
# http://stackoverflow.com/questions/4559699/python-mysqldb-and-library-not-loaded-libmysqlclient-16-dylib
if [ -d /usr/local/opt/mysql/lib ]; then
    export DYLD_LIBRARY_PATH=/usr/local/opt/mysql/lib:$DYLD_LIBRARY_PATH
elif [ -d /usr/local/mysql/lib ]; then
    export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH
fi




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



# Dotfiles inspired by many people
# https://github.com/javierjulio/dotfiles
# https://github.com/kevinrenskers/dotfiles
# https://github.com/paulirish/dotfiles
# https://github.com/mathiasbynens/dotfiles/

