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
# Open Shift does not allow us to affect change to
# ~/.ssh as this directory is owned by root.
#
# We will use a different directory for ssh identities
# and must denote this using the ssh-git.sh script.
#
# To use:
#   openshift-git-push.sh [remote] [branch]
#

DIR=`dirname ${BASH_SOURCE[0]}`

cd ${WORKSPACE}

. ${DIR}/openshift-config.sh

${DIR}/ssh-git.sh ${OPEN_SHIFT_SSH_DIR}/id_rsa $@