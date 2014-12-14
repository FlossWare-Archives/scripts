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

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh

#
# Assuming we are standing in a directory that has a pom.xml,
# return the version element's value.
#
maven-get-pom-version() {
    ensure-file-exists pom.xml &&

    echo 'xpath /* [local-name()="project"]/* [local-name()="version"]/text()' | xmllint --shell pom.xml | grep content | cut -f 2 -d '='
}

#
# Compute the major version.
#
# Required params:
#   $1 - the version in Major.Minor.Release format.
#
maven-compute-major-version() {
    ensure-total-params 1 $* &&

    echo $1 | cut -f 1 -d '.'
}

#
# Compute the minor version.
#
# Required params:
#   $1 - the version in Major.Minor.Release format.
#
maven-compute-minor-version() {
    ensure-total-params 1 $* &&

    echo $1 | cut -f 2 -d '.'
}

#
# Compute the release version.
#
# Required params:
#   $1 - the version in Major.Minor.Release format.
#
maven-compute-release-version() {
    ensure-total-params 1 $* &&

    echo $1 | cut -f 3 -d '.'
}

#
# Compute the next major version.
#
# Required params:
#   $1 - the version in Major.Minor.Release format.
#
maven-compute-next-major-version() {
    VERSION=`maven-compute-major-version $1` &&
    increment-value ${VERSION}
}

#
# Compute the next minor version.
#
# Required params:
#   $1 - the version in Major.Minor.Release format.
#
maven-compute-next-minor-version() {
    VERSION=`maven-compute-minor-version $1` &&
    increment-value ${VERSION}
}

#
# Compute the next release version.
#
# Required params:
#   $1 - the version in Major.Minor.Release format.
#
maven-compute-next-release-version() {
    VERSION=`maven-compute-release-version $1` &&
    increment-value ${VERSION}
}

#
# Retrieve the major version from the current working
# dir's pom.xml.
#
maven-get-pom-major-version() {
    VERSION=`maven-get-pom-version` &&
    maven-compute-major-version ${VERSION}
}

#
# Retrieve the minor version from the current working
# dir's pom.xml.
#
maven-get-pom-minor-version() {
    VERSION=`maven-get-pom-version` &&
    maven-compute-minor-version ${VERSION}
}

#
# Retrieve the release version from the current working
# dir's pom.xml.
#
maven-get-pom-release-version() {
    VERSION=`maven-get-pom-version` &&
    maven-compute-release-version ${VERSION}
}

#
# Retrieve the major version from the current working
# dir's pom.xml.
#
maven-get-pom-next-major-version() {
    VERSION=`maven-get-pom-version` &&
    maven-compute-next-major-version ${VERSION}
}

#
# Retrieve the minor version from the current working
# dir's pom.xml.
#
maven-get-pom-next-minor-version() {
    VERSION=`maven-get-pom-version` &&
    maven-compute-next-minor-version ${VERSION}
}

#
# Retrieve the release version from the current working
# dir's pom.xml.
#
maven-get-pom-next-release-version() {
    VERSION=`maven-get-pom-version` &&
    maven-compute-next-release-version ${VERSION}
}

#
# Set the versions (parent and any child) on pom.xml's. 
# Must pass in one param to denote the version.
#
# Required params:
#   $1 - the version in Major.Minor.Release format to set.
#
maven-set-pom-version() {
    ensure-total-params 1 $* &&

    mvn -DallowSnaphots=false -DnewVersion="$1" -DgenerateBackupPoms=false versions:set
}

#
# Bump the major version of a pom.xml
#
maven-bump-pom-major-version() {
    VERSION="`maven-get-pom-next-major-version`.0.0" &&
    maven-set-pom-version ${VERSION}
}

#
# Bump the minor version of a pom.xml
#
maven-bump-pom-minor-version() {
    VERSION="`maven-get-pom-major-version`.`maven-get-pom-next-minor-version`.0" &&
    maven-set-pom-version ${VERSION}
}

#
# Bump the release of a pom.xml
#
maven-bump-pom-release-version() {
    VERSION="`maven-get-pom-major-version`.`maven-get-pom-minor-version`.`maven-get-pom-next-release-version`" &&
    maven-set-pom-version ${VERSION}
}

#
# Create a branch from the Maven major and minor numbers.
#
git-branch-from-maven-pom-version() {
    BRANCH="`maven-get-pom-major-version`.`maven-get-pom-minor-version`" &&

    git checkout ${BRANCH}

    if [ $? -eq 1 ]
    then
        git checkout -b ${BRANCH}
    fi
}

#
# Simple create a version bump message from the current
# pom.xml version...
#
git-msg-from-maven-pom-version-bump() {
    VERSION=`maven-get-pom-version` &&
    git commit -am "Version bump [${VERSION}]"
}

#
# Create a tag from the pom.xml version.
#
git-tag-from-maven-pom-version() {
    VERSION=`maven-get-pom-version` &&
    git tag ${VERSION}
}