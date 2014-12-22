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
# RPM utilities
#

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh
. `dirname ${BASH_SOURCE[0]}`/git-utils.sh

#
# Retrieve the version from an RPM.  The RPM is
# found as param 1.
#
# Requried params:
#   $1 - the rpm file name
#
get-rpm-version() {
    ensure-min-params 1 $* &&
    ensure-file-exists $1  &&

    cat $1 | grep "Version:" | sed -e 's/Version://' | tr -d ' '
}

#
# Retrieve the release from an RPM.  The RPM is
# found as param 1.
#
# Requried params:
#   $1 - the rpm file name
#
get-rpm-release() {
    ensure-min-params 1 $* &&
    ensure-file-exists $1  &&

    cat $1 | grep "Release:" | sed -e 's/Release://' | tr -d ' '
}

#
# This will compute an RPM version.
#
# Requried params:
#   $1 - the version.
#   $2 - the release.
#
# Optional params:
#   $3 - the delimiter.  By default its is a dash.
#
compute-full-rpm-version-str() {
    ensure-min-params 2 $* &&
    DELIM=`compute-default-value "-" $3` &&

    echo "$1${DELIM}$2"
}


#
# Compute the last full version of an rpm.
#
# Requried params:
#   $1 - the version.
#   $2 - the release.
#
# Optional params:
#   $3 - the delimiter.  By default its is a dash.
#
compute-last-full-rpm-version() {
    VERSION=`get-rpm-version $1` &&
    RELEASE=`get-rpm-release $1` &&
    LAST_RELEASE=`decrement-value ${RELEASE}` &&

    compute-full-rpm-version-str ${VERSION} ${LAST_RELEASE} $3
}

#
# Compute the next full version of an rpm.
#
# Requried params:
#   $1 - the rpm file
#
# Optional params:
#   $2 - the delimiter.  By default its is a dash.
#
compute-next-full-rpm-version() {
    VERSION=`get-rpm-version $1` &&
    RELEASE=`get-rpm-release $1` &&
    NEXT_RELEASE=`increment-value ${RELEASE}` &&

    compute-full-rpm-version-str ${VERSION} ${NEXT_RELEASE} $2
}

#
# Compute the full version of an rpm.
#
# Requried params:
#   $1 - the rpm file
#
# Optional params:
#   $2 - the delimiter.  By default its is a dash.
#
compute-full-rpm-version() {
    VERSION=`get-rpm-version $1` &&
    RELEASE=`get-rpm-release $1` &&

    compute-full-rpm-version-str ${VERSION} ${RELEASE} $2
}

#
# Compute the next rpm release
#
# Requried params:
#   $1 - the rpm file
#
compute-next-rpm-release() {
    RELEASE=`get-rpm-release $1` &&
    increment-value ${RELEASE}
}

#
# Compute today's date in valid changelog format.
#
compute-rpm-date() {
    date '+%a %b %d %Y'
}

#
# Compute a change log entry between versions.
#
# Requried params:
#   $1 - the rpm file
#
compute-rpm-change-log-entry() {
    ensure-file-exists $1 &&

    CURRENT_VERSION=`compute-full-rpm-version $1` &&
    NEXT_VERSION=`compute-next-full-rpm-version $1` &&

    echo "* `compute-rpm-date` `compute-git-user-info` ${NEXT_VERSION}" &&

    LOG="`git-log-pretty ${CURRENT_VERSION}`"

    if [ "${LOG}" != "" ]
    then
        convert-to-dashed-list "${LOG}"
    else
        echo "- No changes."
    fi
}

#
# Compute a version bump message...
#
# Requried params:
#   $1 - the rpm file
#
compute-rpm-version-bump-msg() {
    VERSION=`compute-full-rpm-version $1` &&
    MSG="Version bump [${VERSION}]" &&
    echo "${MSG}"
}

#
# Bump the release version
#
# Requried params:
#   $1 - the rpm file
#
increment-rpm-release() {
    NEW_RELEASE=`compute-next-rpm-release $1` &&
    UNIQUE_FILE=`mktemp -u` &&

    sed -e "s/^Release:\( \)*\([0-9]\)\+/Release: ${NEW_RELEASE}/g" $1 > ${UNIQUE_FILE} &&
    mv ${UNIQUE_FILE} $1
}

#
# Set a change log message
#
git-add-rpm-changelog() {
    UNIQUE_FILE=`mktemp -u`

    ensure-file-exists $1
    if [ $? -ne 0 ]
    then
        rm ${UNIQUE_FILE}
        exit $#
    fi

    sed -n '1,/%changelog/ p' $1 > ${UNIQUE_FILE}
    compute-rpm-change-log-entry $1 >> ${UNIQUE_FILE}

    if [ $? -ne 0 ]
    then
        rm ${UNIQUE_FILE}
    else
        cat $1 | sed -n '/%changelog/,$ p' | sed -e '/%changelog/ d' >> ${UNIQUE_FILE}
        mv ${UNIQUE_FILE} $1
    fi
}

#
# Create a tag from an RPM.  The RPM is expected to be
# a param presented to this function.
#
git-tag-from-rpm() {
    TAG=`compute-full-rpm-version $*` &&

    git tag ${TAG}
}

#
# Simple create a version bump message from the current
# pom.xml version...
#
git-msg-from-rpm() {
    MSG="`compute-rpm-version-bump-msg $*`" &&
    git commit -am "${MSG}"
}

#
# Auto increment and commit the spec file..
#
git-update-rpm-spec() {
    git-add-rpm-changelog $* &&
    increment-rpm-release $* &&
    git-msg-from-rpm $* &&
    git-tag-from-rpm $*
}