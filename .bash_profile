#!/usr/bin/env bash

# VIRTUALENVWRAPPER (should go before bash_functions)
# =============================================
# Check the workon_cwd function in bash_prompt or
# the .virtualenv/postactivate file to customize the
# shell prompt after the virtualenv activation
export WORKON_HOME="$HOME/.virtualenvs"
source /Library/Frameworks/Python.framework/Versions/2.7/bin/virtualenvwrapper.sh


# BASH_ALIASES
# =============================================
source ~/.dotfiles/bash/bash_aliases

# BASH FUNCTIONS
# =============================================
source ~/.dotfiles/bash/bash_functions

# BASH PROMPT CUSTOMIZATION
# =============================================
# source ~/.dotfiles/bash/bash_prompt

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
source ~/.dotfiles/bash/bash_export

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



# Uses gls instead of ls
alias ls='gls --color=always'
# load my color scheme
eval `gdircolors  ~/.dotfiles/data/dircolors`


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
_pip_completion(){
    COMPREPLY=(
        $(  COMP_WORDS="${COMP_WORDS[*]}" \
            COMP_CWORD=$COMP_CWORD \
            PIP_AUTO_COMPLETE=1 $1 )
    )
}
complete -o default -F _pip_completion pip


# GRUNT COMPLETION (!!! Not working, Experimental)
# ===========================
eval "$(grunt --completion=bash)"


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

# Redis (manually installed)
PATH="$PATH:~/bin/redis"

# gcc and other dev stuff
PATH="${PATH}:/Developer/usr/bin"

# Heroku Toolbelt
PATH="$PATH:/usr/local/heroku/bin"

# PATH for Python 2.7
PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.7/bin"

# MySql
PATH="${PATH}:/usr/local/mysql/bin"

# SenchaSDKTools
PATH="${PATH}:/Applications/Coding/SenchaSDKTools-2.0.0-beta3"
export SENCHA_SDK_TOOLS_2_0_0_BETA3="/Applications/Coding/SenchaSDKTools-2.0.0-beta3"

export PATH

# Old content of .MacOSX/environment.plist (I don't use it)
# PATH="${PATH}:/usr/X11/bin::~/bin"



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


# Dotfiles inspired by many people
# Inspired by https://github.com/javierjulio/dotfiles
