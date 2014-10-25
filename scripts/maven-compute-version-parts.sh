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
# This will the compute all the versions in a maven pom.xml
# in the form of major.minor.release.  Each portion is stored
# in the following environment variables:
#
#   MAVEN_MAJOR_VERSION   - the major version.
#   MAVEN_MINOR_VERSION   - the minor version.
#   MAVEN_RELEASE_VERSION - the release version.
#
# You must specify a full path to pom.xml plus pom name.
# For example:
#    maven-compute-version-parts.sh /home/sfloess/project/pom.xml
#

DIR=`dirname $0`

MAVEN_VERSION=`${DIR}/maven-get-pom-version.sh $*`

if [ $? -ne 0 ]
then
    ${DIR}/maven-get-pom-version.sh $*

    exit $?
fi

TOTAL_DOTS=`echo "${MAVEN_VERSION}" | grep -o "\." | wc -l`

#
# We can try to get each field - but if the version is "2"
# all the major, minor and release will all be 2
#
MAVEN_MAJOR_VERSION=`echo ${MAVEN_VERSION} | cut -f 1 -d '.'`
MAVEN_MINOR_VERSION=`echo ${MAVEN_VERSION} | cut -f 2 -d '.'`
MAVEN_RELEASE_VERSION=`echo ${MAVEN_VERSION} | cut -f 3 -d '.'`

#
# If all we had was a 2 for version, then this will ensure
# we have have 0 for minor and 0 for release
#
if [ "${TOTAL_DOTS}" -lt 1 ]
then
    MAVEN_MINOR_VERSION="0"
    MAVEN_RELEASE_VERSION="0"
elif [ "${TOTAL_DOTS}" -lt 2 ]
then
    #
    # If we had 2.1 then release would be empty string
    #
    MAVEN_RELEASE_VERSION="0"
fi

#
# Below we want to ensure we didnt get a
# version like "..." or ".." or "."
#
if [ "${MAVEN_MAJOR_VERSION}" = "" ]
then
    MAVEN_MAJOR_VERSION="0"
fi

if [ "${MAVEN_MINOR_VERSION}" = "" ]
then
    MAVEN_MINOR_VERSION="0"
fi

if [ "${MAVEN_RELEASE_VERSION}" = "" ]
then
    MAVEN_RELEASE_VERSION="0"
fi