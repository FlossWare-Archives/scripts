#!/bin/sh 

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
# Open Shift does not allow one to affect the ~/.ssh directory.  So,
# for example, one cannot create ssh passwordless keys.  This is
# particularly challenging if you want Jenkins to make changes and
# commit/push-out those changes.  By using this script in conjunction
# with GIT_SSH, you can overcome some of these challenges.  You must
# specify the directory where your ssh keys reside.
#
# To use:
#  ssh-git.sh [directory to your ssh keys] [git params]
#
# Review openshift-push-to-github.sh to see how to incorporate this
# script and GIT_SSH.
#

ensureParams() {
    if [ $# -lt 2 ]
    then
        echo
        echo "ERROR"
        echo "  Need at least two parameters.  The first should be the location of the"
        echo "  to the identity file"
        echo
        echo "Example:"
        echo "  `dirname ${BASH_SOURCE[0]}`/$0 /var/lib/openshift/540b2c664382ec0a4f000622/jenkins/.ssh/id_rsa [remainder of params]"
        echo
        exit 1
    fi
}

ensureIdentityFile() {
    if [ ! -f $1 ]
    then
        echo
        echo "ERROR"
        echo "  Identify file [$1] does not exist!"
        echo
        exit 1
    fi
}

# Check we have some params...
ensureParams $@ &&

IDENTITY_FILE=$1 &&
shift &&

# Make sure we have the identify file...
ensureIdentityFile ${IDENTITY_FILE} &&

# Call out and do the needful.
exec ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${IDENTITY_FILE} "$@"