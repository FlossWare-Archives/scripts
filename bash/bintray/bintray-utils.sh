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
# Bintray utility functions...
#

#
# Convenience configurtions...
#
USER_BINTRAY_CONFIG=${HOME}/.bintray/config

if [ -e "${USER_BINTRAY_CONFIG}" ]
then
    echo "Setting properties from USER_BINTRAY_CONFIG [${USER_BINTRAY_CONFIG}]"

    . ${USER_BINTRAY_CONFIG}
fi

if [ "${BINTRAY_CONFIG}" != "" -a -e "${BINTRAY_CONFIG}" ]
then
    echo "Setting properties from BINTRAY_CONFIG [${BINTRAY_CONFIG}]"
    . ${BINTRAY_CONFIG}
fi

#
# Need some json utility functionality...
#
. `dirname ${BASH_SOURCE[0]}`/../json-utils.sh

#
# Simply emity param usages...
#
bintray-param-usage() {
    echo "`dirname $0` Usage:"
    echo
    echo "  PARAM                 DESCRIPTION"
    echo "  --------------------  -----------"
    echo "  --help                help!"
    echo "  --bintrayUser         user name"
    echo "  --bintrayKey          API key"
    echo "  --bintrayAccount      account name"
    echo "  --bintrayRepo         repo type - maven, rpm, et"
    echo "  --bintrayLicenses     the licenses for your bintray packages"
    echo "  --bintrayPackage      package name"
    echo "  --bintrayDescription  description"
    echo "  --bintrayVersion      the version"
    echo "  --bintrayFile         the file"
    echo "  --bintrayContext      the context file in which --file is being pushed (for example a spec file)"
}

#
# If BINTRAY_DEBUG is set, output data
#
bintray-debug() {
    if [ "${BINTRAY_DEBUG}" != "" ]
    then
        echo
        echo "Variables:"
        echo "    BINTRAY_USER         [${BINTRAY_USER}]"
        echo "    BINTRAY_KEY          [${BINTRAY_KEY}]"
        echo "    BINTRAY_ACCOUNT      [${BINTRAY_ACCOUNT}]"
        echo "    BINTRAY_REPO         [${BINTRAY_REPO}]"
        echo "    BINTRAY_PACKAGE      [${BINTRAY_PACKAGE}]"
        echo "    BINTRAY_LICENSES     [${BINTRAY_LICENSES}]"
        echo "    BINTRAY_DESCRIPTION  [${BINTRAY_DESCRIPTION}]"
        echo "    BINTRAY_VERSION      [${BINTRAY_VERSION}]"
        echo "    BINTRAY_FILE         [${BINTRAY_FILE}]"
        echo "    BINTRAY_CONTEXT      [${BINTRAY_CONTEXT}]"
        echo
        echo "    SONATYPE_USER        [${SONATYPE_USER}]"
        echo "    SONATYPE_PASWORD     [${SONATYPE_PASWORD}]"
        echo
        echo "JSON:"
        echo "    BINTRAY_LICENSES_JSON    -> ${BINTRAY_LICENSES_JSON}"
        echo "    BINTRAY_DESCRIPTION_JSON -> ${BINTRAY_DESCRIPTION_JSON}"  
        echo "    BINTRAY_NAME_JSON        -> ${BINTRAY_NAME_JSON}"  
        echo
        echo "    SONATYPE_USER_JSON       -> ${SONATYPE_USER_JSON}"
        echo "    SONATYPE_PASSWORD_JSON   -> ${SONATYPE_PASSWORD_JSON}"
        echo
    fi
}

#
# Set JSON from environment vars
#
set-bintray-json-vars() {
    export BINTRAY_LICENSES_JSON=`compute-json-array-field-if-value-set licenses ${BINTRAY_LICENSES}`
    export BINTRAY_DESCRIPTION_JSON=`compute-json-field-if-value-set desc ${BINTRAY_DESCRIPTION}`
    export BINTRAY_PACKAGE_JSON=`compute-json-field-if-value-set name ${BINTRAY_PACKAGE}`
    export BINTRAY_VERSION_JSON=`compute-json-field-if-value-set name ${BINTRAY_VERSION}`
    export SONATYPE_USER_JSON=`compute-json-field-if-value-set username ${SONATYPE_USER}`
    export SONATYPE_PASSWORD_JSON=`compute-json-field-if-value-set password ${SONATYPE_PASSWORD}`
}

#
# Set params...
#
set-bintray-vars() {
    while [ $# -gt 0 ]
    do
        case $1 in
            --help) bintray-param-usage
                exit 0
                ;;

            --bintrayUser) shift
                export BINTRAY_USER=$1
                ;;

            --bintrayKey) shift
                export BINTRAY_KEY=$1
                ;;

            --bintrayAccount) shift
                export BINTRAY_ACCOUNT=$1
                ;;

            --bintrayRepo) shift
                export BINTRAY_REPO=$1
                ;;

            --bintrayPackage) shift
                export BINTRAY_PACKAGE=$1
                ;;

            --bintrayLicenses) shift
                export BINTRAY_LICENSES=$1
                ;;

            --bintrayDescription) shift
                export BINTRAY_DESCRIPTION=$1
                ;;

            --bintrayVersion) shift
                export BINTRAY_VERSION=$1
                ;;

            --bintrayName) shift
                export BINTRAY_NAME=$1
                ;;

            --bintrayFile) shift
                export BINTRAY_FILE=$1
                ;;

            --bintrayContext) shift
                export BINTRAY_CONTEXT=$1
                ;;
        esac

        shift
    done

    set-bintray-json-vars
    bintray-debug
}

#
# Ensure the data is correct.
#
ensureBintrayData() {
    if [ "${BINTRAY_USER}" = "" ]
    then
        echo "Please provide user param [--bintrayUser]!"
        exit 1
    fi

    if [ "${BINTRAY_KEY}" = "" ]
    then
        echo "Please provide key param [--bintrayKey]!"
        exit 1
    fi

    if [ "${BINTRAY_ACCOUNT}" = "" ]
    then
        echo "Please provide account param [--bintrayAccount]!"
        exit 1
    fi
}