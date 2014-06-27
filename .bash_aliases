# ========================================
# Directory Navigation
# ========================================

# lists all defined aliases
alias aa='compgen -a'
alias c='clear'
alias q='exit'

alias ll="ls -l"
alias la="ls -al"
alias lp="ls -p"
alias l1='ls -1'

alias h="cd ~"
alias dotfiles="cd ~/.dotfiles"

# Directory
alias md="mkdir"
alias rd='rmdir'

# Go Up
alias cd..="cd .."
alias ..='cd ..'         # Go up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -="cd -"        # Go back

alias hy=history

# sudo enviroment
alias sudo='A=`alias` sudo env '

# the "kp" alias ("que pasa"), in honor of tony p.
alias kp="ps auxwww"

# Screen saver
alias ss="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background &"

# Django Stuff
# ============
alias run="python manage.py runserver"
# shell_plus with python command history support
alias shell_plus="python manage.py shell_plus --use-pythonrc"

# TERMRC: https://github.com/briangonzalez/termrc
# ============
alias start="termrc start"


# Redis
# ============
alias rs="redis-server ~/.redis/redis.conf"


# MySql Start & Stop
alias mysql_start="sudo /Library/StartupItems/MySQLCOM/MySQLCOM start"
alias mysql_stop="sudo /Library/StartupItems/MySQLCOM/MySQLCOM stop"

# Apache, Servers & php
alias lh=localhost # it launchs the localhost function that I've defined


# Net ip
alias localip="ipconfig getifaddr en1"
alias remoteip="curl -s http://checkip.dyndns.com/ | sed 's/[^0-9\.]//g'"

# pretty print all paths
alias path='echo -e ${PATH//:/\\n}'

# Alias for bashmarks
# alias k='g'

if [ $(uname) = "Linux" ]
then
  alias ls="ls --color=auto"
fi

# Archery, gives info about this mac
# ============
alias mac="archey"


# ========================================
# File Management
# ========================================

# Delete *.DS_Store files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

alias emptytrash="sudo rm -rfv ~/.Trash;"

# Clear Apple’s System Logs to improve shell startup speed
alias emptylogs="sudo rm -rfv /private/var/log/asl/*.asl"

# Empty the Trash on all mounted volumes and the main HDD and Apple’s System Logs
alias emptyalltrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# http://blogs.adobe.com/cantrell/archives/2012/03/stop-using-rm-on-the-command-line-before-its-too-late.html
# alias rm="echo 'Use trash instead: trash my-file.txt'"


# ========================================
# Git
# ========================================

# alias gi='git'
# __git_complete gi __git_main
alias gb='git branch'
alias gci='git commit -m'
alias gco='git checkout'
alias gfo='git fetch origin'
alias gp='git push'
alias gr='git rebase'
alias grc='git rebase --continue'
alias gs='git status'
alias guci='git reset --soft HEAD^' # undo last commit
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias log="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias gis="git status -s"

# ========================================
# Heroku
# ========================================

alias hp='heroku ps'
alias hps='heroku ps:scale'

# heroku
alias hk='heroku'
alias hl='heroku list'
alias hi='heroku info'
alias ho='heroku open'

# dynos and workers
alias hd='heroku dynos'
alias hw='heroku workers'

# rake console
alias hr='heroku rake'
alias hcon='heroku console'

# new and restart
alias hnew='heroku create'
alias hrestart='heroku restart'

# logs
alias hlog='heroku logs'
alias hlogs='heroku logs'

# maint
alias hon='heroku maintenance:on'
alias hoff='heroku maintenance:off'

# heroku configs
alias hc='heroku config'
alias hca='heroku config:add'
alias hcr='heroku config:remove'
alias hcc='heroku config:clear'




# ========================================
# Quicklook
# ========================================

# Examples
#
#   ql -p '~/Music/file.mp3'
#   # => The -p option generates a preview, as if you'd tapped the Spacebar in Finder.
#
#   ql -p '~/Music/file.mp3' '~/Documents/Notes.txt'
#   # => You can specify multiple files and the window will allow you to switch between files.
#
#   ql -t '~/Music/file.mp3'
#   # => The -t option generates thumbnails, like in Coverflow or Info For.
#
alias ql='qlmanage -p "$@" >& /dev/null'


# ========================================
# Applications
# ========================================

# Examples
#
#   iawriter ~/Documents/Notes.txt
#

alias iawriter='open -b jp.informationarchitects.WriterForMacOSX'
alias vlc='/Applications/Audio\&Video/VLC.app/Contents/MacOS/VLC -I ncurses'
alias safari="open -a safari"
alias firefox="open -a firefox"
if [ -s /usr/bin/firefox ] ; then
  unalias firefox
fi
alias chrome="open -a google\ chrome"
alias filemerge="open -a '/Applications/Xcode.app/Contents/Applications/FileMerge.app'"

# Pianobar can be found here: http://github.com/PromyLOPh/pianobar/
alias piano='pianobar'


