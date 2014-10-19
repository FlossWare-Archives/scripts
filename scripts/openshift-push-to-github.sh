#!/bin/bash

#
# This script will allow one to push out to github.  Since
# Open Shift does not allow direct access to ~/.ssh (as it is
# owned by root), setting up a password-less ssh key is
# challenging - and therefore we must use a different directory
# than ~/.ssh.  Additionally, since Jenkins can clone a git
# repo when building, if it's to be done ssh-less, you will likely
# (for ease of use) clone using the https protocol.
#
# We can change the remote to ssh and push out that way using
# this script.
#
# To use:
#   openshift-git-push-to-git.sh [Some git commit message]
#

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