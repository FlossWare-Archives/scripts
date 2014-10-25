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
# This will parse out a maven pom.xml's version element.
#
# You must specify a full path to pom.xml plus pom name.
# For example:
#    maven-get-pom-version.sh /home/sfloess/project/pom.xml
#

ensureParam() {
    if [ $# -lt 1 -o $# -gt 1 ]
    then
        echo
        echo "ERROR"
        echo "  Please provide a lone parameter that denotes the"
        echo "  maven pom file!"
        echo
        echo "Example:"
        echo "  `dirname $0`/$0 /var/lib/openshift/540b2c664382ec0a4f000622/app-root/data/workspace/FlossWare/pom.xml"
        echo
        exit 1
    fi
}

ensureFileExists() {
    if [ ! -f $1 ]
    then
        echo
        echo "ERROR"
        echo "  The file [$1] does not exist!"
        echo
        exit 1
    fi
}

ensureParam $@
ensureFileExists $@

echo 'xpath /* [local-name()="project"]/* [local-name()="version"]/text()' | xmllint --shell $1 | grep content | cut -f 2 -d '='