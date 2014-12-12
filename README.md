sobula
======
[![Build Status](https://travis-ci.org/oehme/sobula.svg?branch=master)](https://travis-ci.org/oehme/sobula)

Gradle plugins to automate the build and release of Java projects.

Example usage
-------------

Add the required information to your build script. See the description below for more details.

```groovy
plugins {
	id 'java'
	id 'com.github.oehme.sobula.bintray-release' version '0.4.0'
}

group = "my.group.id"
description = "My really cool project"

contacts {
	"me@mysite.org" {
		moniker "My Name"
		roles "owner"
		github "myGithubUsername"
	}
}

bintray.user = "myBintrayUsernam"
bintray.pkg.version.mavenCentralSync.user = "mySonatypeUsername"


//your build logic here...
```

When you are ready to release, run

```gradle release -PreleaseVersion="1.0" -PbintrayApiKey="myBintrayApiKey" -PsigningPassword="totallySecret" -PsonatypePassword="mySonatypePassword"```

The ```release``` Plugin
------------------

This plugin provides the basic infrastructure for releasing Java projects with a pom.xml descriptor.
It does not make assumptions about your specific release process, but enhances the project with useful capabilities:

- a "release" lifecycle task is added
- a default publication called mavenNebula is added
- a javadoc and sources jar is created and added to that publication
- you can specify the project's version from the command line via the ```releaseVersion``` property
- if possible, the POM is automatically populated to meet Maven Central standards
	- the license is inferred from the LICENSE file in your project root directory
	- the developers section is inferred from the contacts plugin
	- the URL/SCM/Issues information is inferred if there is a contact with the "owner" role that also has a github username specified 
	(this may change in the future and instead be derived from the repository information directly)

The ```bintray-release``` Plugin
--------------------------

This plugin takes an oppinionated approach to releasing to Bintray first, then optionally to Maven Central.

- it configures the bintray package/version information automatically
- requires the ```bintrayUsername``` and ```bintrayApiKey``` properties
- by default uses artifact signing on Bintray 
	- requires your key to be uploaded to Bintray
	- if your key is encrypted (it really should be!), requires the ```signingPassword``` property
	- can be switched off with ```bintray.pkg.version.gpg.sign = false```
- by default uses Maven Central sync from Bintray
	- requires the ```sonatypeUsername``` and ```sonatypePassword``` properties
	- can be switched off with ```bintray.pkg.version.mavenCentralSync.sync = false```


The ```plugin-release``` Plugin
-------------------------

Used for releasing gradle plugins. Applies the ```bintray-release``` plugin. On top of that it sets the
```gradle-plugin``` attribute on the bintray publication. It searches for plugin definitions in all subprojects
of the current project.

The ```stefan``` Plugin
-----------------

This is just a convenience for myself. It fills in all the usernames and marks me as the project owner.

How I do releases
-----------------

I build my projects on travis-ci.org. I have set it up so it will publish a release whenever a tag is pushed.
This is what's needed for that to work:

I enter the required passwords as environment variables like ```ORG_GRADLE_PROJECT_bintrayApiKey=myApiKey```.

My travis script calls out to a simple shell script which checks if the current build is a tag and calls ```gradle release``` in that case.

```yml
language: java
script: ./gradlew check && ./.travis/releaseOnTag.sh
```

```bash
#!/bin/bash
set -ev
if [ -n "${TRAVIS_TAG}" ]; then
  ./gradlew release "-PreleaseVersion=${TRAVIS_TAG}"
fi
```