#!/bin/bash

DIR=`dirname $0`

. ${DIR}/maven-compute-version-parts.sh $*

if [ $? -ne 0 ]
then
    ${DIR}/maven-compute-version-parts.sh $*

    exit $?
fi

NEW_MAVEN_MINOR_VERSION=`${DIR}/increment-value.sh ${MAVEN_MINOR_VERSION}`

${DIR}/maven-set-version.sh "${MAVEN_MAJOR_VERSION}.${NEW_MAVEN_MINOR_VERSION}.0" $*