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
# Computes all the RPM files for a dsitribution as CSV output...
#

RPMS=`yum list | cut -f 1 -d ' '`

echo "\"version\"","\"rpm\"","\"file\"","\"basename\""

for anRPM in $RPMS
do
    allFiles=`rpm -q --filesbypkg file $anRPM | cut -f 2- -d '/'`

    if [ $? -ne 0 ]
    then
        continue
    fi

    for aFile in ${allFiles}
    do
        realFile="/${aFile}"
        baseFile=`basename ${realFile}`

        echo "\"$1\"","\"${anRPM}\"","\"${realFile}\"","\"${baseFile}\""
    done
done