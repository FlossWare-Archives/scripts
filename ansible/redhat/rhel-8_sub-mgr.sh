#!/bin/bash

subscription-manager attach --pool=8a85f98156fed8130156ffeb6a535687

subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms

