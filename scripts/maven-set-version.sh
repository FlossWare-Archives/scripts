#!/bin/bash

#
# This will set the version on a maven pom.xml and all it's
# child pom.xml's.
#
# You must specify a full path to pom.xml plus pom name.
# For example:
#    maven-set-pom-version.sh 1.0.0 /home/sfloess/project/pom.xml
#
# Parameters:
#    1 - the new version number.
#    2 - the full directory plus pom.xml
#

if [ $# -lt 1 -o $# -gt 2 ]
then
    echo
    echo "ERROR:"
    echo "  Must supply two parameters.  The first is the version, the second is the pom.xml to change"
    echo
    exit 1
fi

POM_DIR=`dirname $2`

cd ${POM_DIR}

mvn -DallowSnaphots=false -DnewVersion="$1" -DgenerateBackupPoms=false versions:set