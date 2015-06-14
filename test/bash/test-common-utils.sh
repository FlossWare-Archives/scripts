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
# Tests the common-utils.sh scripts
#

. `dirname ${BASH_SOURCE[0]}`/../../bash/common-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/test-utils.sh

#
# Test computing default values
#
test-compute-default-value() {
    assert-equals "`compute-default-value 0 ""`" 0 &&
    assert-equals "`compute-default-value 1 2`" 2 &&
    assert-equals "`compute-default-value 3`" 3 &&

    assert-not-equals "`compute-default-value 4 5`" 4 &&
    assert-not-blank `compute-default-value 6`
}

#
# Test total params
#
test-ensure-total-params() {
    assert-success ensure-total-params &&
    assert-success ensure-total-params 1 x &&
    assert-success ensure-total-params 3 p d q &&
    assert-failure ensure-total-params 0 zz &&
    assert-failure ensure-total-params 1 aa bb
}

#
# Test min params
#
test-ensure-min-params() {
    assert-success ensure-min-params &&
    assert-success ensure-min-params 1 x &&
    assert-success ensure-min-params 2 p d q &&
    assert-failure ensure-min-params 2 zz &&
    assert-failure ensure-min-params 3 aa bb
}

#
# Test max params
#
test-ensure-max-params() {
    assert-success ensure-max-params &&
    assert-success ensure-max-params 1 x &&
    assert-success ensure-max-params 3 d q &&
    assert-failure ensure-max-params 1 xx zz &&
    assert-failure ensure-max-params 2 xx yy zz &&
    assert-failure ensure-max-params 3 uu rr aa bb
}

#
# Test a file exists.
#
test-ensure-file-exists() {
    TEST_FILE=`mktemp`

    assert-success ensure-file-exists ${TEST_FILE} &&
    rm ${TEST_FILE} &&
    assert-failure ensure-file-exists `mktemp -u`
}

#
# Test a dir exists.
#
test-ensure-dir-exists() {
    TEST_DIR=`mktemp -u`
    mkdir -p ${TEST_DIR}

    assert-success ensure-dir-exists ${TEST_DIR} &&
    rmdir ${TEST_DIR} &&
    assert-failure ensure-dir-exists `mktemp -u`
}

#
# Test a dir exists.
#
test-remove-dir-if-exists() {
    TEST_DIR=`mktemp -u`
    mkdir -p ${TEST_DIR}

    assert-failure remove-dir-if-exists &&
    assert-success remove-dir-if-exists ${TEST_DIR} &&
    assert-success remove-dir-if-exists `mktemp -u`
}

#
# Test separating with commas
#
test-separate-with-commas() {
    assert-blank `separate-with-commas` &&
    assert-equals `separate-with-commas 22` 22 &&
    assert-equals `separate-with-commas 33 44` "33,44" &&
    assert-equals `separate-with-commas 55 667 898` "55,667,898"
}

#
# Test converting to a dashed list
#
test-convert-to-dashed-list() {
    INITIAL=`echo -e "hello\nBAR"`
    ACTUAL=`convert-to-dashed-list "${INITIAL}"`
    EXPECTED=`echo -e "- hello\n- BAR"`

    assert-equals "${EXPECTED}" "${ACTUAL}"
}

#
# Test converting to a dashed list
#
test-convert-to-csv() {
    assert-blank `convert-to-csv` &&
    assert-equals "`convert-to-csv 1`" "\"1\"" &&
    assert-equals "`convert-to-csv 2a 33`" "\"2a\", \"33\"" &&
    assert-equals "`convert-to-csv 444 5555 66666`" "\"444\", \"5555\", \"66666\"" &&
    assert-equals "`convert-to-csv Hello World`" "\"Hello\", \"World\"" &&
    assert-equals "`convert-to-csv Hello1 World2`" "\"Hello1\", \"World2\"" &&
    assert-equals "`convert-to-csv Hello-1 W-orld2`" "\"Hello-1\", \"W-orld2\""
}

#
# Test incrementing values
#
test-increment-value() {
    assert-equals "`increment-value 3`" "4" &&
    assert-equals "`increment-value -100`" "-99"
}

#
# Test decrementing values
#
test-decrement-value() {
    assert-equals "`decrement-value 3`" "2" &&
    assert-equals "`decrement-value -100`" "-101"
}

#
# Test generating a unique value
#
test-generate-unique() {
    assert-not-blank `generate-unique`
    assert-not-blank "Hello`generate-unique`"
    assert-not-blank "`generate-unique`World"
    assert-not-blank "HELLO`generate-unique`World"
}

#
# Test keeping newlines preserved
#
test-execute-with-newlines-preserved() {
    EXPECTED=`echo -e "Hello\nWorld\nToday"`
    ACTUAL=`execute-with-newlines-preserved echo -e "Hello\nWorld\nToday"`

    assert-equals "${EXPECTED}" "${ACTUAL}"

}

# ----------------------------------------------------

unit-test-should-pass emit-msg Testing 1
unit-test-should-fail error-msg Testing 2
unit-test-should-pass warning-msg Testing 3
unit-test-should-pass info-msg Testing 4

unit-test-should-pass test-compute-default-value

unit-test-should-pass test-ensure-total-params

unit-test-should-pass test-ensure-min-params

unit-test-should-pass test-ensure-max-params

unit-test-should-pass test-ensure-max-params

unit-test-should-pass test-ensure-file-exists

unit-test-should-pass test-ensure-dir-exists

unit-test-should-pass test-remove-dir-if-exists

unit-test-should-pass test-separate-with-commas

unit-test-should-pass test-convert-to-dashed-list

unit-test-should-pass test-convert-to-csv

unit-test-should-pass test-increment-value

unit-test-should-pass test-decrement-value

unit-test-should-pass test-generate-unique

unit-test-should-pass test-execute-with-newlines-preserved

# ----------------------------------------------------