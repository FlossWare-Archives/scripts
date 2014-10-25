#!/bin/bash

#
# This script will allow one to push out to bump a release version and
# push that out to github.
#
# To use:
#   openshift-git-bump-release-push-to-github.sh
#

DIR=`dirname $0`

${DIR}/maven-bump-release.sh $PWD/pom.xml
${DIR}/openshift-version-change-push-to-github.sh