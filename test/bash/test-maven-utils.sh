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

. `dirname ${BASH_SOURCE[0]}`/../../bash/git-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/maven-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/test-utils.sh

export TEST_DIR=`mktemp -u`
export CURRENT_DIR=`dirname \`realpath ${BASH_SOURCE[0]}\``

#
# Simply setup by creating an empty git repo for testing.
#
setup() {
    git init ${TEST_DIR}

    cp ${CURRENT_DIR}/pom.xml ${TEST_DIR}

    cd ${TEST_DIR}
}

#
# Remove the test dir if it exists.
#
cleanup() {
    if [ "${TEST_DIR}" != "" -a -e "${TEST_DIR}" ]
    then
        rm -rf ${TEST_DIR}
    fi
}

#
# Start of a unit test
#
unit-test-setup() {
    cleanup
    setup
}

#
# Clean up our test dir...
#
unit-test-teardown() {
   cleanup
}

#
# Test retrieving the pom version.
#
test-maven-get-pom-version() {
    cd /tmp &&
    assert-failure maven-get-pom-version &&
    cd ${TEST_DIR} &&
    assert-equals "1.2.3" "`maven-get-pom-version`"
}

#
# Test computing the major version.
#
test-maven-compute-major-version() {
    assert-failure maven-compute-major-version &&
    assert-equals "3" "`maven-compute-major-version 3.4.5`"
}

#
# Test computing the minor version.
#
test-maven-compute-minor-version() {
    assert-failure maven-compute-minor-version &&
    assert-equals "6" "`maven-compute-minor-version 5.6.7`"
}

#
# Test computing the release version.
#
test-maven-compute-release-version() {
    assert-failure maven-compute-release-version &&
    assert-equals "8" "`maven-compute-release-version 6.7.8`"
}

#
# Test computing the next major version.
#
test-maven-compute-next-major-version() {
    assert-failure maven-compute-next-major-version &&
    assert-equals "7" "`maven-compute-next-major-version 6.7.8`"
}

#
# Test computing the next minor version.
#
test-maven-compute-next-minor-version() {
    assert-failure maven-compute-next-minor-version &&
    assert-equals "8" "`maven-compute-next-minor-version 6.7.8`"
}

#
# Test computing the next release version.
#
test-maven-compute-next-release-version() {
    assert-failure maven-compute-next-release-version &&
    assert-equals "9" "`maven-compute-next-release-version 6.7.8`"
}

#
# Test retrieving the pom major version.
#
test-maven-get-pom-major-version() {
    cd /tmp &&
    assert-failure maven-get-pom-major-version &&
    cd ${TEST_DIR} &&
    assert-equals "1" "`maven-get-pom-major-version`"
}

#
# Test retrieving the pom minor version.
#
test-maven-get-pom-minor-version() {
    cd /tmp &&
    assert-failure maven-get-pom-minor-version &&
    cd ${TEST_DIR} &&
    assert-equals "2" "`maven-get-pom-minor-version`"
}

#
# Test retrieving the pom release version.
#
test-maven-get-pom-release-version() {
    cd /tmp &&
    assert-failure maven-get-pom-release-version &&
    cd ${TEST_DIR} &&
    assert-equals "3" "`maven-get-pom-release-version`"
}

#
# Test retrieving the next pom major version.
#
test-maven-get-pom-next-major-version() {
    cd /tmp &&
    assert-failure maven-get-pom-next-major-version &&
    cd ${TEST_DIR} &&
    assert-equals "2" "`maven-get-pom-next-major-version`"
}

#
# Test retrieving the next pom minor version.
#
test-maven-get-pom-next-minor-version() {
    cd /tmp &&
    assert-failure maven-get-pom-next-minor-version &&
    cd ${TEST_DIR} &&
    assert-equals "3" "`maven-get-pom-next-minor-version`"
}

#
# Test retrieving the next pom release version.
#
test-maven-get-pom-next-release-version() {
    cd /tmp &&
    assert-failure maven-get-pom-next-release-version &&
    cd ${TEST_DIR} &&
    assert-equals "4" "`maven-get-pom-next-release-version`"
}

#
# Test setting the pom version
#
test-maven-set-pom-version() {
    cd /tmp &&
    assert-failure maven-set-pom-version &&
    cd ${TEST_DIR} &&
    assert-failure maven-set-pom-version &&
    maven-set-pom-version 10.20.30 &&
    assert-equals "10.20.30" "`maven-get-pom-version`"
}

#
# Test bumping the pom major version
#
test-maven-bump-pom-major-version() {
    cd /tmp &&
    assert-failure maven-bump-pom-major-version &&
    cd ${TEST_DIR} &&
    maven-bump-pom-major-version &&
    assert-equals "2.0.0" "`maven-get-pom-version`"
}

#
# Test bumping the pom minor version
#
test-maven-bump-pom-minor-version() {
    cd /tmp &&
    assert-failure maven-bump-pom-minor-version &&
    cd ${TEST_DIR} &&
    maven-bump-pom-minor-version &&
    assert-equals "1.3.0" "`maven-get-pom-version`"
}

#
# Test bumping the pom release version
#
test-maven-bump-pom-release-version() {
    cd /tmp &&
    assert-failure maven-bump-pom-release-version &&

    cd ${TEST_DIR} &&
    maven-bump-pom-release-version &&
    assert-equals "1.2.4" "`maven-get-pom-version`"
}

#
# Test branching from the maven pom version
#
test-git-branch-from-maven-pom-version() {
    cd /tmp &&
    assert-failure git-branch-from-maven-pom-version &&

    cd ${TEST_DIR} &&
    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git-branch-from-maven-pom-version &&
    assert-equals "1.2" "`compute-git-current-branch`"
}

#
# Test a git msg from a pom version bump
#
test-git-msg-from-maven-pom-version-bump() {
    cd /tmp &&
    assert-failure git-msg-from-maven-pom-version-bump &&

    cd ${TEST_DIR} &&
    git add pom.xml &&
    git-msg-from-maven-pom-version-bump &&
    assert-equals "Version bump [1.2.3]" "`git log --oneline | cut -f 2- -d ' '`"
}


#
# Test a tag from the maven pom version
#
test-git-tag-from-maven-pom-version() {
    cd /tmp &&
    assert-failure git-msg-from-maven-pom-version-bump &&

    cd ${TEST_DIR} &&
    git add pom.xml &&
    git-msg-from-maven-pom-version-bump &&
    git-tag-from-maven-pom-version &&
    TAG=`git tag | grep 1.2.3` &&
    assert-equals "1.2.3" "${TAG}"
}

# ----------------------------------------------------

unit-test-should-pass test-maven-get-pom-version
unit-test-should-pass test-maven-compute-major-version
unit-test-should-pass test-maven-compute-minor-version
unit-test-should-pass test-maven-compute-release-version
unit-test-should-pass test-maven-compute-next-major-version
unit-test-should-pass test-maven-compute-next-minor-version
unit-test-should-pass test-maven-compute-next-release-version
unit-test-should-pass test-maven-get-pom-major-version
unit-test-should-pass test-maven-get-pom-minor-version
unit-test-should-pass test-maven-get-pom-release-version
unit-test-should-pass test-maven-get-pom-next-major-version
unit-test-should-pass test-maven-get-pom-next-minor-version
unit-test-should-pass test-maven-get-pom-next-release-version
unit-test-should-pass test-maven-set-pom-version
unit-test-should-pass test-maven-bump-pom-major-version
unit-test-should-pass test-maven-bump-pom-minor-version
unit-test-should-pass test-maven-bump-pom-release-version
unit-test-should-pass test-git-branch-from-maven-pom-version
unit-test-should-pass test-git-msg-from-maven-pom-version-bump
unit-test-should-pass test-git-tag-from-maven-pom-version

# ----------------------------------------------------