#!/bin/sh 

#
# Open Shift does not allow one to affect the ~/.ssh directory.  So,
# for example, one cannot create ssh passwordless keys.  This is
# particularly challenging if you want Jenkins to make changes and
# commit/push-out those changes.  By using this script in conjunction
# with GIT_SSH, you can overcome some of these challenges.  You must
# specify the directory where your ssh keys reside.
#
# To use:
#  ssh-git.sh [directory to your ssh keys] [git params]
#
# Review openshift-push-to-github.sh to see how to incorporate this
# script and GIT_SSH.
#

ensureParams() {
    if [ $# -lt 2 ]
    then
        echo
        echo "ERROR"
        echo "  Need at least two parameters.  The first should be the location of the"
        echo "  to the identity file"
        echo
        echo "Example:"
        echo "  `dirname $0`/$0 /var/lib/openshift/540b2c664382ec0a4f000622/jenkins/.ssh/id_rsa [remainder of params]"
        echo
        exit 1
    fi
}

ensureIdentityFile() {
    if [ ! -f $1 ]
    then
        echo
        echo "ERROR"
        echo "  Identify file [$1] does not exist!"
        echo
        exit 1
    fi
}

# Check we have some params...
ensureParams $@

IDENTITY_FILE=$1
shift

# Make sure we have the identify file...
ensureIdentityFile ${IDENTITY_FILE}

# Call out and do the needful.
exec ssh -i ${IDENTITY_FILE} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$@"