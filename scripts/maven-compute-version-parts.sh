#!/bin/bash

DIR=`dirname $0`

MAVEN_VERSION=`${DIR}/maven-get-pom-version.sh $*`

if [ $? -ne 0 ]
then
    ${DIR}/maven-get-pom-version.sh $*

    exit $?
fi

TOTAL_DOTS=`echo "${MAVEN_VERSION}" | grep -o "\." | wc -l`

#
# We can try to get each field - but if the version is "2"
# all the major, minor and release will all be 2
#
MAVEN_MAJOR_VERSION=`echo ${MAVEN_VERSION} | cut -f 1 -d '.'`
MAVEN_MINOR_VERSION=`echo ${MAVEN_VERSION} | cut -f 2 -d '.'`
MAVEN_RELEASE_VERSION=`echo ${MAVEN_VERSION} | cut -f 3 -d '.'`

#
# If all we had was a 2 for version, then this will ensure
# we have have 0 for minor and 0 for release
#
if [ "${TOTAL_DOTS}" -lt 1 ]
then
    MAVEN_MINOR_VERSION="0"
    MAVEN_RELEASE_VERSION="0"
elif [ "${TOTAL_DOTS}" -lt 2 ]
then
    #
    # If we had 2.1 then release would be empty string
    #
    MAVEN_RELEASE_VERSION="0"
fi

#
# Below we want to ensure we didnt get a
# version like "..." or ".." or "."
#
if [ "${MAVEN_MAJOR_VERSION}" = "" ]
then
    MAVEN_MAJOR_VERSION="0"
fi

if [ "${MAVEN_MINOR_VERSION}" = "" ]
then
    MAVEN_MINOR_VERSION="0"
fi

if [ "${MAVEN_RELEASE_VERSION}" = "" ]
then
    MAVEN_RELEASE_VERSION="0"
fi
