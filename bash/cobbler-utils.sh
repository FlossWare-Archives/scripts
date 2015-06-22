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
    ensure-min-params 1 $* &&

    info-msg "Removing distros [$*]" &&

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
    DISTROS=`distro-list` &&
    if [ "${DISTROS}" == '' ]
    then
        warning-msg "No distros found to remove!" &&

        return
    fi &&

    distro-remove "${DISTROS}"
}

#
# Add a distroy (imports its ISO).
#
# Required params:
#   $1 - the name of the distro.
#   $2 - the fully qualified path and file name of the ISO to import.
#   $3 - the fully qualified path where to extract the contents of the ISO for import.
#
distro-add() {
    ensure-total-params 3 $* &&
    extractIso $2 $3 &&

    distro-remove $1 &&

    info-msg "Attempting to import [$1]" &&

    cobbler import --name="$1" --path="$3"
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
#   $2 - architecture.
#   $3 - the URL
#
repo-add() {
    ensure-total-params 3 $* &&

    info-msg "Adding repo [$1]" &&

    cobbler repo add --name="$1" --arch="$2" --mirror="$3"

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
    ensure-min-params 1 $* &&

    info-msg "Removing repos [$*]" &&

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
    if [ "${REPOS}" == '' ]
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
# Add a profile
#
# Required params:
#   $1 - the name of the profile
#   $2 - the distro
#
# Optional params:
#   $3 - the repos
#   $4 - ths kickstart
#   $5 - the ksmeta data
#   $6 - the kopts
#
profile-add() {
    ensure-min-params 2 $1 $2 $3 $4 $5 $6 &&

    info-msg "Attempting to add profile [$1]" &&

    case $# in
        6) cobbler profile add --name="$1" --distro="$2" --repos="$3" --kickstart="$4" --ksmeta="$5" --kopts="$6"
            ;;
        5) cobbler profile add --name="$1" --distro="$2" --repos="$3" --kickstart="$4" --ksmeta="$5"
            ;;
        4) cobbler profile add --name="$1" --distro="$2" --repos="$3" --kickstart="$4"
            ;;
        3) cobbler profile add --name="$1" --distro="$2" --repos="$3"
            ;;
        *) cobbler profile add --name="$1" --distro="$2"
            ;;
    esac

    if [ $? -ne 0 ]
    then
        warning-msg "Trouble adding profile [$1]"
    fi
}

#
# Remove profiles
#
# Required params:
#   $1..$N - the profiles to remove
#
profile-remove() {
    ensure-min-params 1 $* &&

    info-msg "Removing profiles [$*]" &&

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
    if [ "${PROFILES}" == '' ]
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
# Add a system
#
# Required params:
#   $1 - the name of the system
#   $2 - the profile
#
# Optional params:
#   $3 - the mac address
#   $4 - the interface
#   $5 - the ksmeta data
#   $6 - ths kickstart
#
system-add() {
    ensure-min-params 2 $1 $2 &&

    info-msg "Attempting to add system [$1]" &&

    case $# in
        6) cobbler system add --name="$1" --profile="$2" --mac="$3" --interface="$4" --ksmeta="$5" --kickstart="$6"
            ;;
        5) cobbler system add --name="$1" --profile="$2" --mac="$3" --interface="$4" --ksmeta="$5"
            ;;
        4) cobbler system add --name="$1" --profile="$2" --mac="$3" --interface="$4"
            ;;
        3) cobbler system add --name="$1" --profile="$2" --mac="$3"
            ;;
        *) cobbler system add --name="$1" --profile="$2"
            ;;
    esac

    if [ $? -ne 0 ]
    then
        warning-msg "Troubling adding system [$1]"
    fi
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
    if [ "${SYSTEMS}" == '' ]
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

