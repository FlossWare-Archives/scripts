#!/bin/bash

#
# This will parse out a maven pom.xml's version element.
#
# You must specify a full path to pom.xml plus pom name.
# For example:
#    maven-get-pom-version.sh /home/sfloess/project/pom.xml
#

ensureParam() {
    if [ $# -lt 1 -o $# -gt 1 ]
    then
        echo
        echo "ERROR"
        echo "  Please provide a lone parameter that denotes the"
        echo "  maven pom file!"
        echo
        echo "Example:"
        echo "  `dirname $0`/$0 /var/lib/openshift/540b2c664382ec0a4f000622/app-root/data/workspace/FlossWare/pom.xml"
        echo
        exit 1
    fi
}

ensureFileExists() {
    if [ ! -f $1 ]
    then
        echo
        echo "ERROR"
        echo "  The file [$1] does not exist!"
        echo
        exit 1
    fi
}

ensureParam $@
ensureFileExists $@

echo 'xpath /* [local-name()="project"]/* [local-name()="version"]/text()' | xmllint --shell $1 | grep content | cut -f 2 -d '='