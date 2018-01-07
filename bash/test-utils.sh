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
# This is sort of a junit type testing class.
#

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh

#
# Emit a message that a test passed.
#
emitTestPassMsg() {
    emitColoredMsg "darkGreen" "    PASS:  $@"
}

#
# Emit a message that a test failed.
#
emitTestFailMsg() {
    emitColoredMsg "lightRed"  "    FAIL:  $@"
}

#
# Emit an informational message.
#
emitTestInfoMsg() {
    emitColoredMsg "cyan"  "    $@"
}

#
# Asserting params equals. 
#
assert-equals() {
    if [ "$1" != "$2" ]
    then
        emitTestFailMsg "Tested [$1] != [$2]"

        exit 1
    else
        emitTestPassMsg "Tested [$1] == [$2]"
    fi  
}

#
# Asserting params unequals.  If 3 params are handed in, it is assumed $1 is a message and
# $2 and $3 will be compared.  Otherwise $1 an $2 are compared.
#
assert-not-equals() {
    if [ "$1" = "$2" ]
    then
        emitTestFailMsg "Tested [$1] == [$2]"

        exit 1
    else
        emitTestPassMsg "Tested [$1] != [$2]"
    fi  
}

#
# Asserting param empty or blank. 
#
assert-blank() {
    if [ "$1" = "" ]
    then
        emitTestPassMsg "assert-blank"
    else
        emitTestFailMsg "assert-blank [$1]"

        exit 1
    fi  
}

#
# Asserting param not empty or blank. 
#
assert-not-blank() {
    if [ "$1" = "" ]
    then
        emitTestFailMsg "assert-not-blank [$1]"

        exit 1
    else
        emitTestPassMsg "assert-not-blank"
    fi  
}

#
# Asserting a file exists
#
assert-file-exists() {
    if [ "$1" = "" ]
    then
        emitTestFailMsg "No file presented"

        exit 1
    elif [ -f $1 ]
    then
        emitTestPassMsg "File exists [$1]"
    else
        emitTestFailMsg "File does not exist [$1]"

        exit 1
    fi  
}

#
# Asserting a file exists
#
assert-file-not-exists() {
    if [ "$1" = "" ]
    then
        emitTestFailMsg "No file presented"

        exit 1
    elif [ ! -f $1 ]
    then
        emitTestPassMsg "File does not exist [$1]"
    else
        emitTestFailMsg "File does exist [$1]"

        exit 1
    fi  
}

#
# Will execute whatever is handed in as params.  If a failure arises
# it will exit with a 1, otherwise exits with a 0.  This is ensuring
# the commands are successfully executed.
#
assert-success() {
    RUN=`$*`

    if [ $? -ne 0 ]
    then
        emitTestFailMsg "assert-success [$*]"

        exit 1
    else
        emitTestPassMsg "assert-success [$*]"
    fi
}

#
# Will execute whatever is handed in as params.  If a failure arises
# it will exit with a 0, otherwise exits with a 1.  This is ensuring
# the commands are not successfully executed.
#
assert-failure() {
    RUN=`$*`

    if [ $? -ne 0 ]
    then
        emitTestPassMsg "assert-failure [$*]"
    else
        emitTestFailMsg "assert-failure [$*]"

        exit 1
    fi
}

#
# Called when a unit test finishes.
#
unit-test-setup() {
    noop
}

#
# Called when a unit test ends.
#
unit-test-teardown() {
    noop
}

#
# Run a test
#
unit-test() {
    CURRENT_TEST_DIR=`pwd`

    unit-test-setup

    expected_status=$1
    shift

    emitTestInfoMsg "---------------------------------------------------------"
    emitTestInfoMsg "Executing:  [$*]"
    echo 

    EXECUTING=`$* 1>&2`
    EXIT=$?

    echo

    if [ "${EXIT}" != "${expected_status}" ]
    then
        emitTestFailMsg "UNIT TEST FAIL:  Tested [$1] ... exit status expected = ${expected_status} / actual = ${EXIT}"

        TOTAL_FAILED_TESTS=`expr ${TOTAL_FAILED_TESTS} + 1`
    else
        emitTestPassMsg "UNIT TEST PASS:  Tested [$1]"

        TOTAL_PASSED_TESTS=`expr ${TOTAL_PASSED_TESTS} + 1`
    fi  

    unit-test-teardown

    cd ${CURRENT_TEST_DIR}
}

#
# Run a test expecting a pass.
#
unit-test-should-pass() {
    unit-test 0 $*
}

#
# Run a test expecting a fail
#
unit-test-should-fail() {
    unit-test 1 $*
}

#
# Called when the test suite begins.
#
test-suite-setup() {
    noop
}

#
# Called when the test suite ends.
#
test-suite-teardown() {
    noop
}

#
# Called to define all tests in a suite.
#
run-test-suite() {
    noop
}

#
# Start our test suite.
#
test-suite-start() {
    test-suite-setup

    export TOTAL_FAILED_TESTS=0
    export TOTAL_PASSED_TESTS=0

    echo
    emitTestInfoMsg "TESTING..."
    echo 
}


#
# End our test suite.
#
test-suite-end() {
    test-suite-teardown

    echo
    emitTestInfoMsg "========================================================="
    echo
    emitTestInfoMsg "TEST RESULTS:"
    echo
    emitTestInfoMsg "    Passed = [${TOTAL_PASSED_TESTS}]"
    emitTestInfoMsg "    Failed = [${TOTAL_FAILED_TESTS}]"
    echo

    if [ "${TOTAL_FAILED_TESTS}" != "0" ]
    then
        emitTestInfoMsg "TEST SUITE FAILED!"

        EXIT=1
    else
        emitTestInfoMsg "TEST SUITE PASSED!"

        EXIT=0
    fi

    echo
    emitTestInfoMsg "========================================================="
    echo

    exit ${EXIT}
}