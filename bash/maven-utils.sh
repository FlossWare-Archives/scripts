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
# General purpose maven utility script.
#

DIR=`dirname ${BASH_SOURCE[0]}`

. ${DIR}/common-utils.sh

#
# Assuming we are standing in a directory that has a pom.xml,
# return the version element's value.
#
maven-get-pom-version() {
    ensure-file-exists pom.xml &&

    echo 'xpath /* [local-name()="project"]/* [local-name()="version"]/text()' | xmllint --shell pom.xml | grep content | cut -f 2 -d '='
}

#
# Store parts of the version.
#
maven-store-version-parts() {
    MAVEN_VERSION=`maven-get-pom-version` &&

    #
    # We can try to get each field - but if the version is "2"
    # all the major, minor and release will all be 2
    #
    MAVEN_MAJOR_VERSION=`echo ${MAVEN_VERSION} | cut -f 1 -d '.'` &&
    MAVEN_MINOR_VERSION=`echo ${MAVEN_VERSION} | cut -f 2 -d '.'` &&
    MAVEN_RELEASE_VERSION=`echo ${MAVEN_VERSION} | cut -f 3 -d '.'`
}

#
# Disect the parts of the maven version - major, minor and release.
#
maven-compute-version-parts() {
    . maven-store-version-parts

    if [ $? -ne 0 ]
    then
        exit $?
    fi

    TOTAL_DOTS=`echo "${MAVEN_VERSION}" | grep -o "\." | wc -l` 

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
}

#
# Set the versions (parent and any child) on pom.xml's. 
# Must pass in one param to denote the version.
#
maven-set-version() {
    ensure-total-params 1 $* &&

    mvn -DallowSnaphots=false -DnewVersion="$1" -DgenerateBackupPoms=false versions:set
}

#
# Bump the major version of a pom.xml
#
maven-bump-major() {
    . maven-compute-version-parts &&

    NEW_MAVEN_MAJOR_VERSION=`increment-value ${MAVEN_MAJOR_VERSION}` &&

    maven-set-version "${NEW_MAVEN_MAJOR_VERSION}.0.0"
}

#
# Bump the minor version of a pom.xml
#
maven-bump-minor() {
    . maven-compute-version-parts &&

    NEW_MAVEN_MINOR_VERSION=`increment-value ${MAVEN_MINOR_VERSION}` &&

    maven-set-version "${MAVEN_MAJOR_VERSION}.${NEW_MAVEN_MINOR_VERSION}.0"
}

#
# Bump the release of a pom.xml
#
maven-bump-release() {
    . maven-compute-version-parts &&

    NEW_MAVEN_RELEASE_VERSION=`increment-value ${MAVEN_RELEASE_VERSION}` &&

    ${DIR}/maven-set-version.sh "${MAVEN_MAJOR_VERSION}.${MAVEN_MINOR_VERSION}.${NEW_MAVEN_RELEASE_VERSION}"
}

#
# Create a branch from the Maven major and minor numbers.
#
git-branch-from-maven-version() {
    . maven-compute-version-parts &&

    BRANCH=${MAVEN_MAJOR_VERSION}.${MAVEN_MINOR_VERSION} &&

    git checkout ${BRANCH} &&

    if [ $? -eq 1 ]
    then
        git checkout -b ${BRANCH}
    fi
}

#
# Simple create a version bump message from the current
# pom.xml version...
#
git-msg-from-maven-version-bump() {
    MSG="Version bump [`maven-get-pom-version`]" &&

    git commit -am "${MSG}"
}

#
# Create a tag from the pom.xml version.
#
git-tag-from-maven-version() {
    git tag `maven-get-pom-version`
}