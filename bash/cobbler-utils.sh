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

    cobbler "$@"

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
            cobbler-exec distro remove --name=${aDistro}

            if [ $? -ne 0 ]
            then
                warning-msg "Trouble removing distro [${aDistro}]"
            fi
    done &&

    cobbler-exec sync
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
# Optional params:
#   $3..$N - any additional cobbler params.
#
distro-add() {
    info-msg "Adding distro [$1]" &&

    ensure-min-params 2 $* &&

    DISTRO_NAME=$1 &&
    shift
    ISO=$1 &&
    shift &&

    MOUNT_PT=`dirname ${ISO}`/${DISTRO_NAME}/ &&

    distro-remove ${DISTRO_NAME} &&

    info-msg "Using dir [${MOUNT_PT}] as the mount point for [${ISO}]" &&

    mountIso ${ISO} ${MOUNT_PT} &&

    info-msg "Attempting to import [${DISTRO_NAME}] from [${MOUNT_PT}]" &&

    cobbler-exec import --name="${DISTRO_NAME}" --path="${MOUNT_PT}" &&

    RETURN_CODE=$? 

    unmount ${MOUNT_PT} 

    rmdir ${MOUNT_PT}

    if [ "${RETURN_CODE}" != "0" ]
    then
        return `expr "${RETURN_CODE}"`
    fi

    cobbler-exec distro edit --name="${DISTRO_NAME}" --ksmeta="tree=http://@@server@@/cblr/links/${DISTRO_NAME}" --kopts=''

    RETURN_CODE=$?

    if [ $# -gt ${RETURN_CODE} ]
    then
        cobbler-exec distro edit --name="${DISTRO_NAME}" --in-place "$@"
        RETURN_CODE=$? 
    fi

    return ${RETURN_CODE}
}

#
# Add an atomic distro
#
# Required params:
#   $1 - the name of the distro.
#   $2 - the fully qualified path and file name of the ISO to import.
#
# Optional params:
#   $3..$N - any additional cobbler params.
#
distro-add-atomic() {
    info-msg "Adding Atomic distro [$1]" &&

    ensure-min-params 2 $* &&

    # ------------------------------------------------

    DISTRO_NAME=$1 &&
    shift
    ISO=$1 &&
    shift &&

    distro-remove ${DISTRO_NAME} &&

    # ------------------------------------------------

    INSTALL_DIR=`dirname ${ISO}`/${DISTRO_NAME} &&

    info-msg "Cleaning up and creating Atomic install dir [${INSTALL_DIR}]" &&

    rm -rf ${INSTALL_DIR} &&

    mkdir -p ${INSTALL_DIR} &&
    cd ${INSTALL_DIR} &&

    # ------------------------------------------------

    #
    # First get the images...
    #
    info-msg "Extracting Atomic images [${DISTRO_NAME}]" &&

    /usr/bin/livecd-iso-to-pxeboot ${ISO} &&

    mkdir -p /var/www/cobbler/ks_mirror/${DISTRO_NAME} &&
    mkdir -p /var/www/cobbler/links &&

    cp ${INSTALL_DIR}/tftpboot/{vmlinuz,initrd.img} /var/www/cobbler/ks_mirror/${DISTRO_NAME} &&

    rm /var/www/cobbler/links/${DISTRO_NAME}

    ln -s /var/www/cobbler/ks_mirror/${DISTRO_NAME} /var/www/cobbler/links/${DISTRO_NAME} &&

    # ------------------------------------------------

    MOUNT_PT=${INSTALL_DIR}/iso &&

    info-msg "Using dir [${MOUNT_PT}] as the mount point for Atomic [${ISO}]" &&

    mountIso ${ISO} ${MOUNT_PT} &&

    info-msg "Attempting to import [${DISTRO_NAME}] from [${MOUNT_PT}]" &&

    cobbler-exec import --name="${DISTRO_NAME}" --path="${MOUNT_PT}"

    # ------------------------------------------------

    info-msg "Adding/editing Atomic distro [${DISTRO_NAME}]" &&

    cobbler-exec distro add  --name="${DISTRO_NAME}" --kernel="/var/www/cobbler/ks_mirror/${DISTRO_NAME}/vmlinuz" --initrd="/var/www/cobbler/ks_mirror/${DISTRO_NAME}/initrd.img" &&
    cobbler-exec distro edit --name="${DISTRO_NAME}" --in-place --ksmeta="tree=http://@@server@@/cblr/links/${DISTRO_NAME}" "$@"

    # ------------------------------------------------

    RETURN_CODE=$? 

    unmount ${MOUNT_PT} 

    rmdir ${MOUNT_PT}

    if [ "${RETURN_CODE}" != "0" ]
    then
        return `expr "${RETURN_CODE}"`
    fi

    if [ $# -gt 0 ]
    then
        cobbler-exec distro edit --name="${DISTRO_NAME}" --in-place "$@"
        RETURN_CODE=$? 
    fi

    cobbler-exec distro edit --name="${DISTRO_NAME}" --in-place --ksmeta="tree=http://@@server@@/cblr/links/${DISTRO_NAME}" 

    return ${RETURN_CODE}

}

#
# Add a REHV distro
#
# Required params:
#   $1 - the name of the distro.
#   $2 - the fully qualified path and file name of the ISO to import.
#
# Optional params:
#   $3..$N - any additional cobbler params.
#
distro-add-rhev() {
    info-msg "Adding RHEV distro [$1]" &&

    ensure-min-params 2 $* &&

    # ------------------------------------------------

    DISTRO_NAME=$1 &&
    shift
    ISO=$1 &&
    shift &&

    distro-remove ${DISTRO_NAME} &&

    # ------------------------------------------------

    INSTALL_DIR=`dirname ${ISO}`/${DISTRO_NAME} &&

    info-msg "Cleaning up and creating RHEV install dir [${INSTALL_DIR}]" &&

    rm -rf ${INSTALL_DIR} &&

    mkdir -p ${INSTALL_DIR} &&
    cd ${INSTALL_DIR} &&

    # ------------------------------------------------

    #
    # First get the images...
    #
    info-msg "Extracting RHEV images [${DISTRO_NAME}]" &&

    /usr/bin/livecd-iso-to-pxeboot ${ISO} &&

    mkdir -p /var/www/cobbler/ks_mirror/${DISTRO_NAME} &&
    mkdir -p /var/www/cobbler/links &&

    cp ${INSTALL_DIR}/tftpboot/{vmlinuz0,initrd0.img} /var/www/cobbler/ks_mirror/${DISTRO_NAME} &&

    rm /var/www/cobbler/links/${DISTRO_NAME}

    ln -s /var/www/cobbler/ks_mirror/${DISTRO_NAME} /var/www/cobbler/links/${DISTRO_NAME} &&

    # ------------------------------------------------

    MOUNT_PT=${INSTALL_DIR}/iso &&

    info-msg "Using dir [${MOUNT_PT}] as the mount point for RHEV [${ISO}]" &&

    mountIso ${ISO} ${MOUNT_PT} &&

    info-msg "Attempting to import [${DISTRO_NAME}] from [${MOUNT_PT}]" &&

    cobbler-exec import --name="${DISTRO_NAME}" --path="${MOUNT_PT}"

    # ------------------------------------------------

    info-msg "Adding/editing RHEV distro [${DISTRO_NAME}]" &&

    cobbler-exec distro add  --name="${DISTRO_NAME}" --kernel="/var/www/cobbler/ks_mirror/${DISTRO_NAME}/vmlinuz0" --initrd="/var/www/cobbler/ks_mirror/${DISTRO_NAME}/initrd0.img" &&
    cobbler-exec distro edit --name="${DISTRO_NAME}" --in-place --ksmeta="tree=http://@@server@@/cblr/links/${DISTRO_NAME}" "$@"

    # ------------------------------------------------

    RETURN_CODE=$? 

    unmount ${MOUNT_PT} 

    rmdir ${MOUNT_PT}

    if [ "${RETURN_CODE}" != "0" ]
    then
        return `expr "${RETURN_CODE}"`
    fi

    if [ $# -gt 0 ]
    then
        cobbler-exec distro edit --name="${DISTRO_NAME}" --in-place "$@"
        RETURN_CODE=$? 
    fi

    cobbler-exec distro edit --name="${DISTRO_NAME}" --in-place --ksmeta="tree=http://@@server@@/cblr/links/${DISTRO_NAME}" 

    return ${RETURN_CODE}

}

#
# Add a live distro
#
# Required params:
#   $1 - the name of the distro.
#   $2 - the fully qualified path and file name of the ISO to import.
#
# Optional params:
#   $3..$N - any additional cobbler params.
#
distro-add-live() {
    info-msg "Adding live distro [$1]" &&

    ensure-min-params 2 $* &&

    # ------------------------------------------------

    DISTRO_NAME=$1 &&
    shift
    ISO=$1 &&
    shift &&

    distro-remove ${DISTRO_NAME} &&

    # ------------------------------------------------

    INSTALL_DIR=`dirname ${ISO}`/${DISTRO_NAME} &&

    info-msg "Cleaning up and creating Live install dir [${INSTALL_DIR}]" &&

    rm -rf ${INSTALL_DIR} &&

    mkdir -p ${INSTALL_DIR} &&
    cd ${INSTALL_DIR} &&

    # ------------------------------------------------

    #
    # First get the images...
    #
    info-msg "Extracting Live images [${DISTRO_NAME}]" &&

    /usr/bin/livecd-iso-to-pxeboot ${ISO} &&

    mkdir -p /var/www/cobbler/ks_mirror/${DISTRO_NAME} &&

    cp ${INSTALL_DIR}/tftpboot/{vmlinuz0,initrd0.img} /var/www/cobbler/ks_mirror/${DISTRO_NAME} &&

    rm /var/www/cobbler/links/${DISTRO_NAME}

    ln -s /var/www/cobbler/ks_mirror/${DISTRO_NAME} /var/www/cobbler/links/${DISTRO_NAME} &&

    # ------------------------------------------------

    info-msg "Adding/editing Live distro [${DISTRO_NAME}]" &&

    cobbler-exec distro add  --name="${DISTRO_NAME}" --kernel="/var/www/cobbler/ks_mirror/${DISTRO_NAME}/vmlinuz0" --initrd="/var/www/cobbler/ks_mirror/${DISTRO_NAME}/initrd0.img" &&
    cobbler-exec distro edit --name="${DISTRO_NAME}" --in-place --kopts="rootflags=loop !ksdevice !text root=live:/`basename ${ISO}` rootfstype=iso9660 !lang"

    # ------------------------------------------------

    RETURN_CODE=$? 

    return ${RETURN_CODE}

}

# -----------------------------------------------------------------------------------

#
# List repos.
#
repo-list() {
    cobbler repo list
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
        cobbler-exec repo remove --name="${aRepo}"

        if [ $? -ne 0 ]
        then
            warning-msg "Trouble removing repo [${aRepo}]"
        fi
    done &&

    cobbler-exec sync
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
        cobbler-exec profile remove --name=${aProfile}

        if [ $? -ne 0 ]
        then
            warning-msg "Trouble removing profile [${aProfile}]"
        fi
    done &&

    cobbler-exec sync
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
        cobbler-exec system remove --name="${aSystem}"

        if [ $? -ne 0 ]
        then
            warning-msg "Trouble removing system [${aSystem}]"
        fi

    done &&

    cobbler-exec sync
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

    cobbler-exec buildiso --systems="${SYSTEMS}"

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