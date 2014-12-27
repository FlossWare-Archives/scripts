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
# Creates bintray content
#

. `dirname ${BASH_SOURCE[0]}`/bintray-content-utils.sh $*
        
curl -v -k -T ${BINTRAY_FILE} -u ${BINTRAY_USER}:${BINTRAY_KEY} -X PUT https://api.bintray.com/content/${BINTRAY_ACCOUNT}/${BINTRAY_REPO}/${BINTRAY_PACKAGE}/${BINTRAY_VERSION}/`basename ${BINTRAY_FILE}`