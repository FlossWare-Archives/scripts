# Jenkins

Welcome to the FlossWare Jenkins related functionality.  We currently use an [OpenShift] (https://www.openshift.com) instance of [Jenkins] (https://jenkins-camponotus.rhcloud.com).  As part of this usage we recognized the need for some scripts and later plugins.

## Good Scripts Tested

We are currently refactoring and unit testing.  Thus far the reliable (aka unit tested) scripts are:
* common-utils.sh
* github-utils.sh
* git-utils.sh

While the others have been somewhat manually tested, please assume they are unreliable.

## Scripts

When using our [OpenShift] (https://www.openshift.com) of [Jenkins] (https://jenkins-camponotus.rhcloud.com) we had challenges integrating our [Github Project] (https://github.com/FlossWare/java) with [Bintray] (https://bintray.com/flossware/maven/java/view) artifacts as part of our [Continuous Delivery] (http://en.wikipedia.org/wiki/Continuous_delivery) initiative.  Our scripts are here for all to use and understand in hopes we will help others overcome the hurdles we faced - as well as provide our scripts to those who may benefit from their design.

## Plugins

While not yet written, we have a longer term goal of providing some [Jenkins plugins] (https://wiki.jenkins-ci.org/display/JENKINS/Plugins) for things like publishing to [Bintray] (https://bintray.com).  Stay tuned for things to come!