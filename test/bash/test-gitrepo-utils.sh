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

. `dirname ${BASH_SOURCE[0]}`/../../bash/gitrepo-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/test-utils.sh

#
# Test ensure protocol
#
test-ensureProtocol() {
    assert-failure ensureProtocol &&
    assert-success ensureProtocol "https://github.com/FlossWare/core.git" &&
    assert-success ensureProtocol "git@github.com:FlossWare/core.git"  &&
    assert-success ensureProtocol "https://flossware@bitbucket.org/flossware/scripts-test-maven.git" &&
    assert-success ensureProtocol "git@bitbucket.org:flossware/scripts-test-maven.git"
}

#
# Test converting a protocol.
#
test-convertProtocol() {
    assert-failure convertProtocol &&
    assert-equals "git@github.com:FlossWare/core.git" "`convertProtocol https://github.com/FlossWare/core.git`" &&
    assert-equals "git@github.com:FlossWare/core.git" "`convertProtocol git@github.com:FlossWare/core.git`"  &&
    assert-equals "git@bitbucket.org:flossware/scripts-test-maven.git" "`convertProtocol https://flossware@bitbucket.org/flossware/scripts-test-maven.git`" &&
    assert-equals "git@bitbucket.org:flossware/scripts-test-maven.git" "`convertProtocol git@bitbucket.org:flossware/scripts-test-maven.git`"
}

#
# Test converting a github remote...
#
test-convertGitRemote-github() {
    TEST_DIR=`mktemp -u`

    mkdir -p ${TEST_DIR}
    
    cd ${TEST_DIR}

    git clone https://github.com/FlossWare/core.git
    cd core

    convertGitRemote

    FULL_REMOTE=`git remote -v`
    REMOTE=`echo ${FULL_REMOTE}  | cut -f 2 -d ' '`

    cd - 1>/dev/null
    rm -rf ${TEST_DIR}

    assert-equals "git@github.com:FlossWare/core.git" "${REMOTE}"
}

#
# Test converting a bitbucket remote...
#
test-convertGitRemote-bitbucket() {
    TEST_DIR=`mktemp -u`

    mkdir -p ${TEST_DIR}
    
    cd ${TEST_DIR}

    git clone git@bitbucket.org:flossware/scripts-test-maven.git
    cd scripts-test-maven

    convertGitRemote

    FULL_REMOTE=`git remote -v`
    REMOTE=`echo ${FULL_REMOTE}  | cut -f 2 -d ' '`

    cd - 1>/dev/null
    rm -rf ${TEST_DIR}

    assert-equals "git@bitbucket.org:flossware/scripts-test-maven.git" "${REMOTE}"
}

# ----------------------------------------------------

unit-test-should-pass test-ensureProtocol
unit-test-should-pass test-convertProtocol
unit-test-should-pass test-convertGitRemote-github
unit-test-should-pass test-convertGitRemote-bitbucket

# ----------------------------------------------------