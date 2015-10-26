# =================================================
# BASH FUNCTIONS
# =================================================


# OPEN DICTIONARY
# =================================================
function dict () {
  open dict:///"$@";
}


# OPEN IN PATH FINDER
# =================================================
# If no arguments passed opens current directory
# otherwise the specified file
function pf () {
    open -a "Path Finder.app" . $1;
}


# MOVE TO TRASH
# =================================================
# Source (with minor tweaks): http://www.anthonysmith.me.uk/2008/01/08/moving-files-to-trash-from-the-mac-command-line/
function trash() {
  local path
  for path in "$@"; do
    osascript -e "tell application \"Finder\"" -e "delete POSIX file \"${PWD}/$path\"" -e "end tell"
  done
}


# MARKDOWN
# =================================================
function mdown () {
  markdown --html4tags $1;
}


ips ()
{
    about 'display all ip addresses for this host'
    group 'base'
    ifconfig | grep "inet " | awk '{ print $2 }'
}

down4me ()
{
    about 'checks whether a website is down for you, or everybody'
    param '1: website url'
    example '$ down4me http://www.google.com'
    group 'base'
    curl -s "http://www.downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g'
}

myip ()
{
    about 'displays your ip address, as seen by the Internet'
    group 'base'
    res=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
    echo -e "Your public IP is: ${echo_bold_green} $res ${echo_normal}"
}


# Start an HTTP server from a directory, optionally specifying the port
# NOTE: don't forget to install Chrome duplicate tab detector: https://github.com/LeonardoGentile/chrome-duplicate-tab-detector
function server_python() {
    local port="${1:-8000}"
    local browser="${2:-canary}"

    if [[ "$browser" == 'canary'  ]]
        then
            open_canary "http://localhost:${port}/"
        else
            open "http://localhost:${port}/"
    fi

    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Open canary at a specific url or at the default http://localhost:8000/
# If canary is not installed or it is not under "/Applications/Web/Google Chrome Canary.app" it will open the url with the defualt browser
function open_canary() {
    local url="${1:-http\:\/\/localhost\:8000/}"
    if [[ -d "/Applications/Web/Google Chrome Canary.app" ]]; then
         /usr/bin/open -a "/Applications/Web/Google Chrome Canary.app" "${url}"

        # open with the default browser
        else
            open "${url}"
     fi
}


####################################################################################
# PHP BUILT IN SERVER (seems more reliable than python server, for unknown reasons)
####################################################################################
# NOTE: don't forget to install Chrome duplicate tab detector: https://github.com/LeonardoGentile/chrome-duplicate-tab-detector

# Start an HTTP server (Apache + php) from a directory, optionally specifying an file parameter to listen to (router)
# In this case when we use a php framework we can specify the "entry point" with no need of using .htacces and more_rewrite
# Optionally we can specify another root directory:  php -S localhost -t rootdirectory
function server() {
    local port="${1:-8000}"
    # The default first parameter is the port 8000
    local router="${2}"
    # The router second param if specified to a specific file will listen to it (useful for any php framework/routing app)
    # Example: phpserver index.php

    open_canary "http://localhost:${port}/"

    if [[ -z "$router" ]]; then
        echo "a"
        php -S localhost:"${port}"

        else
            echo "b"
            php -S localhost:"${port}" "${router}"
    fi

}



# Copy w/ progress
cp_p () {
    rsync -WavP --human-readable --progress $1 $2
}


# Test if HTTP compression (RFC 2616 + SDCH) is enabled for a given URL.
# Send a fake UA string for sites that sniff it instead of using the Accept-Encoding header. (Looking at you, ajax.googleapis.com!)
function httpcompression() {
        encoding="$(curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" | grep '^Content-Encoding:')" && echo "$1 is encoded using ${encoding#* }" || echo "$1 is not using any encoding"
}

# Syntax-highlight JSON strings or files
function json() {
        if [ -p /dev/stdin ]; then
                # piping, e.g. `echo '{"foo":42}' | json`
                python -mjson.tool | pygmentize -l javascript
        else
                # e.g. `json '{"foo":42}'`
                python -mjson.tool <<< "$*" | pygmentize -l javascript
        fi
}


# take this repo and copy it to somewhere else minus the .git stuff.
function gitexport(){
        mkdir -p "$1"
        git archive master | tar -x -C "$1"
}


# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
        function diff() {
                git diff --no-index --color-words "$@"
        }
fi


# All the dig info
function digga() {
        dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
        printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
        echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
        perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
        echo # newline
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract() {
        if [ -f "$1" ] ; then
                local filename=$(basename "$1")
                local foldername="${filename%%.*}"
                local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
                local didfolderexist=false
                if [ -d "$foldername" ]; then
                        didfolderexist=true
                        read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
                        echo
                        if [[ $REPLY =~ ^[Nn]$ ]]; then
                                return
                        fi
                fi
                mkdir -p "$foldername" && cd "$foldername"
                case $1 in
                        *.tar.bz2) tar xjf "$fullpath" ;;
                        *.tar.gz) tar xzf "$fullpath" ;;
                        *.tar.xz) tar Jxvf "$fullpath" ;;
                        *.tar.Z) tar xzf "$fullpath" ;;
                        *.tar) tar xf "$fullpath" ;;
                        *.taz) tar xzf "$fullpath" ;;
                        *.tb2) tar xjf "$fullpath" ;;
                        *.tbz) tar xjf "$fullpath" ;;
                        *.tbz2) tar xjf "$fullpath" ;;
                        *.tgz) tar xzf "$fullpath" ;;
                        *.txz) tar Jxvf "$fullpath" ;;
                        *.zip) unzip "$fullpath" ;;
                        *) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
                esac
        else
                echo "'$1' is not a valid file"
        fi
}


# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
        local tmpFile="${@%/}.tar"
        tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

        size=$(
                stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
                stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
        )

        local cmd=""
        if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
                # the .tar file is smaller than 50 MB and Zopfli is available; use it
                cmd="zopfli"
        else
                if hash pigz 2> /dev/null; then
                        cmd="pigz"
                else
                        cmd="gzip"
                fi
        fi

        echo "Compressing .tar using \`${cmd}\`…"
        "${cmd}" -v "${tmpFile}" || return 1
        [ -f "${tmpFile}" ] && rm "${tmpFile}"
        echo "${tmpFile}.gz created successfully."
}


# get gzipped size
function gz() {
        echo "orig size    (bytes): "
        cat "$1" | wc -c
        echo "gzipped size (bytes): "
        gzip -c "$1" | wc -c
}



# Determine size of a file or total size of a directory
function fs() {
        if du -b /dev/null > /dev/null 2>&1; then
                local arg=-sbh
        else
                local arg=-sh
        fi
        if [[ -n "$@" ]]; then
                du $arg -- "$@"
        else
                du $arg .[^.]* *
        fi
}



# animated gifs from any video
# from alex sexton   gist.github.com/SlexAxton/4989674
gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
      rm out-static*.png
    else
      ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
    fi
  else
    echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}


# Simple calculator
function calc() {
        local result=""
        result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
        #                       └─ default (when `--mathlib` is used) is 20
        #
        if [[ "$result" == *.* ]]; then
                # improve the output for decimal numbers
                printf "$result" |
                sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
                    -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
                    -e 's/0*$//;s/\.$//'   # remove trailing zeros
        else
                printf "$result"
        fi
        printf "\n"
}


# Create a new directory and enter it
function mkd() {
        mkdir -p "$@" && cd "$@"
}

# Install Grunt plugins and add them as `devDependencies` to `package.json`
# Usage: `gi contrib-watch contrib-uglify zopfli`
function gruntinstall() {
        local IFS=,
        eval npm install --save-dev grunt-{"$*"}
}


# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
        tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}


# A better git clone
# clones a repository, cds into it, and opens it in my editor.
#
# Based on https://github.com/stephenplusplus/dots/blob/master/.bash_profile#L68 by @stephenplusplus
#
# Note: subl is already setup as a shortcut to Sublime. Replace with your own editor if different
#
# - arg 1 - url|username|repo remote endpoint, username on github, or name of
#           repository.
# - arg 2 - (optional) name of repo
#
# usage:
#   $ clone things
#     .. git clone git@github.com:addyosmani/things.git things
#     .. cd things
#     .. subl .
#
#   $ clone yeoman generator
#     .. git clone git@github.com:yeoman/generator.git generator
#     .. cd generator
#     .. subl .
#
#   $ clone git@github.com:addyosmani/dotfiles.git
#     .. git clone git@github.com:addyosmani/dotfiles.git dotfiles
#     .. cd dots
#     .. subl .

function clone {
  # customize username to your own
  local username="LeonardoGentile"

  local url=$1;
  local repo=$2;

  if [[ ${url:0:4} == 'http' || ${url:0:3} == 'git' ]]
  then
    # just clone this thing.
    repo=$(echo $url | awk -F/ '{print $NF}' | sed -e 's/.git$//');
  elif [[ -z $repo ]]
  then
    # my own stuff.
    repo=$url;
    url="git@github.com:$username/$repo";
  else
    # not my own, but I know whose it is.
    url="git@github.com:$url/$repo.git";
  fi

  git clone $url $repo && cd $repo && sub .;
}


function caskInstall() {
    brew cask install "${@}" 2> /dev/null
}

# used for pretty diff
# function strip_diff_leading_symbols(){
#     color_code_regex=$'(\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K])'

#         # simplify the unified patch diff header
#         gsed -E "s/^($color_code_regex)diff --git .*$//g" | \
#                gsed -E "s/^($color_code_regex)index .*$/\
# \1$(rule)/g" | \
#                gsed -E "s/^($color_code_regex)\+\+\+(.*)$/\1\+\+\+\5\\
# \1$(rule)/g" | \

#         # actually strips the leading symbols
#                gsed -E "s/^($color_code_regex)[\+\-]/\1 /g"
# }


# function strip_diff_leading_symbols(){
#     color_code_regex="(\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K])"

#     # simplify the unified patch diff header
#     gsed -r "s/^($color_code_regex)diff --git .*$//g" | \
#        gsed -r "s/^($color_code_regex)index .*$/\n\1$(rule)/g" | \
#        gsed -r "s/^($color_code_regex)\+\+\+(.*)$/\1+++\5\n\1$(rule)\x1B\[m/g" |\

#         # actually strips the leading symbols
#         gsed -r "s/^($color_code_regex)[\+\-]/\1 /g"
# }


# # used for pretty diff
# ## Print a horizontal rule
# # rule () {
# #         printf "%$(tput cols)s\n"|tr " " "─"
# # }

# ## Print a horizontal rule
# rule () {
#    printf "%$(tput cols)s\n"|tr " " "─"
# }