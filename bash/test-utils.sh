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

DIR=`dirname ${BASH_SOURCE[0]}`

#
# Asserting params equals. 
#
assert-equals() {
    if [ "$1" != "$2" ]
    then
        echo "    FAIL:  Tested [$1] != [$2]"

        exit 1
    else
        echo "    PASS:  Tested [$1] == [$2]"
    fi  
}

#
# Asserting params unequals.  If 3 params are handed in, it is assumed $1 is a message and
# $2 and $3 will be compared.  Otherwise $1 an $2 are compared.
#
assert-not-equals() {
    if [ "$1" = "$2" ]
    then
        echo "    FAIL:  Tested [$1] == [$2]"

        exit 1
    else
        echo "    PASS:  Tested [$1] != [$2]"
    fi  
}

#
# Asserting param empty or blank. 
#
assert-blank() {
    if [ "$1" = "" ]
    then
        echo "    PASS:  assert-blank"
    else
        echo "    FAIL:  assert-blank [$1]"

        exit 1
    fi  
}

#
# Asserting param not empty or blank. 
#
assert-not-blank() {
    if [ "$1" = "" ]
    then
        echo "    FAIL:  assert-not-blank [$1]"

        exit 1
    else
        echo "    PASS:  assert-not-blank"
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
        echo "    FAIL:  assert-success [$*]"

        exit 1
    else
        echo "    PASS:  assert-success [$*]"
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
        echo "    PASS:  assert-failure [$*]"
    else
        echo "    FAIL:  assert-failure [$*]"

        exit 1
    fi
}

#
# Run a test
#
unit-test() {
    expected_status=$1
    shift

    echo "---------------------------------------------------------"
    echo "Executing:  [$*]"
    echo 

    EXECUTING=`$* 1>&2`
    EXIT=$?

    echo

    if [ "${EXIT}" != "${expected_status}" ]
    then
        echo "UNIT TEST FAIL:  Tested [$1] ... exit status expected = ${expected_status} / actual = ${EXIT}"

        TOTAL_FAILED_TESTS=`expr ${TOTAL_FAILED_TESTS} + 1`
    else
        echo "UNIT TEST PASS:  Tested [$1]"

        TOTAL_PASSED_TESTS=`expr ${TOTAL_PASSED_TESTS} + 1`
    fi  
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
# Start our test suite.
#
test-suite-start() {
    export TOTAL_FAILED_TESTS=0
    export TOTAL_PASSED_TESTS=0

    echo
    echo "TESTING..."
    echo 
}


#
# End our test suite.
#
test-suite-end() {
    echo
    echo "========================================================="
    echo
    echo "TEST RESULTS:"
    echo
    echo "    Passed = [${TOTAL_PASSED_TESTS}]"
    echo "    Failed = [${TOTAL_FAILED_TESTS}]"
    echo

    if [ "${TOTAL_FAILED_TESTS}" != "0" ]
    then
        echo "TEST SUITE FAILED!"

        EXIT=1
    else
        echo "TEST SUITE PASSED!"

        EXIT=0
    fi

    echo
    echo "========================================================="
    echo

    $*

    exit ${EXIT}
}