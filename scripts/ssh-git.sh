#!/bin/sh 

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