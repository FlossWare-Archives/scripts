#!/bin/bash

DIR=`dirname $0`

. ${DIR}/maven-compute-version-parts.sh $*

if [ $? -ne 0 ]
then
    ${DIR}/maven-compute-version-parts.sh $*

    exit $?
fi

NEW_MAVEN_MAJOR_VERSION=`${DIR}/increment-value.sh ${MAVEN_MAJOR_VERSION}`

${DIR}/maven-set-version.sh "${NEW_MAVEN_MAJOR_VERSION}.0.0" $*