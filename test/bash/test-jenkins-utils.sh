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
# Tests the github-utils.sh scripts
#

. `dirname ${BASH_SOURCE[0]}`/../../bash/jenkins-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/test-utils.sh

#
# Test ensure we have a workspace
#
test-ensure-workspace() {
    WORKSPACE=`mktemp -u`
    assert-failure ensure-workspace &&
    mkdir -p ${WORKSPACE} &&
    assert-success ensure-workspace &&
    rmdir ${WORKSPACE}
}

#
# Test we can compute the jenkins git user.
#
test-compute-jenkins-git-user() {
    assert-equals "" "`compute-jenkins-git-user`" &&
    GIT_COMMITTER_NAME=`generate-unique` &&
    assert-equals "${GIT_COMMITTER_NAME}" "`compute-jenkins-git-user`"
}

#
# Test we can compute the jenkins git user.
#
test-compute-jenkins-git-email() {
    assert-equals "" "`compute-jenkins-git-email`" &&
    GIT_COMMITTER_EMAIL=`generate-unique` &&
    assert-equals "${GIT_COMMITTER_EMAIL}" "`compute-jenkins-git-email`"
}

# ----------------------------------------------------

unit-test-should-pass test-ensure-workspace
#unit-test-should-pass test-compute-jenkins-git-user
#unit-test-should-pass test-compute-jenkins-git-email

# ----------------------------------------------------