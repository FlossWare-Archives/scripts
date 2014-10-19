#!/bin/bash

#
# This will the minor version in a maven pom in the format
# of major.minor.release.
#
# You must specify a full path to pom.xml plus pom name.
# For example:
#    maven-bump-minor.sh /home/sfloess/project/pom.xml
#
# Please note this affects the pom.xml and any child pom.xml's.
#

DIR=`dirname $0`

. ${DIR}/maven-compute-version-parts.sh $*

if [ $? -ne 0 ]
then
    ${DIR}/maven-compute-version-parts.sh $*

    exit $?
fi

NEW_MAVEN_MINOR_VERSION=`${DIR}/increment-value.sh ${MAVEN_MINOR_VERSION}`

${DIR}/maven-set-version.sh "${MAVEN_MAJOR_VERSION}.${NEW_MAVEN_MINOR_VERSION}.0" $*