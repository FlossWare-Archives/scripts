#!/bin/bash

#
# Open Shift does not allow us to affect change to
# ~/.ssh as this directory is owned by root.
#
# We will use a different directory for ssh identities
# and must denote this using the ssh-git.sh script.
#
# To use:
#   openshift-git-push.sh [remote] [branch]
#

DIR=`dirname $0`

. ${DIR}/openshift-config.sh

${DIR}/ssh-git.sh ${OPEN_SHIFT_SSH_DIR}/id_rsa $@