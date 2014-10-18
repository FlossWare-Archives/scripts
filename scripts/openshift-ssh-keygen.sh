#!/bin/bash

. `dirname $0`/openshift-config.sh

mkdir -p ${OPEN_SHIFT_SSH_DIR}

ssh-keygen -N "" -f ${OPEN_SHIFT_SSH_DIR}/id_rsa