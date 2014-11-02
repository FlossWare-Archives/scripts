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
# This will set the version on a maven pom.xml and all it's
# child pom.xml's.
#
# You must specify a full path to pom.xml plus pom name.
# For example:
#    maven-set-pom-version.sh 1.0.0
#
# Parameters:
#    1 - the new version number.
#

if [ $# -lt 1 -o $# -gt 2 ]
then
    echo
    echo "ERROR:"
    echo "  Must supply a version parameter."
    echo
    exit 1
fi

mvn -DallowSnaphots=false -DnewVersion="$1" -DgenerateBackupPoms=false versions:set