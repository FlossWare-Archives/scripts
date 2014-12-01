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

DIR=`dirname ${BASH_SOURCE[0]}`
BASH_DIR=${DIR}/../../bash

. ${BASH_DIR}/github-utils.sh
. ${BASH_DIR}/test-utils.sh


#
# Test ensure protocol
#
test-ensureProtocol() {
    assert-failure ensureProtocol &&
    assert-success ensureProtocol "https://github.com/FlossWare/core.git" &&
    assert-success ensureProtocol "git@github.com:FlossWare/core.git"
}

#
# Test converting a protocol.
#
test-convertProtocol() {
    assert-failure convertProtocol &&
    assert-equals "convertProtocol of http" "git@github.com:FlossWare/core.git" "`convertProtocol https://github.com/FlossWare/core.git`" &&
    assert-equals "convertProtocol of git" "git@github.com:FlossWare/core.git" "`convertProtocol git@github.com:FlossWare/core.git`"
}

#
# Test converting a github remote...
#
test-convertGitHubRemote() {
    TEST_DIR=`mktemp -u`

    mkdir -p ${TEST_DIR}
    
    cd ${TEST_DIR}

    git clone https://github.com/FlossWare/core.git
    cd core

    convertGitHubRemote

    FULL_REMOTE=`git remote -v`
    REMOTE=`echo ${FULL_REMOTE}  | cut -f 2 -d ' '`

    assert-equals "Should have correct remote" "git@github.com:FlossWare/core.git" "${REMOTE}"

    cd - 1>/dev/null
    rm -rf ${TEST_DIR}
}

# ----------------------------------------------------

test-suite-start

    # ------------------------------------------------

    unit-test-should-pass test-ensureProtocol
    unit-test-should-pass test-convertProtocol
    unit-test-should-pass test-convertGitHubRemote

    # ------------------------------------------------

test-suite-end

# ----------------------------------------------------