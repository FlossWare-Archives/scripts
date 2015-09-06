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
# Cobbler utilities
#

# -----------------------------------------------------------------------------------

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh
. `dirname ${BASH_SOURCE[0]}`/iso-utils.sh

# -----------------------------------------------------------------------------------

#
# Kick off a cobbler command.
#
cobbler-exec() {
    info-msg "Executing:  cobbler [$*]" &&

    ensure-min-params 1 $* &&

    cobbler $* &&

    RETURN_CODE=$? &&

    if [ ${RETURN_CODE} -ne 0 ]
    then
        warning-msg "Trouble executing [${RETURN_CODE}]:  cobbler [$*]"
    fi &&

    return ${RETURN_CODE}
}

#
# List all distros
#
distro-list() {
    cobbler distro list
}

#
# Remove specific distros.
#
# Required params:
#   $1..$N - distro names.
#
distro-remove() {
    info-msg "Removing distros [$*]" &&

    ensure-min-params 1 $* &&

    for aDistro in $*
    do
            cobbler distro remove --name=${aDistro}

            if [ $? -ne 0 ]
            then
                warning-msg "Trouble removing distro [${aDistro}]"
            fi
    done &&

    cobbler sync
}

#
# Remove all distros.
#
distro-remove-all() {
    DISTROS=`distro-list | tr -s '\n' ' '` &&
    if [ "${DISTROS}" == "" ]
    then
        warning-msg "No distros found to remove!" &&

        return
    fi &&

    distro-remove "${DISTROS}"
}

#
# Add a distro (imports its ISO).
#
# Required params:
#   $1 - the name of the distro.
#   $2 - the fully qualified path and file name of the ISO to import.
#
distro-add() {
    info-msg "Adding distro [$1]" &&

    ensure-total-params 2 $* &&

    MOUNT_PT=`dirname $2`/$1/ &&

    distro-remove $1 &&

    info-msg "Using dir [${MOUNT_PT}] as the mount point for [$2]" &&

    mountIso $2 ${MOUNT_PT} &&

    info-msg "Attempting to import [$1] from [${MOUNT_PT}]" &&

    cobbler import --name="$1" --path="${MOUNT_PT}"

    RETURN_CODE=$?

    unmount ${MOUNT_PT} 

    rmdir ${MOUNT_PT}

    return ${RETURN_CODE}
}

#
# Add a "live" distro (imports its ISO).
#
# Required params:
#   $1 - the name of the distro.
#   $2 - the fully qualified path and file name of the ISO to import.
#
distro-add-live() {
    ensure-total-params 2 $* &&

    KERNEL="/var/www/cobbler/ks_mirror/$1/isolinux/vmlinuz" &&
    INITRD="/var/www/cobbler/ks_mirror/$1/isolinux/initrd.img" &&

    distro-add $1 $2 || info-msg "Imported - adding distro [$1]"  &&

    cobbler distro add --name="$1" --kernel="${KERNEL}" --initrd="${INITRD}" --kopts="root=live:http://`hostname`/cobbler/ks_mirror/$1/LiveOS/squashfs.img" && info-msg "Added distro [$1]"
}

# -----------------------------------------------------------------------------------

#
# List repos.
#
repo-list() {
    cobbler repo list
}

#
# Add a repo.
#
# Required params:
#   $1 - the name of the repo.
#   $2 - the URL
#
repo-add() {
    info-msg "Adding repo [$1]" &&

    ensure-total-params 2 $* &&

    cobbler repo add --name="$1" --mirror="$2" --mirror-locally="0"

    if [ $? -ne 0 ]
    then
        warning-msg "Trouble adding repo [$1]"
    fi
}

#
# Remove repos.
#
# Required params:
#   $1..$N - the repos to remove
#
repo-remove() {
    info-msg "Removing repos [$*]" &&

    ensure-min-params 1 $* &&

    for aRepo in $*
    do
        cobbler repo remove --name="${aRepo}"

        if [ $? -ne 0 ]
        then
            warning-msg "Trouble removing repo [${aRepo}]"
        fi
    done &&

    cobbler sync
}

#
# Remove all repos
#
repo-remove-all() {
    REPOS=`repo-list` &&
    if [ "${REPOS}" == "" ]
    then
        warning-msg "No repos found to remove!" &&

        return
    fi &&

    repo-remove ${REPOS}
}

# -----------------------------------------------------------------------------------

#
# List profiles.
#
profile-list() {
    cobbler profile list
}

#
# Remove profiles
#
# Required params:
#   $1..$N - the profiles to remove
#
profile-remove() {
    info-msg "Removing profiles [$*]" &&

    ensure-min-params 1 $* &&

    for aProfile in $*
    do
        cobbler profile remove --name=${aProfile}

        if [ $? -ne 0 ]
        then
            warning-msg "Trouble removing profile [${aProfile}]"
        fi
    done &&

    cobbler sync
}

#
# Remove all profiles
#
profile-remove-all() {
    PROFILES=`profile-list` &&
    if [ "${PROFILES}" == "" ]
    then
        warning-msg "No profiles found to remove!" &&

        return
    fi &&

    profile-remove ${PROFILES}
}

# -----------------------------------------------------------------------------------

#
# List systems
#
system-list() {
    cobbler system list
}

#
# Remove systems
#
# Required params:
#   $1..$N - the systems to remove
#
system-remove() {
    ensure-min-params 1 $* &&

    info-msg "Removing systems [$*]" &&

    for aSystem in $*
    do
        cobbler system remove --name="${aSystem}"

        if [ $? -ne 0 ]
        then
            warning-msg "Trouble removing system [${aSystem}]"
        fi

    done &&

    cobbler sync
}

#
# Remove all systems
#
system-remove-all() {
    SYSTEMS=`system-list` &&
    if [ "${SYSTEMS}" == "" ]
    then
        warning-msg "No systems found to remove!" &&

        return
    fi &&

    system-remove ${SYSTEMS}
}

#
# Create an ISO of systems
#
# Optional params:
#   $1..$N - the system names to include in the ISO.
#
#
system-create-iso() {
    if [ $# -lt 1 ]
    then
        RAW_SYSTEMS="`system-list`"
    else
        RAW_SYSTEMS="$*"
    fi &&

    SYSTEMS="`echo ${RAW_SYSTEMS} | tr -s ' ' ','`" &&

    info-msg "Attempting to create an ISO using systems [${SYSTEMS}]" &&

    cobbler buildiso --systems="${SYSTEMS}"

    if [ $? -ne 0 ]
    then
        warning-msg "Trouble creating systems [${SYSTEMS}]"
    fi
}

# -----------------------------------------------------------------------------------

#
# Remove exverything.
#
remove-all() {
    ensure-total-params 0 &&

    info-msg "Removing everything" &&

    system-remove-all &&
    profile-remove-all &&
    repo-remove-all &&
    distro-remove-all 
}

# -----------------------------------------------------------------------------------

