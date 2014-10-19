#!/bin/bash

DIR=`dirname $0`

. ${DIR}/maven-compute-version-parts.sh $*

if [ $? -ne 0 ]
then
    ${DIR}/maven-compute-version-parts.sh $*

    exit $?
fi

NEW_MAVEN_RELEASE_VERSION=`${DIR}/increment-value.sh ${MAVEN_RELEASE_VERSION}`

${DIR}/maven-set-version.sh "${MAVEN_MAJOR_VERSION}.${MAVEN_MINOR_VERSION}.${NEW_MAVEN_RELEASE_VERSION}" $*