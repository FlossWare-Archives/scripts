# Scripts

Welcome to FlossWare Scripts!  This represents a collection of reusable scripts we hope you will find useful.

## History

This project got its start as a way to provide scripts for Jenkins as part of our [Continuous Delivery] (http://en.wikipedia.org/wiki/Continuous_delivery) initiative.  We currently use an [OpenShift] (https://www.openshift.com) instance of [Jenkins] (https://jenkins-camponotus.rhcloud.com).  We faced challenges publishing artifacts from our [Github Project] (https://github.com/FlossWare/java) to [Bintray] (https://bintray.com/flossware/maven/java/view).  We realized that we needed a repository of reusable scripts (presently bash functions) as well as provide Jenkins and [OpenShift] (https://www.openshift.com) scripts that others can we reuse - ideally side stepping issues we discovered thereby helping folks to get on with "the business at hand."

## Unit Testing

Without a doubt, we discovered writing bash functions was simple - testing them for "the long haul" much more challenging.  Our "knee-jerk" reaction was to write "one off" tests - but that doesn't ensure our quality should we need to make changes.  With that said, we've provide a test harness vary similar in nature to [JUnit] (http://junit.org) in what we call the [test-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/test-utils.sh) framework.  If you are familiar with [JUnit] (http://junit.org) this should "hopefully" be obvious.  We do unit test (or try to) all our functions as can be found [here] (https://github.com/FlossWare/scripts/tree/master/test/bash).

## Good Scripts Tested

We are currently refactoring and unit testing.  Thus far the reliable (aka unit tested) scripts are:
* [common-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/common-utils.sh)
* [github-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/guthub-utils.sh)
* [git-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/git-utils.sh)
* [jenkins-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/jenkins-utils.sh)

While the others have been somewhat manually tested, please assume they are unreliable.

## Plugins

While not yet written, we have a longer term goal of providing some [Jenkins plugins] (https://wiki.jenkins-ci.org/display/JENKINS/Plugins) for things like publishing to [Bintray] (https://bintray.com).  Stay tuned for things to come!