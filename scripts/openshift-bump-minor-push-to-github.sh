#!/bin/bash

#
# This script will allow one to push out to bump a minor version and
# push that out to github.
#
# To use:
#   openshift-git-bump-minor-push-to-github.sh [initial branch to rev]
#

if [ $# -lt 1 ]
then
    echo
    echo "ERROR:"
    echo "   Please provide the branch in which to bump the minor version"
    echo
    exit 1
fi

DIR=`dirname $0`

git checkout $1

${DIR}/maven-bump-minor.sh $PWD/pom.xml

git checkout -b `${DIR}/maven-get-pom-version.sh pom.xml`

${DIR}/openshift-version-change-push-to-github.sh