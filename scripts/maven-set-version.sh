#!/bin/bash

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