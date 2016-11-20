# Crosswalk Fork for Medic Mobile

This is the parent project for Medic Mobile's fork of [Crosswalk](http://crosswalk-project.org/).

## What have we changed

By default, Chrome, Chromium and Crosswalk limit the maximum space that IndexedDB can use to 10% of available disk space.  Our fork of Crosswalk aims to remove this restriction.

To deactivate the storage limit, use the `--unlimited-storage` command-line flag.  On android, this can be activated by adding the flag to `src/main/assets/xwalk-command-line`.  E.g.:

	xwalk --unlimited-storage --enable-logging --v=1 --enable-logging=stderr --show-fps-panel

## What do we build?

	xwalk_core_library.aar

## How do we use it?

To include this custom `.aar` file in our projects, we use the following gradle configuration:

	repositories {
		maven { url 'https://medic.github.io/crosswalk-build/maven/' }
	}

	dependencies {
		compile 'org.medicmobile.crosswalk:xwalk_core_library:x.y.z'
	}

## How do we build it?

For details of building this code, see the repo at https://github.com/medic/crosswalk-build.

## How do we deploy it?

We serve a simple maven repository from the github-pages URL of this repository.  The repo address is https://medic.github.io/crosswalk-chromium/maven.  To upload your build to this repo, first build the `aar` file (as per the instructions below), and then:

	make release TARGET_VERSION=x.y.z


# Building

## Prerequisites

See https://crosswalk-project.org/contribute/building_crosswalk/prerequisites.html


The build takes a lot of disk space (40GB+?) and requires a fair amount of downloads on the first execution.  For this reason, it's sometimes useful to build it on a remote machine.

## Locally

	git clone git@github.com:medic/crosswalk-build.git medic-crosswalk && \
	cd medic-crosswalk && \
	make build

## Remotely

	git clone git@github.com:medic/crosswalk-build.git medic-crosswalk && \
	cd medic-crosswalk && \
	(nohup make build & tail -F nohup.out)
