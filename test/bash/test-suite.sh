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
# Tests our scripts
#

run-test-suite() {
    . `dirname ${BASH_SOURCE[0]}`/test-common-utils.sh  &&
    . `dirname ${BASH_SOURCE[0]}`/test-gitrepo-utils.sh &&
    . `dirname ${BASH_SOURCE[0]}`/test-git-utils.sh     &&
    . `dirname ${BASH_SOURCE[0]}`/test-jenkins-utils.sh &&
    . `dirname ${BASH_SOURCE[0]}`/test-json-utils.sh    &&
    . `dirname ${BASH_SOURCE[0]}`/test-maven-utils.sh   &&
    . `dirname ${BASH_SOURCE[0]}`/test-rpm-utils.sh     &&
    . `dirname ${BASH_SOURCE[0]}`/test-iso-utils.sh
}