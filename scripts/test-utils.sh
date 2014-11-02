#!/bin/bash

DIR=`dirname $0`

. ${DIR}/utils.sh
. ${DIR}/bintray-utils.sh
. ${DIR}/json-utils.sh

set-bintray-vars $*

#separate-with-commas $*

#compute-json-field hello "good bye cruel world"

field1='"name" : "foo bar world"'
field2='"alpha" : "And beta man"'
field3='"beta" : "Son of a gun man"'
field4='"beta" : ["Son of a gun man"]'
field5='"zeta" : ["Son of a gun man", "blah blah"]'

echo
separate-json-fields-with-commas ${field1} ${filrdx} ${field5}      ${field2} ${field4}    ${field3}

echo
compute-json-object ${field1} ${filrdx} ${field5}      ${field2} ${field4}    ${field3}

echo
convert-to-csv 123 GPL-3.0 456 789