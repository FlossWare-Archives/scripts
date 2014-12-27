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
# Delete a bintray package
#

. `dirname ${BASH_SOURCE[0]}`/bintray-package-utils.sh $*

ensurePackageData
        
curl -v -k -u ${BINTRAY_USER}:${BINTRAY_KEY} -X DELETE https://api.bintray.com/packages/${BINTRAY_ACCOUNT}/${BINTRAY_REPO}/${BINTRAY_PACKAGE}