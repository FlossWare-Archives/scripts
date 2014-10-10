#!/bin/bash

ensureProtocol() {
    PROTOCOL=`echo $1 | cut -f 1 -d ':'`

    if [ "${PROTOCOL}" != "https" ]
    then
        echo
        echo "ERROR!"
        echo "  Incorrect protocol [${PROTOCOL}] for remote [${REMOTE}]"
        echo
        exit 1
    fi
}

REMOTE=`git remote -v | grep push | sed -e 's/origin//' -e 's/ (push)//' -e 's/\t//'`

ensureProtocol ${REMOTE}

NEW_REMOTE=`echo ${REMOTE} | sed -e 's/https:\/\/github.com\//git@github.com:/'`

git remote remove origin
git remote add origin ${NEW_REMOTE}