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

. ${DIR}/utils.sh

compute-json-field() {
    echo "\"$1\" : \"$2\""
}

compute-json-field-if-value-set() {
    if [ "$2" != "" ]
    then
        echo "\"$1\" : \"$2\""
    fi
}

compute-json-array-field-if-value-set() {
    NAME=$1
    shift

    if [ "$*" != "" ]
    then
        echo "\"${NAME}\" : [`convert-to-csv $*`]"
    fi
}

separate-json-fields-with-commas() {
    FIELD='"\(\([[:alnum:]]\)*\([[:blank:]]\)*\)\+"'
    VALUE="\(${FIELD}\|\[${FIELD}\(, ${FIELD}\)*\]\)"
    echo $* | sed -e "s/\(${FIELD} : ${VALUE}[[:blank:]]\+\)/\0, /g"
}

compute-json-object() {
    echo "{ `separate-json-fields-with-commas $*` }"
}