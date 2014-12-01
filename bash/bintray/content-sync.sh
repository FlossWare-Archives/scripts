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
# Sync bintray content to sonatype
#

DIR=`dirname ${BASH_SOURCE[0]}`

. ${DIR}/bintray-utils.sh

set-bintray-vars $*

ensureData() {
    if [ "${BINTRAY_VERSION}" = "" ]
    then
        echo "Please provide version param!"
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
}

ensureData

CLOSE_FIELD_JSON=`compute-json-field close 1`
BINTRAY_CREATE=`compute-json-object ${SONATYPE_USER_JSON} ${SONATYPE_PASSWORD_JSON} ${CLOSE_FIELD_JSON}`
        
curl -v -k -u ${BINTRAY_USER}:${BINTRAY_KEY} -X POST https://api.bintray.com/maven_central_sync/${BINTRAY_ACCOUNT}/${BINTRAY_REPO}/${BINTRAY_PACKAGE}/versions/${BINTRAY_VERSION} --data "${BINTRAY_CREATE}"