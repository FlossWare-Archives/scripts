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
# Publishes bintray content
#

DIR=`dirname ${BASH_SOURCE[0]}`

. ${DIR}/bintray-utils.sh

set-bintray-vars $*

ensureData() {
    if [ "${BINTRAY_NAME}" = "" ]
    then
        echo "Please provide name param!"
        exit 1
    fi

    if [ "${BINTRAY_REPO}" = "" ]
    then
        echo "Please provide repo param!"
        exit 1
    fi

    if [ "${BINTRAY_PACKAGE}" = "" ]
    then
        echo "Please provide package param!"
        exit 1
    fi

    if [ "${BINTRAY_VERSION}" = "" ]
    then
        echo "Please provide version param!"
        exit 1
    fi
}

ensureData
        
curl -v -k -u ${BINTRAY_USER}:${BINTRAY_KEY} -X POST https://api.bintray.com/content/${BINTRAY_ACCOUNT}/${BINTRAY_REPO}/${BINTRAY_PACKAGE}/${BINTRAY_VERSION}/publish