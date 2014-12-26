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
# This script allows a test suite to be run using openshift and the
# GIT_SSH script.
#
# To use:
#   openshift-test-suite.sh
#

. `dirname ${BASH_SOURCE[0]}`/openshift-config.sh

export GIT_SSH=`dirname ${BASH_SOURCE[0]}`/openshift-git-push.sh

. `dirname ${BASH_SOURCE[0]}`/../test-suite.sh $*