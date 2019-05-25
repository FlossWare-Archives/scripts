#!/bin/bash  -x

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
# Tests the deb-utils.sh scripts
#

. `dirname ${BASH_SOURCE[0]}`/../../bash/git-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/deb-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/test-utils.sh

export TEST_DIR=`mktemp -u`
export CURRENT_DIR=`dirname \`readlink -f -- "${BASH_SOURCE[0]}"\``

#
# Simply setup by creating an empty git repo for testing.
#
setup() {
    git init ${TEST_DIR}

    cp ${CURRENT_DIR}/test.deb ${TEST_DIR}

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
# Test retrieving the deb package.
#
test-get-deb-package() {
    assert-failure get-deb-package &&
    assert-failure get-deb-package `mktemp -u` &&
    assert-equals "FlossWare" "`get-deb-package ${TEST_DIR}/test.deb`"
}

#
# Test retrieving the full deb version.
#
test-get-deb-full-version() {
    assert-failure get-deb-version &&
    assert-failure get-deb-version 1 2 3 &&
    assert-failure get-deb-version `mktemp -u` &&
    assert-equals "1.2-234" "`get-deb-full-version ${TEST_DIR}/test.deb`"
}

#
# Test retrieving the deb version.
#
test-get-deb-version() {
    assert-failure get-deb-version &&
    assert-failure get-deb-version `mktemp -u` &&
    assert-equals "1.2" "`get-deb-version ${TEST_DIR}/test.deb`"
}

#
# Test retrieving the deb release
#
test-get-deb-release() {
    assert-failure get-deb-release &&
    assert-failure get-deb-release `mktemp -u` &&
    assert-equals "234" "`get-deb-release ${TEST_DIR}/test.deb`"
    assert-equals "1.2-234" "`get-deb-release ${TEST_DIR}/test.deb x`"
}

#
# Test computing the full deb version.
#
test-compute-full-deb-version-str() {
    assert-failure compute-full-deb-version-str &&
    assert-failure compute-full-deb-version-str hello &&
    assert-equals "4.5-3" "`compute-full-deb-version-str 4.5 3`" &&
    assert-equals "4.5.3" "`compute-full-deb-version-str 4.5 3 .`"
}

#
# Test computing the last full deb version.
#
test-compute-last-full-deb-version() {
    assert-failure compute-last-full-deb-version &&
    assert-equals "1.2-233" "`compute-last-full-deb-version ${TEST_DIR}/test.deb`"
}

#
# Test computing the next full deb version.
#
test-compute-next-full-deb-version() {
    assert-failure compute-next-full-deb-version &&
    assert-equals "1.2-235" "`compute-next-full-deb-version ${TEST_DIR}/test.deb`"
}

#
# Test computing the full deb version.
#
test-compute-full-deb-version() {
    assert-failure compute-full-deb-version &&
    assert-equals "1.2-234" "`compute-full-deb-version ${TEST_DIR}/test.deb`"
}

#
# Test computing the next deb release
#
test-compute-next-deb-release() {
    assert-failure compute-next-deb-release &&
    assert-equals "235" "`compute-next-deb-release ${TEST_DIR}/test.deb`"
}

#
# Test computing a version bump message
#
test-compute-deb-version-bump-msg() {
    assert-failure compute-deb-version-bump-msg &&
    assert-failure compute-deb-version-bump-msg foo &&
    assert-equals "Version bump [1.2-234]" "`compute-deb-version-bump-msg ${TEST_DIR}/test.deb`"
}

#
# Test incrementing an deb release
#
test-increment-deb-release() {
    assert-failure increment-deb-release &&
    assert-failure increment-deb-release foo &&

    increment-deb-release ${TEST_DIR}/test.deb &&

    assert-equals "1.2-235" "`get-deb-release ${TEST_DIR}/test.deb`" &&
    assert-equals "235" "`get-deb-release ${TEST_DIR}/test.deb`"
}



#
# Test computing the deb date
#
test-compute-deb-date() {
    assert-not-blank "`compute-deb-date`"
}

#
# Test computing the log entries with no changes
#
test-compute-deb-change-log-entry-no-changes() {
    assert-failure compute-deb-change-log-entry && 
    assert-failure compute-deb-change-log-entry foo.deb && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git tag 1.2-3 &&

    echo "`compute-deb-change-log-entry ${TEST_DIR}/test.deb`" | grep "1.2-4" &&
    echo "`compute-deb-change-log-entry ${TEST_DIR}/test.deb`" | grep "\- No changes."
}

#
# Test computing the log entries with a change
#
test-compute-deb-change-log-entry-a-change() {
    assert-failure compute-deb-change-log-entry && 
    assert-failure compute-deb-change-log-entry foo.deb && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git tag 1.2-3 &&

    touch alpha &&
    git add alpha &&
    git commit -m 'Blah 2' &&

    echo "`compute-deb-change-log-entry ${TEST_DIR}/test.deb`" | grep "1.2-4" &&
    echo "`compute-deb-change-log-entry ${TEST_DIR}/test.deb`" | grep "Blah 2"
}

#
# Test adding an deb change log with no changes
#
test-git-add-deb-changelog-no-changes() {
    assert-failure git-add-deb-changelog && 
    assert-failure git-add-deb-changelog foo.deb && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git tag 1.2-3 &&

    git-add-deb-changelog ${TEST_DIR}/test.deb &&

    cat ${TEST_DIR}/test.deb | grep "1.2-4" &&
    cat ${TEST_DIR}/test.deb | grep "\- No changes."
}

#
# Test adding an deb change log with a changes
#
test-git-add-deb-changelog-a-change() {
    assert-failure git-add-deb-changelog && 
    assert-failure git-add-deb-changelog foo.deb && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git tag 1.2-3 &&

    touch alpha &&
    git add alpha &&
    git commit -m 'Blah 2' &&

    git-add-deb-changelog ${TEST_DIR}/test.deb &&

    cat ${TEST_DIR}/test.deb | grep "1.2-4" &&
    cat ${TEST_DIR}/test.deb | grep "Blah 2"
}

#
# Test tagging from an deb
#
test-git-tag-from-deb() {
    assert-failure git-tag-from-deb && 
    assert-failure git-tag-from-deb foo.deb && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git-tag-from-deb ${TEST_DIR}/test.deb &&

    git tag | grep 1.2-3
}

#
# Test a version message bump.
#
test-git-msg-from-deb() {
    assert-failure git-msg-from-deb &&
    assert-failure git-msg-from-deb foo &&
    git add test.deb &&
    git-msg-from-deb ${TEST_DIR}/test.deb &&
    git log | grep "Version bump \[1.2-3\]" 
}

#
# Test auto incrementing and commiting the deb file.
#
test-git-update-deb-deb() {
    assert-failure git-update-deb-deb &&
    assert-failure git-update-deb-deb foo &&

    git add test.deb &&
    git commit -m 'Blueeeee' &&
    git tag 1.2-3 &&

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&

    git-update-deb-deb ${TEST_DIR}/test.deb &&
    assert-equals "1.2" "`get-deb-version ${TEST_DIR}/test.deb`" &&
    assert-equals "4" "`get-deb-release ${TEST_DIR}/test.deb`" &&
    git log | grep "Version bump \[1.2-4\]" &&
    git tag | grep "1.2-4"
}

# ----------------------------------------------------

#unit-test-should-pass test-get-deb-package
#unit-test-should-pass test-get-deb-full-version
#unit-test-should-pass test-get-deb-version
#unit-test-should-pass test-get-deb-release
#unit-test-should-pass test-compute-full-deb-version-str
#unit-test-should-pass test-compute-last-full-deb-version
#unit-test-should-pass test-compute-next-full-deb-version
#unit-test-should-pass test-compute-full-deb-version
#unit-test-should-pass test-compute-next-deb-release
#unit-test-should-pass test-compute-deb-version-bump-msg
unit-test-should-pass test-increment-deb-release

#unit-test-should-pass test-compute-deb-date
#unit-test-should-pass test-compute-deb-change-log-entry-no-changes
#unit-test-should-pass test-compute-deb-change-log-entry-a-change
#unit-test-should-pass test-compute-next-deb-release
#unit-test-should-pass test-git-add-deb-changelog-no-changes
#unit-test-should-pass test-git-add-deb-changelog-a-change
#unit-test-should-pass test-git-tag-from-deb
#unit-test-should-pass test-git-msg-from-deb
#unit-test-should-pass test-git-update-deb-deb

# ----------------------------------------------------