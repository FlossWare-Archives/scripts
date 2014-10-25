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
# This will the major version in a maven pom in the format
# of major.minor.release.
#
# You must specify a full path to pom.xml plus pom name.
# For example:
#    maven-bump-major.sh /home/sfloess/project/pom.xml
#
# Please note this affects the pom.xml and any child pom.xml's.
#

DIR=`dirname $0`

. ${DIR}/maven-compute-version-parts.sh $*

if [ $? -ne 0 ]
then
    ${DIR}/maven-compute-version-parts.sh $*

    exit $?
fi

NEW_MAVEN_MAJOR_VERSION=`${DIR}/increment-value.sh ${MAVEN_MAJOR_VERSION}`

${DIR}/maven-set-version.sh "${NEW_MAVEN_MAJOR_VERSION}.0.0" $*