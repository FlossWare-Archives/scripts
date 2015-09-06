#!/bin/bash 

#
# This file is part of the FlossWare family of open source software.
#
# FlossWare is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
#

#
# General purpose utility script.
#

#
# If color is enabled, it will return $1
# otherwise empty string.
#
getColor() {
    tput colors 1>/dev/null 2>/dev/null
    if [ $? -eq 0 ]
    then
        echo -e $1
    else
        echo ""
    fi
}

#
# Return a foreground based upon mneumonic.
#
getForeground() {
    declare -A foreground

    foreground["default"]="39"

    foreground["black"]="30"
    foreground["red"]="31"
    foreground["green"]="32"
    foreground["yellow"]="33"
    foreground["blue"]="34"
    foreground["magenta"]="35"
    foreground["cyan"]="36"
    foreground["lightGray"]="37"

    foreground["darkGray"]="90"
    foreground["lightRed"]="91"
    foreground["darkGreen"]="92"
    foreground["lightYellow"]="93"
    foreground["lightBlue"]="94"
    foreground["lightMagenta"]="95"
    foreground["lightCyan"]="96"
    foreground["white"]="97"

    getColor "\e[${foreground[$1]}m"
}

#
# Return a background based upon mneumonic.
#
getBackground() {
    declare -A background

    background["default"]="49"

    background["black"]="40"
    background["red"]="41"
    background["green"]="42"
    background["yellow"]="43"
    background["blue"]="44"
    background["magenta"]="45"
    background["cyan"]="46"
    background["lightGray"]="47"

    background["darkGray"]="100"
    background["lightRed"]="101"
    background["darkGreen"]="102"
    background["lightYellow"]="103"
    background["lightBlue"]="104"
    background["lightMagenta"]="105"
    background["lightCyan"]="106"
    background["white"]="107"

    getColor "\e[${background[$1]}m"
}

#
# Emit a message to std err
#
# Optional params:
#   $* - these will be echo'd to std-err.
#
emit-msg() {
    echo "$@" 1>&2
}

#
# Emit a message in color (if supported)
#
# Required params:
#   $1 - the color as gound above in getForeground
#
emitColoredMsg() {
    COLOR=$1
    shift

    emit-msg "`getForeground ${COLOR}`$@`getForeground default`"
}

#
# Emit an error and exit
#
# Optional params:
#   $* - these will be echo'd to std-err.
#
error-msg() {
    emitColoredMsg "red" "ERROR:  $@"

    exit 1
}
#
# Emit a warning.
#
# Optional params:
#   $* - these will be echo'd to std-err.
#
warning-msg() {
    emitColoredMsg "yellow" "WARNING:  $@"
}

#
# Emit an informational message.
#
# Optional params:
#   $* - these will be echo'd to std-err.
#
info-msg() {
    emitColoredMsg "green" "INFO:  $@"
}

#
# Compute a default value.  If 2 params handed in, return the second
# one otherwise return the first.
#
# Requried params:
#   $1 - if this is the only param it will be returned.
#
# Optional params:
#   $2 - If defined will be the value returned.
#
compute-default-value() {
    if [ $# -eq 2  -a "$2" != "" ]
    then
        echo $2
    else
        echo $1
    fi
}

#
# Ensure we have a total number of parameters.
#
# Optional params:
#   $1     - if not handed in, will default to 0 params.
#   $2..$N - the params to count.
#
ensure-total-params() {
    TOTAL=`compute-default-value 0 $1`
    shift

    if [ $# -lt "${TOTAL}" -o $# -gt "${TOTAL}" ]
    then
        error-msg "Wrong number of total parameters - expected ${TOTAL}"
    fi
}

#
# Ensure we have a minimum number of params
#
# Optional params:
#   $1     - if not handed in, will default to 0 params.
#   $2..$N - the params to count.
#
ensure-min-params() {
    MIN=`compute-default-value 0 $1`
    shift

    if [ $# -lt ${MIN} ]
    then
        error-msg "Wrong number of minimum parameters - expected at least ${MIN}"
    fi
}

#
# Ensure we have a maximum number of params
#
# Optional params:
#   $1     - if not handed in, will default to 0 params.
#   $2..$N - the params to count.
#
ensure-max-params() {
    MAX=`compute-default-value 0 $1`
    shift

    if [ $# -gt ${MAX} ]
    then
        error-msg "Wrong number of maximum parameters - expected ${MAX} but found $#"
    fi
}

#
# Ensure a file exists.
#
# Required params:
#   $1 - the file to examine for existance.
#
ensure-file-exists() {
    ensure-total-params 1 $* &&
    if [ ! -e $1 ]
    then
        pwd
        error-msg "File [$1] does not exist!" 1>&2
    fi
}

#
# Ensure a directory exists.
#
# Required params:
#   $1 - the directory to examine for existance.
#
ensure-dir-exists() {
    ensure-total-params 1 $* &&
    if [ ! -d $1 ]
    then
        pwd
        error-msg "Directory [$1] does not exist!" 1>&2
    fi
}

#
# Remove a directory if it exists.
#
# Required params:
#   $1 - the directory to remove if it exists.
#
remove-dir-if-exists() {
    ensure-total-params 1 $* &&
    if [ -d $1 ]
    then
        rmdir $1
    fi  
}

#
# Create a dir if it doesn't exist.
#
# Required params:
#   $1 - the directory to remove if it exists.
#
create-dir() {
    ensure-total-params 1 $* &&

    if [ -f $1 ]
    then
        error-msg "Cannot create dir [$1] as it is a file"
        exit 1
    elif [ -d $1 ]
    then
        info-msg "Dir [$1] exists - will not attempt creation"
        return
    fi

    info-msg "Creating dir [$1]" &&
    mkdir -p $1
}

#
# Using params, separate them with commas.
#
# Optional params:
#   $* - all the params to comma separate.
#
separate-with-commas() {
    echo $* | tr -s ' ' ','
}

#
# Convert to a dashed list.
#
# Optional params:
#   $* - all the params to make a dashed list.
#
convert-to-dashed-list() {
    if [ "$*" != "" ]
    then
        echo "- $*" | sed ':a;N;$!ba;s/\n/\n- /g'
    fi
}

#
# Using params, convert to CSV enclosing each field with quotes.
#
# Optional params:
#   $* - all the params to make a CSV..
#
convert-to-csv() {
    VALUE="\(\([[:alnum:]]\)\|\(-\)\|\(\.\)\)\+"
    echo $* | sed -e "s/${VALUE}/\"\0\"/g" -e "s/\" \"/\", \"/g"
}

#
# Take a param and increment it by 1.
#
# Required params:
#   $1 - the value to increment.
#
increment-value() {
    ensure-total-params 1 $* &&
    expr $1 + 1
}

#
# Take a param and decrement it by 1.
#
# Required params:
#   $1 - the value to decrement
#
decrement-value() {
    ensure-total-params 1 $* && expr $1 - 1
}

#
# Create a unique value  We will use an optional prefix and suffix,
# plus the current system date down to nanoseconds and the built in
# RANDOM variable.
#
# Optional params:
#   $1 - the prefix of the computed uniqe string.
#   $2 - the suffix of the computed uniqe string.
#
generate-unique() {
    echo "$1`date +%Y%m%d%H%M%S%N`${RANDOM}$2"
}

#
# Using whatever params are handed in, execute and
# ensure newline are preserved.  Useful if one desires
# the results be stored in a variable.
#
# Optional params:
#   $* - will be echo'd to maintain newlines.
#
execute-with-newlines-preserved() {
    OLD_IFS=$IFS

    IFS=$'\n'

    $*

    IFS=${OLD_IFS}
}

#
# Useless - but makes a nice placeholder.
#
noop() {
    NOOP=""
}
