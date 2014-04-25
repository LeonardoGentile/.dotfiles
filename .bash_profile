#!/usr/bin/env bash


# Compialtion stuff
# Set architecture flags
export ARCHFLAGS="-arch x86_64"

# VIRTUALENVWRAPPER (should go before bash_functions)
# =============================================
# Check the workon_cwd function in bash_prompt or
# the .virtualenv/postactivate file to customize the
# shell prompt after the virtualenv activation
export WORKON_HOME="$HOME/.virtualenvs"
if [[ -f /Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh ]]; then
    source /Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh
elif [ -f $(brew --prefix)/bin/virtualenvwrapper.sh ]; then
    source $(brew --prefix)/bin/virtualenvwrapper.sh
fi

# BASH_ALIASES
# =============================================
source ~/.dotfiles/bash/bash_aliases

# BASH FUNCTIONS
# =============================================
source ~/.dotfiles/bash/bash_functions

# I now use powerline shell
function _update_ps1() {
   export PS1="$(~/.dotfiles/powerline-shell/powerline-shell.py $? --cwd-max-depth 4 --colorize-hostname  2> /dev/null)"
}
export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"


# EXTRA
# =============================================
# ~/.extra can be used for other settings you don't want to commit.
bash_extra=~/.bash_extra
[ -r "$bash_extra" ] && [ -f "$bash_extra" ] && source "$bash_extra"

# BASH ENV VARIABLES EXPORT
# =============================================
# source ~/.dotfiles/bash/bash_export

# BASHMARKS
# =============================================
# http://bilalh.github.com/2012/01/14/enchanted-bashmarks-terminal-directory-bookmarks/
source ~/.dotfiles/bashmarks/bashmarks.sh


# GIT PROMPT (I'm not using it because I'm using a customized function inside bash_prompt)
# =============================================
# if [ -f ~/.dotfiles/scripts/git-prompt.sh ]; then
#     source ~/.dotfiles/scripts/git-prompt.sh
# fi


# NEWTAB (I'm not using it because I need to fix it for iTerm)
# =============================================
# Opens a new tab in the current Terminal window
# and optionally executes a command (To document and fix for iTerm)
# source ~/.dotfiles/scripts/newtab.sh


# PATH TOOLS
# =============================================
# A set of tools for manipulating ":" separated
# lists like the canonical $PATH variable.
source ~/.dotfiles/scripts/path_tools.bash


# PYTHON STARTUP
# =============================================
# Completion for python command line (commented out right now)
# Custom hystory file
export PYTHONSTARTUP=~/.dotfiles/scripts/pystartup.py


# GLS (GNU LS)
# ==============================================
# I use the GNU ls (gls) included in COREUTILS (downloaded with BREW)
# This let me use dircolors command, that will use .dircolors file to colorize gls
#
# http://lostincode.net/posts/homebrew
# http://www.conrad.id.au/2013/07/making-mac-os-x-usable-part-1-terminal.html
# https://github.com/seebi/dircolors-solarized



if [  -d /usr/local/opt/coreutils/libexec/gnubin  ]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

if [ -d /usr/local/opt/coreutils/libexec/gnuman ]; then
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi


# Uses gls instead of ls
alias ls='ls --color=always'
# load my color scheme
eval `dircolors  ~/.dotfiles/data/dircolors`


# BASH COMPLETION
# =============================================
# If possible, add tab completion for many more commands
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
# Installed with Brew
elif [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi


# =============================================
# COMPLETIONS
# =============================================

# PIP COMPLETION
# ===========================
_pip_completion() {
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    commands=$(pip --help | awk '/Commands\:/,/General Options\:/' | \
               \grep -E -o "^\s{2}\w*" | tr -d ' ')
    opts=$(pip --help | \grep -E -o "((-\w{1}|--(\w|-)*=?)){1,2}")


    if [ $COMP_CWORD == 1 ] ; then
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        return 0
    fi

    if [[ ${cur} == -* ]] ; then
        local command_opts=$(pip $prev --help | \
                             \grep -E -o "((-\w{1}|--(\w|-)*=?)){1,2}")
        COMPREPLY=( $(compgen -W "${command_opts}" -- ${cur}) )
        return 0
    fi
}
complete -o default -F _pip_completion pip



# GRUNT COMPLETION 
# ===========================
if [[ $grunt ]]; then
    eval "$(grunt --completion=bash)"    

fi


# DJANGO COMPLETION
# ===========================
if [ -f ~/.dotfiles/bash/bash_django_completion ]; then
    source ~/.dotfiles/bash/bash_django_completion
fi



# CYCLIC TAB-COMPLETION
# ===========================
# bind '"\t":menu-complete'


# =============================================
# PATHS
# =============================================
# Loading sequence:
# 1)    /etc/paths
# 2)    /etc/paths./whatever (e.g. x11)
# 3)    ~/.MacOSX/environment.plist (AVOID!)
# 4)    PATH defined in this file

# BEWARE: Avoid 3) cause it overrides the default PATH set in /etc/paths.

# Local bin in my home (scripts various stuff)
PATH="$PATH:~/bin"

# Heroku Toolbelt
if [[ -d /usr/local/heroku/bin ]]; then
    PATH="$PATH:/usr/local/heroku/bin"
fi

# MySql bin 
PATH="${PATH}:/usr/local/opt/mysql/bin/"

# SenchaSDKTools
PATH="${PATH}:/Applications/SenchaSDKTools"
export SENCHA_SDK_TOOLS_2_0_0_BETA3="/Applications/SenchaSDKTools"
export PATH



# =============================================
# MISC
# =============================================

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
        shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall



# =============================================
# LOCALE
# =============================================
# https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/setlocale.3.html

export LANG="en_US"
export LC_ALL="en_US.UTF-8"


# MAN COLORS (Less Colors for Man Pages)
# ==============================================
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)


# =============================================
# DEV
# =============================================
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/opt/mysql/lib

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






# Dotfiles inspired by many people
# https://github.com/javierjulio/dotfiles
# https://github.com/kevinrenskers/dotfiles
# https://github.com/paulirish/dotfiles
# https://github.com/mathiasbynens/dotfiles/

