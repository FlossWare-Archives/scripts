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
# Git utilities
#

DIR=`dirname ${BASH_SOURCE[0]}`

. ${DIR}/common-utils.sh
. ${DIR}/jenkins-utils.sh

#
# Compute the git user.  If one hands in a param and no
# defaults can be found (aka the git config or jenkins
# values), the param will be selected.
#
# Optional params:
#   $1 - The default value to use if no git user found.
#
compute-git-user() {
    GIT=`git config --list | grep user.name | cut -f 2 -d '='`
    JENKINS=`compute-jenkins-git-user`

    # Cheating - if we are run by Jenkins and the values are set, we will
    # Jenkins values..
    DEFAULT=`compute-default-value ${GIT} ${JENKINS}`

    echo `compute-default-value ${DEFAULT} $1`
}

#
# Compute the git email.  If one hands in a param and no
# defaults can be found (aka the git config or jenkins
# values), the param will be selected.
#
# Optional params:
#   $1 - The default value to use if no git user found.
#
compute-git-email() {
    GIT=`git config --list | grep user.email | cut -f 2 -d '='`
    JENKINS=`compute-jenkins-git-email`

    # Cheating - if we are run by Jenkins and the values are set, we will
    # Jenkins values..
    DEFAULT=`compute-default-value ${GIT} ${JENKINS}`

    echo `compute-default-value ${DEFAULT} $1`
}

#
# Compute the current git user in the format of:
# user <email.address>
#
# By handing in two params, if either user or email are not
# found those params will be assumed the defaults are these
# params:
#   $1 - default user
#   $2 - default email
#
compute-git-user-info() {
    COMPUTE_GIT_EMAIL=`compute-git-email $2`
    if [ "${COMPUTE_GIT_EMAIL}" != "" ]
    then
        # Purposely preceeding a space for the echose statement below...
        GIT_EMAIL=" <${COMPUTE_GIT_EMAIL}>"
    fi

    # If a git email address exists, it will have a space...
    echo "`compute-git-user $1`${GIT_EMAIL}"
}

#
# Run a git between two commits (tags, etc)...
#
# Required params:
#   $1 - starting tag.
#
# Optional params:
#   $2 - ending tag.
#
git-log-oneline() {
    ensure-min-params 1 $* &&

    execute-with-newlines-preserved git log --oneline "$1".."$2" | cut -f 2- -d ' ' | sort
}

#
# Emits the log in a way that contains the user, the user's email and the commit msg
#
# Required params:
#   $1 - starting tag.
#
# Optional params:
#   $2 - ending tag.
#
git-log-pretty() {
    ensure-min-params 1 $* &&

    execute-with-newlines-preserved git log --pretty="%cn <%ce>  %s" "$1".."$2" 
}