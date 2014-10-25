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
# This script will allow one to push out to bump a major version and
# push that out to github.
#
# To use:
#   openshift-git-bump-major-push-to-github.sh [initial branch to rev]
#

if [ $# -lt 1 ]
then
    echo
    echo "ERROR:"
    echo "   Please provide the branch in which to bump the major version"
    echo
    exit 1
fi

DIR=`dirname $0`

git checkout $1

${DIR}/maven-bump-major.sh $PWD/pom.xml

git checkout -b `${DIR}/maven-get-pom-version.sh pom.xml`

${DIR}/openshift-version-change-push-to-github.sh