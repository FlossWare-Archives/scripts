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

. `dirname ${BASH_SOURCE[0]}`/../../bash/json-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/test-utils.sh

#
# Test computing a JSON field
#
test-compute-json-field() {
    assert-equals "\"\" : \"\"" "`compute-json-field`" &&
    assert-equals "\"Foo\" : \"\"" "`compute-json-field Foo`" &&
    assert-equals "\"\" : \"Bar\"" "`compute-json-field "" Bar`"  &&
    assert-equals "\"Alpha\" : \"Beta\"" "`compute-json-field Alpha Beta`" 
}

#
# Test computing a JSON field if we have a value
#
test-compute-json-field-if-value-set() {
    assert-equals "" "`compute-json-field-if-value-set`" &&
    assert-equals "" "`compute-json-field-if-value-set 1Hello`" &&
    assert-equals "" "`compute-json-field-if-value-set 1GoodBye ""`" &&
    assert-equals "\"1Hello\" : \"1World\"" "`compute-json-field-if-value-set 1Hello 1World`" &&
    assert-equals "\"1Hello\" : \"1World Is near\"" "`compute-json-field-if-value-set 1Hello 1World Is near`"
}

#
# Test computing a JSON a array if we have a value.
#
test-compute-json-array-field-if-value-set() {
    assert-equals "" "`compute-json-array-field-if-value-set`" &&
    assert-equals "" "`compute-json-array-field-if-value-set 2Hello`" &&
    assert-equals "" "`compute-json-array-field-if-value-set 2GoodBye ""`" &&
    assert-equals "\"2Hello\" : [\"2World\", \"2aWorld\", \"2bWorld\"]" "`compute-json-array-field-if-value-set 2Hello 2World 2aWorld 2bWorld`" 
}

#
# Test separating JSON fields with 
#
test-separate-json-fields-with-commas() {
     assert-equals "" "`separate-json-fields-with-commas`" &&
     TEST1=`separate-json-fields-with-commas \"foo\" : \"bar\"` &&
     assert-equals "\"foo\" : \"bar\"" "${TEST1}" &&
     TEST2=`separate-json-fields-with-commas \"foo\":\"bar\"` &&
     assert-equals "\"foo\":\"bar\"" "${TEST2}" &&
     TEST3=`separate-json-fields-with-commas "\"foo1\" : \"bar1\"" "\"alpha\" : \"beta\""` &&
     assert-equals "\"foo1\" : \"bar1\" , \"alpha\" : \"beta\"" "${TEST3}"
}

test-compute-json-object() {
     assert-equals "{  }" "`compute-json-object`" &&
     TEST1=`compute-json-object \"foo\" : \"bar\"` &&
     assert-equals "{ \"foo\" : \"bar\" }" "${TEST1}" &&
     TEST2=`compute-json-object \"foo\":\"bar\"` &&
     assert-equals "{ \"foo\":\"bar\" }" "${TEST2}" &&
     TEST3=`compute-json-object "\"foo1\" : \"bar1\"" "\"alpha\" : \"beta\""` &&
     assert-equals "{ \"foo1\" : \"bar1\" , \"alpha\" : \"beta\" }" "${TEST3}"
}

# ----------------------------------------------------

unit-test-should-pass test-compute-json-field
unit-test-should-pass test-compute-json-field-if-value-set
unit-test-should-pass test-compute-json-array-field-if-value-set
unit-test-should-pass test-separate-json-fields-with-commas
unit-test-should-pass test-compute-json-object

# ----------------------------------------------------