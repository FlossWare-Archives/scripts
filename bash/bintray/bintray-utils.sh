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
DIR=`dirname ${BASH_SOURCE[0]}`

. ${DIR}/../json-utils.sh

#
# Simply emity param usages...
#
bintray-param-usage() {
    echo "`dirname $0` Usage:"
    echo
    echo "  PARAM          DESCRIPTION"
    echo "  -----------    -----------"
    echo "  --help         help!"
    echo "  --user         user name"
    echo "  --key          API key"
    echo "  --account      account name"
    echo "  --repo         repo type - maven, rpm, et"
    echo "  --licenses     the licenses for your bintray packages"
    echo "  --package      package name"
    echo "  --description  description"
    echo "  --name         the name (for package, version, etc)"
    echo "  --version      the version"
    echo "  --file         the file"
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
    export BINTRAY_NAME_JSON=`compute-json-field-if-value-set name ${BINTRAY_NAME}`
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

            --user) shift
                export BINTRAY_USER=$1
                ;;

            --key) shift
                export BINTRAY_KEY=$1
                ;;

            --account) shift
                export BINTRAY_ACCOUNT=$1
                ;;

            --repo) shift
                export BINTRAY_REPO=$1
                ;;

            --package) shift
                export BINTRAY_PACKAGE=$1
                ;;

            --licenses) shift
                export BINTRAY_LICENSES=$1
                ;;

            --description) shift
                export BINTRAY_DESCRIPTION=$1
                ;;

            --version) shift
                export BINTRAY_VERSION=$1
                ;;

            --name) shift
                export BINTRAY_NAME=$1
                ;;

            --file) shift
                export BINTRAY_FILE=$1
                ;;
        esac

        shift
    done

    set-bintray-json-vars
    bintray-debug
}