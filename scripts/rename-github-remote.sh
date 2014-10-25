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
# This will change the the remote protocol from https to git
# for github.
#
# For example should you clone a github repo using the https
# protocol, you get a push ref similar to https://github.com/FlossWare/java.git
#
# This script will change it to something similar to:
#  git@github.com:FlossWare/java.git
#
 
ensureProtocol() {
    PROTOCOL=`echo $1 | cut -f 1 -d ':'`

    if [ "${PROTOCOL}" != "https" ]
    then
        echo
        echo "ERROR!"
        echo "  Incorrect protocol [${PROTOCOL}] for remote [${REMOTE}]"
        echo
        exit
    fi
}

REMOTE=`git remote -v | grep push | sed -e 's/origin//' -e 's/ (push)//' -e 's/\t//'`

ensureProtocol ${REMOTE}

NEW_REMOTE=`echo ${REMOTE} | sed -e 's/https:\/\/github.com\//git@github.com:/'`

git remote remove origin
git remote add origin ${NEW_REMOTE}