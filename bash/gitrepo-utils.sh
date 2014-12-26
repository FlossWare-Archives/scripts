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

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh

#
# Ensure a we have the correct protocol...
#
# Required params:
#   $1 - A git remote, for example git@github.com:FlossWare/scripts.git or git@bitbucket.org:flossware/scripts-test-maven.git
#
ensureProtocol() {
    ensure-total-params 1 $* &&

    PROTOCOL=`echo $1 | cut -f 1 -d ':'` &&

    if [ "${PROTOCOL}" != "https" ]
    then
        warning-msg "Protocol [${PROTOCOL}] for remote [${REMOTE}] is not [https] - ignoring"
    fi
}

#
# Converts the $1 param to a github pushable remote url.
#
# Required params:
#   $1 - a github url in http form
#
convertProtocol() {
    ensure-total-params 1 $* &&

    echo "$1" | sed -e 's/https:\/\/github.com\//git@github.com:/' | sed -e 's/https:\/\/\([[:alnum:]_]\)\+@bitbucket.org\//git@bitbucket.org:/'
}


#
# This function will change the the remote protocol from https to git
# for github or bintray.
#
# For example should you clone a github repo using the https
# protocol, you get a push ref similar to https://github.com/FlossWare/java.git or
# https://flossware@bitbucket.org/flossware/scripts-test-maven.git
#
# This script will change it to something similar to:
#    git@github.com:FlossWare/java.git
# Or
#    git@bitbucket.org:flossware/scripts-test-maven.git
#
# No params are expected.  However, it is assumed when this function is executed,
# the current working directory is in a git area.
#
convertGitRemote() {
    REMOTE_NAME=`git remote`
    REMOTE=`git remote -v | grep push | sed -e "s/${REMOTE_NAME}//" -e 's/ (push)//' -e 's/\t//'`

    ensureProtocol ${REMOTE} &&

    NEW_REMOTE=`convertProtocol ${REMOTE}` &&

    git remote remove origin &&
    git remote add origin ${NEW_REMOTE}
}