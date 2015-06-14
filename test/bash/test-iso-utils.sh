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

. `dirname ${BASH_SOURCE[0]}`/../../bash/iso-utils.sh
. `dirname ${BASH_SOURCE[0]}`/../../bash/test-utils.sh

#
# Test extracting an ISO
#
test-extract-iso() {
    which genisoimage 2>/dev/null
    if [ $? -ne 0 ]
    then
        warning-msg "No genisoimage - skipping test"
        return
    fi

    EXTRACT_DIR=`mktemp -u` 
    CONTENT_DIR=`mktemp -u`
    ISO_FILE=`mktemp -u`.iso

    mkdir -p ${CONTENT_DIR}
    echo "Hello world" > ${CONTENT_DIR}/testfile.txt

    genisoimage -o ${ISO_FILE} ${CONTENT_DIR}

    assert-failure extractIso &&
    assert-failure extractIso `mktemp -u` &&
    assert-success extractIso ${ISO_FILE} ${EXTRACT_DIR} &&
    assert-file-exists ${EXTRACT_DIR}/testfile.txt &&

    rm -rf ${EXTRACT_DIR} ${CONTENT_DIR} ${ISO_FILE}
}

# ----------------------------------------------------

unit-test-should-pass test-extract-iso

# ----------------------------------------------------