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
# Publishes bintray maven artifacts
#

. `dirname ${BASH_SOURCE[0]}`/../rpm-utils.sh
. `dirname ${BASH_SOURCE[0]}`/bintray-utils.sh

set-bintray-vars $*

ensureData() {
    if [ "${BINTRAY_CONTEXT}" = "" ]
    then
        echo "Please provide context param (this is the spec file)!"
        exit 1
    fi
}

ensureData

`dirname ${BASH_SOURCE[0]}`/content-create.sh $* --bintrayVersion `compute-full-rpm-version ${BINTRAY_CONTEXT}`
`dirname ${BASH_SOURCE[0]}`/content-publish.sh $* --bintrayVersion `compute-full-rpm-version ${BINTRAY_CONTEXT}`