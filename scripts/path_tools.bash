# A set of tools for manipulating ":" separated lists like the
# canonical $PATH variable.
#
# /bin/sh compatibility can probably be regained by replacing $( )
# style command expansion with ` ` style
###############################################################################
# Usage:
#
# To remove a path:
#    replace_path         PATH /exact/path/to/remove
#    replace_path_pattern PATH <grep pattern for target path>
#
# To replace a path:
#    replace_path         PATH /exact/path/to/remove /replacement/path
#    replace_path_pattern PATH <target pattern> /replacement/path
#
###############################################################################

# Remove or replace an element of $1
#
#   $1 name of the shell variable to set (e.g. PATH)
#   $2 the precise string to be removed/replaced
#   $3 the replacement string (use "" for removal)
function replace_path () {
    path=$1
    list=$(eval echo '$'$path)
    remove=$2
    replace=$3            # Allowed to be empty or unset

    export $path=$(echo "$list" | tr ":" "\n" | sed "s:^$remove\$:$replace:" |
                   tr "\n" ":" | sed 's|:$||')
}

# Remove or replace an element of $1
#
#   $1 name of the shell variable to set (e.g. PATH)
#   $2 a grep pattern identifying the element to be removed/replaced
#   $3 the replacement string (use "" for removal)
function replace_path_pattern () {
    path=$1
    list=$(eval echo '$'$path)
    removepat=$2
    replacestr=$3            # Allowed to be empty or unset

    removestr=$(echo "$list" | tr ":" "\n" | grep -m 1 "^$removepat\$")
    replace_path "$path" "$removestr" "$replacestr"
}