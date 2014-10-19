#!/bin/bash

#
# This will create an passwordless ssh key and store it in
# the directory denoted by the environment variable OPEN_SHIFT_SSH_DIR
# defined in the openshift-config.sh script.
#
# To use:
#  open-shift-ssh-keygen.sh
#

. `dirname $0`/openshift-config.sh

mkdir -p ${OPEN_SHIFT_SSH_DIR}

ssh-keygen -N "" -f ${OPEN_SHIFT_SSH_DIR}/id_rsa