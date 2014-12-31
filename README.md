# Scripts

Welcome to FlossWare Scripts!  This represents a collection of reusable scripts we hope you will find useful.

## History

This project got its start as a way to provide scripts for [Jenkins] (http://jenkins-ci.org) as part of our [Continuous Delivery] (http://en.wikipedia.org/wiki/Continuous_delivery) initiative.  We currently use an [OpenShift] (https://www.openshift.com) instance of [Jenkins] (https://jenkins-camponotus.rhcloud.com) and faced challenges publishing artifacts from our [Github Project] (https://github.com/FlossWare/java) to [Bintray] (https://bintray.com/flossware/maven/java/view).  We realized that we needed a repository of reusable scripts (presently bash functions) as well as provide [Jenkins] (http://jenkins-ci.org) and [OpenShift] (https://www.openshift.com) scripts that others can we reuse - ideally side stepping issues we discovered thereby helping folks to get on with "the business at hand."

## Conventions

### Directories

The following represents our directory structure:
* `bash` - bash utility scripts and some non 
* `bash/bintray` - Bintray related scripts for creating, listing, publishing and deleting artifacts.
* `bash/continuous-delivery` - continuous delivery related scripts.  Presently only "short cuts" for preparing [Maven] (http://maven.apache.org) and RPM artifacts for release.
* `bash/openshift` - OpenShift related scripts that can help with rev'ing artifact versions, pushing out artifacts to Bintray, Github, Bitbucket, etc.
* `test/bash` - contains our unit tests (and test suite) for the `bash` utility scripts.

### Naming

#### Scripts

Scripts are named using lower case words separated by dashes (like `git-utils.sh`).  All utility scripts end in `-utils.sh` (like `common-utils.sh`).

#### Functions

We are somewhat inconsistent in our naming of functions.  Initially we started using all lower case dash separated words (like `generate-unique`).  However, we'd like to standardize upon lower camel (like `getBackground`) per [Issue #48] (https://github.com/FlossWare/scripts/issues/48).

## Functionality

### Continuous Delivery

For us, continuous delivery relates to utilizing:
* a source control system, such as [Git] (http://git-scm.com).
* a build system such as [Jenkins] (http://jenkins-ci.org).
* a resultant artifact repository such as [Bintray] (https://bintray.com).

In reality we are providing the "delivery team," "version control" and "build & unit test" portion of the [Continuous Delivery] (http://en.wikipedia.org/wiki/Continuous_delivery) process as follows:
* A developer works on a feature (likely in a branch) and when the feature is completed, merges the feature in and makes it available.  In [Git] (http://git-scm.com), it'd be equivalent to pushing master out to remote as in:  `git push origin master`
* [Jenkins] (http://jenkins-ci.org) monitors the source control system and performs the following when a change is observed:
  * Retrieves the latest version of the code base.
  * Revs the appropriate versioning file.  For [Maven] (http://maven.apache.org) that's the `pom.xml` and for RPM's, that's a spec file.  More about respective versioning can be found below.
  * Build the source and "do the needful."  This is the portion that you will be responsible to provide - this may include invoking [Maven] (http://maven.apache.org) and instructing it to run all tests or how to build using an RPM spec file.  More about building will be found below.
  * Commit the versioning file (now containing a rev'd version).  For spec files, automatic logs of changes since the last rev are included in the `%changelog` section.`
  * Publish an artifact to a consumable repository such as [Bintray] (https://bintray.com).

If you are using [Jenkins] (http://jenkins-ci.org) at [OpenShift] (https://www.openshift.com), we provide the necessary plumbing so your work can be rev'd and pushed back out to [GitHub] (https://github.com/) or [Bintray] (https://bintray.com).  Please note, we are assuming [Jenkins] (http://jenkins-ci.org) at [OpenShift] (https://www.openshift.com) and [Git] (http://git-scm.com) below.  One can easily adapt our work to other [CI] (http://en.wikipedia.org/wiki/Continuous_integration) environments or non [OpenShift] (https://www.openshift.com).

#### Jenkins

##### Configuration

As mentioned above, we use [Jenkins] (http://jenkins-ci.org).  There is a "gotcha" you need to recognize:  [Jenkins] (http://jenkins-ci.org) not only builds, it is managing versioned files (like `pom.xml` or a spec file), but it is also publishing those changes back to a remote [Git] (http://git-scm.com) repository.  Therefore, when it builds, you need to instruct [Jenkins] (http://jenkins-ci.org) to exclude changes from itself.  If you do not, it will rev, commit, build checking repeat over and over again.  To stop this, you must configure as follows:
* Install the [Git Plugin] (https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin) if not already installed.
* Click on the Jenkins link (upper left) / Manage Jenkins / Configure System.
* Navigate to the "Git plugin" section and provide values for "Global Config user.name Value" and "Global Config user.email Value."  We opted to name our user name "jenkins"
* Click the "Save" button.
* For your [Jenkins] (http://jenkins-ci.org) job, choose it and click configure.  Navigate down to the "Source Code Management" section for [Git] (http://git-scm.com).
* Add an "Additional Behaviour" - specifically "Polling ignores commits from certain users."  For the "Excluded Users" enter the name of the [Jenkins] (http://jenkins-ci.org) user you configured above for "Global Config user.name Value"
* Click the "Save" button.

##### FlossWare Scripts Job

We presently do not yet have the capability to RPM-ify our scripts (this will be resolved in [Issue #30] (https://github.com/FlossWare/scripts/issues/30)).  However, in [OpenShift] (https://www.openshift.com), we won't be able to install any RPM we generate and have to, instead, have a [Jenkins] (http://jenkins-ci.org) job that monitors our [Scripts Git Repo] (https://github.com/FlossWare/scripts.git) for changes to the master branch.  Our job is entitled `Flossware-scripts` and it can be utilized by other jobs refering to the scripts in the form of `$WORKSPACE/../FlossWare-scripts/bash`.  Below you will see how we execute the [FlossWare Scripts] (https://github.com/FlossWare/scripts).

Additionally, you may want to consider installing the [Build Blocker Plugin] (https://wiki.jenkins-ci.org/display/JENKINS/Build+Blocker+Plugin) and block any of your jobs from building if a build of [FlossWare Scripts] (https://github.com/FlossWare/scripts) is executing.  Please note, a build of [FlossWare Scripts] (https://github.com/FlossWare/scripts) may be misleading - we simply need the job to update (aka checkout the latest) when there are changes to the scripts.

##### OpenShift

If you use a [Git] (http://git-scm.com) hosting service such as [GitHub] (https://github.com/), the [Jenkins] (http://jenkins-ci.org) `~/.ssh` directory is inaccessible as it's owned by root.  If you want [Jenkins] (http://jenkins-ci.org) to affect change to your versioning files (`pom.xml` or spec file), you will need a way to provide an `SSH key` so commits can be automatically propogated back out.  Presently we are defaulting to an `.ssh` directory in `${HOME}/app-root/runtime/.ssh`.  Additionally, we've provided the script `bash/openshift/openshift-keygen.sh` that will create the aforementioned directory and setup a passwordless `SSH key`.  You can then add the public key `${HOME}/app-root/runtime/.ssh/id_rsa.pub` to your [Git] (http://git-scm.com) hosting service.

The [OpenShift] (https://www.openshift.com) script `bash/openshift/openshift-push-to-gitrepo.sh` will ensure that the `${HOME}/app-root/runtime/.ssh/id_rsa.pub` is used.

##### Bintray

Below we denote examples that indirectly call out to [Bintray] (https://bintray.com) to publish artifacts.  Two notable examples are:
* [maven-publish.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/maven-publish.sh)
* [rpm-publish.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/rpm-publish.sh)

These two scripts reside with the other [Bintray] (https://bintray.com) scripts and honor the same command line parameters.  More information can be found below in the Bintray.

#### Maven

##### Pre Build

For a `pom.xml`, versioning increments the third digit of an assumed three digit versioning scheme as denoted in the `version` element (namely incrementing `Release`):  `Major.Minor.Release`.  As an exmaple:

```xml
  <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<groupId>org.flossware</groupId>
	<artifactId>scripts-test-maven</artifactId>
	<version>1.0.3</version>
```

Once incremented, the version will next be `1.0.4` as seen below:

```xml
  <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<groupId>org.flossware</groupId>
	<artifactId>scripts-test-maven</artifactId>
	<version>1.0.4</version>
```

Once incremented, a tag is generated from the current `pom.xml` version and a comment is added to [Git] (http://git-scm.com).  For [Jenkins] (http://jenkins-ci.org), add an "Execute Shell" command before any [Maven] (http://maven.apache.org) invocation line as follows:

```bash
cd $WORKSPACE &&
$WORKSPACE/../FlossWare-scripts/bash/continuous-delivery/prepare-maven-git-release.sh
```

##### Post Build

After your [Maven] (http://maven.apache.org) invocation line (something akin to "Invoke top-level Maven targets" within the "Build" section of your job), you will want to have an "Execute Shell" command like:

```bash
cd $WORKSPACE &&
$WORKSPACE/../FlossWare-scripts/bash/openshift/openshift-push-to-gitrepo.sh
```

Should you use an artifact hosting service such as [Bintray] (https://bintray.com), you will want to do something similar to the following:

```bash
cd $WORKSPACE &&
$WORKSPACE/../FlossWare-scripts/bash/openshift/openshift-push-to-gitrepo.sh &&
$WORKSPACE/../FlossWare-scripts/bash/bintray/maven-publish.sh --bintrayUser someUser --bintrayKey abcdefghijklmnopqrstuvwxyz0123456789ABCD --bintrayAccount someAccount --bintrayPackage somePackage
```

The line `$WORKSPACE/../FlossWare-scripts/bash/openshift/openshift-push-to-gitrepo.sh` will commit and tag your `pom.xml` and push it out to either [GitHub] (https://github.com/) or [Bitbucket] (https://bitbucket.org/).

Please note, supply the appropriate values to the `maven-publish.sh` script based upon your account.

#### RPM

##### Pre Build

For a spec file, versioning increments the `Release` section of the file (as in `Release: xyz`).  As an example:

```spec
Summary: A set of scripts to help aid in Salesforce.com development and deployment
Name: flosswareScriptsTest
Version: 1.0
Release: 1
```

Once incremented, the release will be 2, as can be seen below:

```spec
Summary: A set of scripts to help aid in Salesforce.com development and deployment
Name: flosswareScriptsTest
Version: 1.0
Release: 2
```

Once incremented, a tag is generated from the spec file (using the `Version` dash `Release`) and a comment is added to [Git] (http://git-scm.com).  For [Jenkins] (http://jenkins-ci.org), add an "Execute Shell" command before any statements you use to build your RPM as follows:


```bash
cd $WORKSPACE &&
$WORKSPACE/../FlossWare-scripts/bash/continuous-delivery/prepare-rpm-git-release.sh /path/to/your/file.spec
```

##### Post Build

After your RPM building invocation line, you will want to have an "Execute Shell" command like:

```bash
cd $WORKSPACE &&
$WORKSPACE/../FlossWare-scripts/bash/openshift/openshift-push-to-gitrepo.sh
```
Should you use an artifact hosting service such as [Bintray] (https://bintray.com), you will want to do something similar to the following:

```bash
cd $WORKSPACE &&
$WORKSPACE/../FlossWare-scripts/bash/openshift/openshift-push-to-gitrepo.sh &&
$WORKSPACE/../FlossWare-scripts/bash/bintray/rpm-publish.sh --bintrayUser someUser --bintrayKey abcdefghijklmnopqrstuvwxyz0123456789ABCD --bintrayAccount someAccount --bintrayRepo someRepo --bintrayPackage somePackage --bintrayFile /path/to/the.rpm --bintrayContext /path/to/the.specFile
```

The line `$WORKSPACE/../FlossWare-scripts/bash/openshift/openshift-push-to-gitrepo.sh` will commit and tag your spec file and push it out to either [GitHub] (https://github.com/) or [Bitbucket] (https://bitbucket.org/).  All git commit messages since the last tag will be included in the `%changelog` section.

As an example:

```spec
%changelog
* Mon Dec 29 2014 OpenShift <jenkins@jenkins-camponotus.rhcloud.com> 1.0-2
- Fixed the null pointer.
* Sun Dec 28 2014 OpenShift <jenkins@jenkins-camponotus.rhcloud.com> 1.0-1
- Broke the build.
```

Please note, supply the appropriate values to the `rpm-publish.sh` script based upon your [Bintray] (https://bintray.com) account.

##### All in One Build

You can just lump everything together to pre build, create the rpm and publish like so (using the above as an example):

```bash
cd $WORKSPACE &&
$WORKSPACE/../FlossWare-scripts/bash/continuous-delivery/prepare-rpm-git-release.sh /path/to/your/file.spec &&
$WORKSPACE/someScriptToCreateYourRpm.sh &&
$WORKSPACE/../FlossWare-scripts/bash/openshift/openshift-push-to-gitrepo.sh &&
$WORKSPACE/../FlossWare-scripts/bash/bintray/rpm-publish.sh --bintrayUser someUser --bintrayKey abcdefghijklmnopqrstuvwxyz0123456789ABCD --bintrayAccount someAccount --bintrayRepo someRepo --bintrayPackage somePackage --bintrayFile /path/to/the.rpm --bintrayContext /path/to/the.specFile
```

### Bintray

We've include a number of scripts to simplify interacting with the [Bintray API] (https://bintray.com/docs/api).  While the API is fairly easy, we wanted a simple and consistent command line way to create, list and delete artifacts.  While not all command line parameters are used in each script, the following bulleted list denotes the supported command line options (some familiarity with [Bintray] (https://bintray.com) may make the command line parameters more obvious):
* `--bintrayUser` - your user name.
* `--bintrayKey` - your API key.
* `--bintrayAccount` - your account name.
* `--bintrayRepo` - the repo type like maven, rpm, etc.
* `--bintrayLicenses` - for now, a single entry license name you use when creating a package.  For example GPL-3.0.
* `--bintrayPackage` - the package name.
* `--bintrayDescription` - a description like a package description.
* `--bintrayVersion` - a version of an artifact.
* `--bintrayFile` - the actual local artifact you will publish.
* `--bintrayContext` - this is a [FlossWare Scripts] (https://github.com/FlossWare/scripts) specific item and it denotes the context in which you are working.  For example, if you are publishing RPMs, its the spec file used to build the RPM or a `pom.xml`.

Any of the scripts support the `--help` command line argument which will emit the aforementioned names and descriptions to the console.

#### Scripts

Our scripts are divided into utilities and commands.  The commands perform an action but those actions may require related functionality which is encapsulated in utilties.  For example. the two version commands [version-create.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/version-create.sh) and [version-delete.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/version-delete.sh) both require a repo, package and version to work correctly.  This functionality is encapsulated in the [version-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/bintray-version-util.sh) script.

All commands require the following parameters:  `--bintrayUser`, `--bintrayKey` and `--bintrayAccount`.

##### Package

The package scripts allow you to create, delete and list your [Bintray] (https://bintray.com) packages.  The required package parameters are:  `--bintrayRepo` and `--bintrayPackage`.
* [package-create.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/package-create.sh) will create packages.  Required parameter:  `--bintrayLicenses`.
* [package-delete.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/package-delete.sh) will delete packages. 
* [package-list.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/package-delete.sh) will list packages.  

##### Version

The version scripts allow you to create and delete your [Bintray] (https://bintray.com) versions.  The required version parameters are:  `--bintrayRepo`,  `--bintrayPackage` and `--bintrayVersion`.
* [version-create.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/version-create.sh) will create versions.  
* [version-delete.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/version-delete.sh) will delete versions.

##### Content

The content scripts allow you to create and publish your [Bintray] (https://bintray.com) content.  The required content parameters are: `--bintrayRepo`,  `--bintrayPackage` and `--bintrayVersion`.
* [conent-create.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/content-create.sh) will create content.  
* [content-publish.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/content-publish.sh) will publish content.

##### Publishing

The publishing scripts allow you to publish your Maven and RPM [Bintray] (https://bintray.com) content.
* [maven-publish.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/maven-publish.sh) will publish Java artifacts based upon the version contained within the `pom.xml`.
* [rpm-publish.sh] (https://github.com/FlossWare/scripts/blob/master/bash/bintray/rpm-publish.sh) will create and publish RPM content.  Required parameter:  `bintrayContext`.


### Unit Testing

Without a doubt, we discovered writing bash functions was simple - testing them for "the long haul" much more challenging.  Our "knee-jerk" reaction was to write "one off" tests - but that doesn't ensure our quality should we need to make changes.  With that said, we've provide a test harness vary similar in nature to [JUnit] (http://junit.org) in what we call the [test-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/test-utils.sh) framework.  If you are familiar with [JUnit] (http://junit.org) this should "hopefully" be obvious.  We do unit test (or try to) all our functions as can be found [here] (https://github.com/FlossWare/scripts/tree/master/test/bash).

#### How To

This section is a work in progress.  Please stay tuned.

#### Covered Code

The following unit tests have high test coverage:
* [common-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/common-utils.sh)
* [gitrepo-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/guthub-utils.sh)
* [git-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/git-utils.sh)
* [jenkins-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/jenkins-utils.sh)
* [json-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/json-utils.sh)
* [maven-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/maven-utils.sh)
* [rpm-utils.sh] (https://github.com/FlossWare/scripts/blob/master/bash/rpm-utils.sh)



### Miscellaneous

### Plugins

While not yet written, we have a longer term goal of providing some [Jenkins plugins] (https://wiki.jenkins-ci.org/display/JENKINS/Plugins) for things like publishing to [Bintray] (https://bintray.com).  Stay tuned for things to come!
