#!/bin/bash

#
# This will change the the remote protocol from https to git
# for github.
#
# For example should you clone a github repo using the https
# protocol, you get a push ref similar to https://github.com/FlossWare/java.git
#
# This script will change it to something similar to:
#  git@github.com:FlossWare/java.git
#
 
ensureProtocol() {
    PROTOCOL=`echo $1 | cut -f 1 -d ':'`

    if [ "${PROTOCOL}" != "https" ]
    then
        echo
        echo "ERROR!"
        echo "  Incorrect protocol [${PROTOCOL}] for remote [${REMOTE}]"
        echo
        exit
    fi
}

REMOTE=`git remote -v | grep push | sed -e 's/origin//' -e 's/ (push)//' -e 's/\t//'`

ensureProtocol ${REMOTE}

NEW_REMOTE=`echo ${REMOTE} | sed -e 's/https:\/\/github.com\//git@github.com:/'`

git remote remove origin
git remote add origin ${NEW_REMOTE}