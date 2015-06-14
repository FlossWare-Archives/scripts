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
# ISO utilities
#

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh

#
# Extract an ISO
#
# Required params:
#   $1 - the fully qualified path and file name of the ISO to extract
#   $2 - the directory where to copy all extracted files
#
extractIso() {
    ensure-total-params 2 $* &&
    ensure-file-exists $1 &&

	isoName=`basename $1` &&
	isoDir=/tmp/iso/${isoName} &&

	remove-dir-if-exists ${isoDir} &&
	mkdir -p ${isoDir} $2 &&

	sudo mount $1 ${isoDir} -t iso9660 -o loop &&
	rsync -av ${isoDir}/* $2 &&
	sudo umount ${isoDir} &&

	rmdir ${isoDir}
}