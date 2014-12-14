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

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh

#
# Using two params, compute a json field.
#
compute-json-field() {
    echo "\"$1\" : \"$2\""
}

#
# If $2 is handed in, we will compute a json field
# where $1 is the field and $2 is the value.
#
compute-json-field-if-value-set() {
    if [ "$2" != "" ]
    then
        NAME=$1
        shift

        echo "\"${NAME}\" : \"$*\""
    fi
}

#
# Computes a JSON array.

# If $2..$N are handed in, we will compute a json field
# where $1 is the field and $a..$N are converted to values.
#
compute-json-array-field-if-value-set() {
    NAME=$1
    shift

    if [ "$*" != "" ]
    then
        echo "\"${NAME}\" : [`convert-to-csv $*`]"
    fi
}

#
# Takes all params which represent JSON fields and separates them
# with commas.
#
separate-json-fields-with-commas() {
    FIELD='"\(\([[:alnum:]]\)*\([[:blank:]]\)*\)\+"'
    VALUE="\(${FIELD}\|\[${FIELD}\(, ${FIELD}\)*\]\)"
    echo $* | sed -e "s/\(${FIELD} : ${VALUE}[[:blank:]]\+\)/\0, /g"
}

#
# Taking all params computes to a json object
#
compute-json-object() {
    echo "{ `separate-json-fields-with-commas $*` }"
}