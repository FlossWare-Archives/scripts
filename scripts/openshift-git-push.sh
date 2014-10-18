#!/bin/bash

DIR=`dirname $0`

. ${DIR}/openshift-config.sh

${DIR}/ssh-git.sh ${OPEN_SHIFT_SSH_DIR}/id_rsa $@