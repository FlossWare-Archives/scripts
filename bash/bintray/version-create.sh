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
# Creates a bintray version
#

. `dirname ${BASH_SOURCE[0]}`/bintray-version-util.sh $*

BINTRAY_CREATE=`compute-json-object ${BINTRAY_VERSION_JSON} ${BINTRAY_LICENSES_JSON} ${BINTRAY_DESC_JSON}`

curl -v -k -u ${BINTRAY_USER}:${BINTRAY_KEY} -H "Content-Type: application/json" -X POST https://api.bintray.com/packages/${BINTRAY_ACCOUNT}/${BINTRAY_REPO}/${BINTRAY_PACKAGE}/versions --data "${BINTRAY_CREATE}"
