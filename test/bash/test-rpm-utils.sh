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
. `dirname ${BASH_SOURCE[0]}`/../../bash/rpm-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/test-utils.sh

export TEST_DIR=`mktemp -u`
export CURRENT_DIR=`dirname \`readlink -f -- "${BASH_SOURCE[0]}"\``

#
# Simply setup by creating an empty git repo for testing.
#
setup() {
    git init ${TEST_DIR}

    cp ${CURRENT_DIR}/test.spec ${TEST_DIR}

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
# Test retrieving the rpm version.
#
test-get-rpm-version() {
    assert-failure get-rpm-version &&
    assert-failure get-rpm-version `mktemp -u` &&
    assert-equals "1.2" "`get-rpm-version ${TEST_DIR}/test.spec`"
}

#
# Test retrieving the rpm release
#
test-get-rpm-release() {
    assert-failure get-rpm-release &&
    assert-failure get-rpm-release `mktemp -u` &&
    assert-equals "3" "`get-rpm-release ${TEST_DIR}/test.spec`"
}

#
# Test computing the full rpm version.
#
test-compute-full-rpm-version-str() {
    assert-failure compute-full-rpm-version-str &&
    assert-failure compute-full-rpm-version-str hello &&
    assert-equals "4.5-3" "`compute-full-rpm-version-str 4.5 3`" &&
    assert-equals "4.5.3" "`compute-full-rpm-version-str 4.5 3 .`"
}

#
# Test computing the last full rpm version.
#
test-compute-last-full-rpm-version() {
    assert-failure compute-last-full-rpm-version &&
    assert-equals "1.2-2" "`compute-last-full-rpm-version ${TEST_DIR}/test.spec`"
}

#
# Test computing the next full rpm version.
#
test-compute-next-full-rpm-version() {
    assert-failure compute-next-full-rpm-version &&
    assert-equals "1.2-4" "`compute-next-full-rpm-version ${TEST_DIR}/test.spec`"
}

#
# Test computing the full rpm version.
#
test-compute-full-rpm-version() {
    assert-failure compute-full-rpm-version &&
    assert-equals "1.2-3" "`compute-full-rpm-version ${TEST_DIR}/test.spec`"
}

#
# Test computing the next rpm release
#
test-compute-next-rpm-release() {
    assert-failure compute-next-rpm-release &&
    assert-equals "4" "`compute-next-rpm-release ${TEST_DIR}/test.spec`"
}

#
# Test computing the rpm date
#
test-compute-rpm-date() {
    assert-not-blank "`compute-rpm-date`"
}

#
# Test computing the log entries with no changes
#
test-compute-rpm-change-log-entry-no-changes() {
    assert-failure compute-rpm-change-log-entry && 
    assert-failure compute-rpm-change-log-entry foo.spec && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git tag 1.2-3 &&

    echo "`compute-rpm-change-log-entry ${TEST_DIR}/test.spec`" | grep "1.2-4" &&
    echo "`compute-rpm-change-log-entry ${TEST_DIR}/test.spec`" | grep "\- No changes."
}

#
# Test computing the log entries with a change
#
test-compute-rpm-change-log-entry-a-change() {
    assert-failure compute-rpm-change-log-entry && 
    assert-failure compute-rpm-change-log-entry foo.spec && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git tag 1.2-3 &&

    touch alpha &&
    git add alpha &&
    git commit -m 'Blah 2' &&

    echo "`compute-rpm-change-log-entry ${TEST_DIR}/test.spec`" | grep "1.2-4" &&
    echo "`compute-rpm-change-log-entry ${TEST_DIR}/test.spec`" | grep "Blah 2"
}

#
# Test computing a version bump message
#
test-compute-rpm-version-bump-msg() {
    assert-failure compute-rpm-version-bump-msg &&
    assert-failure compute-rpm-version-bump-msg foo &&
    assert-equals "Version bump [1.2-3]" "`compute-rpm-version-bump-msg ${TEST_DIR}/test.spec`"
}

#
# Test incrementing an rpm release
#
test-increment-rpm-release() {
    assert-failure increment-rpm-release &&
    assert-failure increment-rpm-release foo &&
    increment-rpm-release ${TEST_DIR}/test.spec &&
    assert-equals "4" "`get-rpm-release ${TEST_DIR}/test.spec`"
}

#
# Test adding an rpm change log with no changes
#
test-git-add-rpm-changelog-no-changes() {
    assert-failure git-add-rpm-changelog && 
    assert-failure git-add-rpm-changelog foo.spec && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git tag 1.2-3 &&

    git-add-rpm-changelog ${TEST_DIR}/test.spec &&

    cat ${TEST_DIR}/test.spec | grep "1.2-4" &&
    cat ${TEST_DIR}/test.spec | grep "\- No changes."
}

#
# Test adding an rpm change log with a changes
#
test-git-add-rpm-changelog-a-change() {
    assert-failure git-add-rpm-changelog && 
    assert-failure git-add-rpm-changelog foo.spec && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git tag 1.2-3 &&

    touch alpha &&
    git add alpha &&
    git commit -m 'Blah 2' &&

    git-add-rpm-changelog ${TEST_DIR}/test.spec &&

    cat ${TEST_DIR}/test.spec | grep "1.2-4" &&
    cat ${TEST_DIR}/test.spec | grep "Blah 2"
}

#
# Test tagging from an rpm
#
test-git-tag-from-rpm() {
    assert-failure git-tag-from-rpm && 
    assert-failure git-tag-from-rpm foo.spec && 

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&
    git-tag-from-rpm ${TEST_DIR}/test.spec &&

    git tag | grep 1.2-3
}

#
# Test a version message bump.
#
test-git-msg-from-rpm() {
    assert-failure git-msg-from-rpm &&
    assert-failure git-msg-from-rpm foo &&
    git add test.spec &&
    git-msg-from-rpm ${TEST_DIR}/test.spec &&
    git log | grep "Version bump \[1.2-3\]" 
}

#
# Test auto incrementing and commiting the spec file.
#
test-git-update-rpm-spec() {
    assert-failure git-update-rpm-spec &&
    assert-failure git-update-rpm-spec foo &&

    git add test.spec &&
    git commit -m 'Blueeeee' &&
    git tag 1.2-3 &&

    touch foo &&
    git add foo &&
    git commit -m 'Blah' &&

    git-update-rpm-spec ${TEST_DIR}/test.spec &&
    assert-equals "1.2" "`get-rpm-version ${TEST_DIR}/test.spec`" &&
    assert-equals "4" "`get-rpm-release ${TEST_DIR}/test.spec`" &&
    git log | grep "Version bump \[1.2-4\]" &&
    git tag | grep "1.2-4"
}

# ----------------------------------------------------

unit-test-should-pass test-get-rpm-version
unit-test-should-pass test-get-rpm-release
unit-test-should-pass test-compute-full-rpm-version-str
unit-test-should-pass test-compute-last-full-rpm-version
unit-test-should-pass test-compute-next-full-rpm-version
unit-test-should-pass test-compute-full-rpm-version
unit-test-should-pass test-compute-next-rpm-release
unit-test-should-pass test-compute-rpm-date
unit-test-should-pass test-compute-rpm-change-log-entry-no-changes
unit-test-should-pass test-compute-rpm-change-log-entry-a-change
unit-test-should-pass test-compute-rpm-version-bump-msg
unit-test-should-pass test-increment-rpm-release
unit-test-should-pass test-git-add-rpm-changelog-no-changes
unit-test-should-pass test-git-add-rpm-changelog-a-change
unit-test-should-pass test-git-tag-from-rpm
unit-test-should-pass test-git-msg-from-rpm
unit-test-should-pass test-git-update-rpm-spec

# ----------------------------------------------------