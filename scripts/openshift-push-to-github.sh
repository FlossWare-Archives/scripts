#!/bin/bash

ensureMessage() {
    if [ $# -lt 1 ]
    then
        echo
        echo "ERROR:"
        echo "  Must enter command line parameters that represent a git commit message"
        echo
        exit 1
    fi
}

ensureMessage $*

DIR=`dirname $0`

. ${DIR}/openshift-config.sh

export GIT_SSH=${DIR}/openshift-git-push.sh

${DIR}/rename-github-remote.sh

git commit -am "$*"

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

git push origin ${CURRENT_BRANCH}