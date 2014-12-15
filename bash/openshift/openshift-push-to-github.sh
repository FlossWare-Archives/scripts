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
# This script will allow one to push out to github.  Since
# Open Shift does not allow direct access to ~/.ssh (as it is
# owned by root), setting up a password-less ssh key is
# challenging - and therefore we must use a different directory
# than ~/.ssh.  Additionally, since Jenkins can clone a git
# repo when building, if it's to be done ssh-less, you will likely
# (for ease of use) clone using the https protocol.
#
# We can change the remote to ssh and push out that way using
# this script.
#
# To use:
#   openshift-git-push-to-git.sh
#

cd ${WORKSPACE}

. `dirname ${BASH_SOURCE[0]}`/openshift-config.sh
. `dirname ${BASH_SOURCE[0]}`/../github-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../git-utils.sh

export GIT_SSH=`dirname ${BASH_SOURCE[0]}`/openshift-git-push.sh

convertGitHubRemote

git push origin `compute-git-current-branch` --tags