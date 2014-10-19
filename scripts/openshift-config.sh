#!/bin/bash

#
# For Open Shift work, this will setup configuration.
#
# To use:
#  . openshift-config.sh
#

export PATH=`dirname $0`:${PATH}

export OPEN_SHIFT_SSH_DIR=${HOME}/app-root/runtime/.ssh