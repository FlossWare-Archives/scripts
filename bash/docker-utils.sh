#!/bin/bash

#
# This file is part of the FlossWare family of open source software.
#
# FlossWare is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
#

# -----------------------------------------------------------------------------------

. `dirname ${BASH_SOURCE[0]}`/common-utils.sh

# -----------------------------------------------------------------------------------

#
# List the tags for a repo...
#
# Required params:
#   $1 - the URL of the repository.
#   $2 - the name of the repository.
#
docker-list-tags() {
    ensure-min-params 1 $* &&

    info-msg "Listing tags for [$2] at registry [$1]" &&

    curl -X GET $1/v1/repositories/$2/tags | python -mjson.tool | grep '"' | cut -f 2 -d '"'
}

#
# Delete a tag
#
# Required params:
#   1 - the registry URL.
#   2 - the name of the registry.
#   3 - the tag.
#
docker-delete-tag() {
    ensure-min-params 3 $* &&

    info-msg "Deleting tag [$3] for [$2] at registry [$1]" &&

    curl -X DELETE $1/v1/repositories/$2/tags/$3
}

#
# Delete tags...
#
# Required params:
#   1 - the registry URL.
#   2 - the name of the registry.
#
docker-delete-tags() {
    ensure-min-params 2 $* &&

    allTags=`docker-list-tags $1 $2` &&

    info-msg "Deleting tags [${allTags}]" &&

    for aTag in ${allTags}
    do
        docker-delete-tag $1 $2 ${aTag}
    done
}

#
# Build the docker image...  Its assumed you are standing in the directory
# where the Dockerfile is located.
#
# Required params:
#   1 - The directory containing the Dockerfile
#   2 - The registry
#   3 - the tag
#
docker-build-image() {
    ensure-min-params 3 $* &&
    ensure-dir-exists $1 &&
    ensure-file-exists $1/Dockerfile &&

    SUDO=`getSudo` &&

    info-msg "Building docker image [$3] and pushing to registry [$2]" &&

    ${SUDO} docker build --no-cache=true -t "$3" $1 &&

    ${SUDO} docker tag -f $3 $2/$3 &&
    ${SUDO} docker push $2/$3 &&

    info-msg "Building Dockerfile in [$1] using tag [$3] and pushing to [$2]" &&

    ${SUDO} docker rmi -f $3
}

#
# Update a docker file with the correct RPMs...  We are assuming
# you have CD'd to the dir containging the dockerfile.
#
# Required params:
#   1 - the directory containing the Dockerfile
#   2 - the RPMS
#
docker-update-dockerfile() {
    ensure-min-params 2 $* &&
    ensure-dir-exists $1 &&
    ensure-file-exists $1/Dockerfile &&

    TMP_FILE=`mktemp -u`.dockerfile &&

    info-msg "Updating [$1/Dockerfile] and storing in [${TMP_FILE}]" &&

    cat $1/Dockerfile | sed -e "s/.*RUN yum install.*/RUN yum install -y $2 \&\& yum clean all/g" > ${TMP_FILE} &&

    info-msg "Updated [${TMP_FILE}] - moving back to [$1/Dockerfile]" &&

    mv ${TMP_FILE}$1/Dockerfile 
}
