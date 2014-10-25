#!/bin/bash

#
# This script will take the pom version and use that as a commit message
# pushing out to github.
#
# To use:
#   openshift-version-change-push-to-github.sh
#

DIR=`dirname $0`

MSG="Jenkins version bump [`${DIR}/maven-get-pom-version.sh pom.xml`]"

${DIR}/openshift-push-to-github.sh ${MSG}