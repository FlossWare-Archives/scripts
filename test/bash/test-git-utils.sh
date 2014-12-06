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

. ${BASH_DIR}/git-utils.sh
. ${BASH_DIR}/test-utils.sh

#
# Test computing the git config
#
test-compute-git-config() {
    assert-equals "`compute-git-config /tmp/blah.config`" "/tmp/blah.config" &&
    assert-equals "`compute-git-config`" "${HOME}/.gitconfig"
}

#
# Test computing the git user.  Unfortunately we will test using a git config
# elsewhere.
#
test-compute-git-user() {
    EXPECTED_NAME="Name`date +%N`"

    git config -f ${TEMP_GIT_CONFIG} --add user.name "${EXPECTED_NAME}"

    assert-equals "HA" "`compute-git-user HA ${TEMP_GIT_CONFIG}`" &&

    ACTUAL=`compute-git-user "" ${TEMP_GIT_CONFIG}` &&
    assert-equals "${EXPECTED_NAME}" "${ACTUAL}" &&

    GIT_COMMITTER_NAME="NA`date +%N`" &&
    assert-equals "${GIT_COMMITTER_NAME}" `compute-git-user "" ${TEMP_GIT_CONFIG}`

    rm ${TEMP_GIT_CONFIG}
}

#
# Test computing the git email.  Unfortunately we will test using a git config
# elsewhere.
#
test-compute-git-email() {
    EXPECTED_EMAIL="foo@company`date +%N`.com"

    git config -f ${TEMP_GIT_CONFIG} --add user.email "${EXPECTED_EMAIL}"

    assert-equals "HA@foobar.com" "`compute-git-user HA@foobar.com ${TEMP_GIT_CONFIG}`" &&

    ACTUAL=`compute-git-email "" ${TEMP_GIT_CONFIG}` &&
    assert-equals "${EXPECTED_EMAIL}" "${ACTUAL}" &&

    GIT_COMMITTER_EMAIL="bar@org`date +%N`.gov" &&
    assert-equals "${GIT_COMMITTER_EMAIL}" `compute-git-email "" ${TEMP_GIT_CONFIG}`

    rm ${TEMP_GIT_CONFIG}
}

#
# Test computing the git user info.  Unfortunately we will test using a git config
# elsewhere.
#
test-compute-git-user-info() {
    EXPECTED_NAME="Name`date +%N`"
    EXPECTED_EMAIL="foo@company`date +%N`.com"

    git config -f ${TEMP_GIT_CONFIG} --add user.name "${EXPECTED_NAME}"
    git config -f ${TEMP_GIT_CONFIG} --add user.email "${EXPECTED_EMAIL}"

    DEFAULT_USER1="wow" &&
    DEFAULT_EMAIL1="HA@foobar.com" &&
    EXPECTED1="${DEFAULT_USER1} <${DEFAULT_EMAIL1}>" &&
    ACTUAL1=`compute-git-user-info "${DEFAULT_USER1}" "${DEFAULT_EMAIL1}" ${TEMP_GIT_CONFIG}` &&
    assert-equals "${EXPECTED1}" "${ACTUAL1}" &&

    ACTUAL2=`compute-git-user-info "" "" "${TEMP_GIT_CONFIG}"` &&
    assert-equals "${EXPECTED_NAME} <${EXPECTED_EMAIL}>" "${ACTUAL2}" &&

    GIT_COMMITTER_NAME="NA`date +%N`" &&
    GIT_COMMITTER_EMAIL="bar@org`date +%N`.gov" &&
    assert-equals "${GIT_COMMITTER_NAME} <${GIT_COMMITTER_EMAIL}>" "`compute-git-user-info "" "" ${TEMP_GIT_CONFIG}`"

    rm ${TEMP_GIT_CONFIG}
}

#
# Set-up a git repo
#
setup-git-repo() {
    if [ -e "${TEMP_GIT_DIR}" ]
    then
        rm -rf ${TEMP_GIT_DIR}
    fi

    mkdir -p ${TEMP_GIT_DIR}

    cd ${TEMP_GIT_DIR}

    git init .

    touch foo
    git add foo
    git commit -m 'My test'
    git tag 1.0.0
    git add bar

    touch bar
    git add bar
    git commit -m 'Hello'

    date > bar1
    git add bar1
    git commit -m 'Theta'
    git tag 1.0.1

    date > bar2
    git add bar2
    git commit -m 'Zeta'
    git tag 1.0.2

    date > bar3
    git add bar3
    git commit -m 'ZetaZeta'

    date > bar4
    git add bar4
    git commit -m 'MayDay'
    git tag 1.0.3
}

#
# Test one line
#
test-git-log-oneline() {
    setup-git-repo

    EXPECTED1=`echo -e "Hello\nMayDay\nTheta\nZeta\nZetaZeta"`
    EXPECTED2=`echo -e "Hello\nTheta\nZeta"`

    cd ${TEMP_GIT_DIR}

    assert-failure git-log-oneline &&
    assert-equals "${EXPECTED1}" "`git-log-oneline 1.0.0`" &&
    assert-equals "${EXPECTED2}" "`git-log-oneline 1.0.0 1.0.2`" &&
    assert-equals "${EXPECTED1}" "`git-log-oneline 1.0.0 1.0.3`"
}

#
# Clean up...
#
cleanup() {
    if [ "${TEMP_GIT_CONFIG}" != "" -a -e "${TEMP_GIT_CONFIG}" ]
    then
        rm ${TEMP_GIT_CONFIG}
    fi

    if [ "${TEMP_GIT_DIR}" != "" -a -e "${TEMP_GIT_DIR}" ]
    then
        rm -rf ${TEMP_GIT_DIR}
    fi
}

TEMP_GIT_CONFIG=`mktemp -u`
TEMP_GIT_DIR=`mktemp -u`

# ----------------------------------------------------

test-suite-start

    # ------------------------------------------------

    unit-test-should-pass test-compute-git-config
    unit-test-should-pass test-compute-git-user
    unit-test-should-pass test-compute-git-email
    unit-test-should-pass test-compute-git-user-info
    unit-test-should-pass test-git-log-oneline

    # ------------------------------------------------

test-suite-end cleanup

# ----------------------------------------------------