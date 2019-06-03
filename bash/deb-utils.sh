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
# Debian utilities
#

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh
. `dirname ${BASH_SOURCE[0]}`/git-utils.sh

#
# Retrieve the package from a deb file.  The deb file is
# found as param 1.
#
# Requried params:
#   $1 - the deb file name
#
get-deb-package() {
    ensure-min-params 1 $* &&
    ensure-file-exists $1  &&

    cat $1 | grep "Package:" | sed -e 's/Package://' | tr -d ' '
}

#
# Retrieve the full version from a deb file.  The deb file is
# found as param 1.
#
# Requried params:
#   $1 - the deb file name
#
get-deb-full-version() {
    ensure-min-params 1 $* &&
    ensure-max-params 1 $* &&
    ensure-file-exists $1  &&

    cat $1 | grep "Version:" | sed -e 's/Version://'  | tr -d ' '
}

#
# Retrieve the version from a deb file.  The deb file is
# found as param 1.
#
# Requried params:
#   $1 - the deb file name
#
# Optional params:
#   $2 - the delimiter.  By default its is a dash.
#
get-deb-version() {
    ensure-min-params 1 $* &&
    ensure-file-exists $1  &&
    local DELIM=`compute-default-value "-" $2` &&

    echo `get-deb-full-version $1` | cut -f 1 -d "${DELIM}" | tr -d ' '
}

#
# Retrieve the release from a deb file.  The deb file is
# found as param 1.
#
# Requried params:
#   $1 - the deb file name
#
# Optional params:
#   $2 - the delimiter.  By default its is a dash.
#
get-deb-release() {
    ensure-min-params 1 $* &&
    ensure-file-exists $1  &&
    local DELIM=`compute-default-value "-" $2` &&

    echo `get-deb-full-version $1` | cut -f 2 -d "${DELIM}" | tr -d ' '
}

#
# This will compute a deb file version.
#
# Requried params:
#   $1 - the version.
#   $2 - the release.
#
# Optional params:
#   $3 - the delimiter.  By default its is a dash.
#
compute-full-deb-version-str() {
    ensure-min-params 2 $* &&
    local DELIM=`compute-default-value "-" $3` &&

    echo "$1${DELIM}$2"
}


#
# Compute the last full version of an deb.
#
# Requried params:
#   $1 - the version.
#   $2 - the release.
#
# Optional params:
#   $3 - the delimiter.  By default its is a dash.
#
compute-last-full-deb-version() {
    local VERSION=`get-deb-version $1` &&
    local RELEASE=`get-deb-release $1 $3` &&
    local LAST_RELEASE=`decrement-value ${RELEASE}` &&

    compute-full-deb-version-str ${VERSION} ${LAST_RELEASE} $3
}

#
# Compute the next full version of an deb.
#
# Requried params:
#   $1 - the deb file
#
# Optional params:
#   $2 - the delimiter.  By default its is a dash.
#
compute-next-full-deb-version() {
    local VERSION=`get-deb-version $1` &&
    local RELEASE=`get-deb-release $1` &&
    local NEXT_RELEASE=`increment-value ${RELEASE}` &&

    compute-full-deb-version-str ${VERSION} ${NEXT_RELEASE} $2
}

#
# Compute the full version of an deb.
#
# Requried params:
#   $1 - the deb file
#
# Optional params:
#   $2 - the delimiter.  By default its is a dash.
#
compute-full-deb-version() {
    ensure-min-params 1 $* &&
    ensure-max-params 2 $* &&
    ensure-file-exists $*  &&

    local VERSION=`get-deb-version $1` &&
    local RELEASE=`get-deb-release $1` &&

    compute-full-deb-version-str ${VERSION} ${RELEASE} $2
}

#
# Compute the next deb release
#
# Requried params:
#   $1 - the deb file
#
compute-next-deb-release() {
    local RELEASE=`get-deb-release $1` &&
    increment-value ${RELEASE}
}

#
# Compute a version bump message...
#
# Requried params:
#   $1 - the deb file
#
compute-deb-version-bump-msg() {
    ensure-min-params 1 $* &&
    ensure-max-params 1 $* &&
    ensure-file-exists $*  &&

    echo "Version bump [`compute-full-deb-version $1`]"
}

#
# Bump the release version
#
# Requried params:
#   $1 - the deb file
#
# Optional params:
#   $2 - the delimiter.  By default its is a dash.
#
increment-deb-release() {
    ensure-min-params 1 $* &&
    ensure-max-params 2 $* &&
    ensure-file-exists $*  &&

    local DELIM=`compute-default-value "-" $2` &&
    local VERSION=`get-deb-version $1 $2` &&
    local NEW_RELEASE=`compute-next-deb-release $1 ${DELIM}` &&
    local UNIQUE_FILE=`mktemp -u` &&

    sed -e "s/^Version:.*/Version: ${VERSION}${DELIM}${NEW_RELEASE}/g" $1 > ${UNIQUE_FILE} &&
    mv ${UNIQUE_FILE} $1
}

#
# Create a tag from a deb file.  The deb file is expected to be
# a param presented to this function.
#
git-tag-from-deb() {
    ensure-min-params 1 $* &&
    ensure-max-params 2 $* &&
    ensure-file-exists $*  &&

    local TAG=`compute-full-deb-version $*` &&

    git tag ${TAG}
}

#
# Simple create a version bump message from the current
# pom.xml version...
#
git-msg-from-deb() {
    local MSG="`compute-deb-version-bump-msg $*`" &&
    git commit -am "${MSG}"
}

#
# Auto increment and commit the deb file..
#
git-update-deb() {
    increment-deb-release $* &&
    git-msg-from-deb $* &&
    git-tag-from-deb $*
}