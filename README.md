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

## How do we deploy it?

We serve a simple maven repository from the github-pages URL of this repository.  The repo address is https://medic.github.io/crosswalk-chromium/maven.  To upload your build to this repo, first build the `aar` file (as per the instructions below), and then:

	make release TARGET_VERSION=x.y.z


# Updating Crosswalk

## Stable branches

The Crosswalk project maintains [branches for each version](https://github.com/crosswalk-project/crosswalk/branches).  The latest branch named `crosswalk-X` is likely to be in development (beta), and the previous to be the last stable branch.  At the time of writing this document, [branch `crosswalk-23` was the beta branch](https://github.com/crosswalk-project/crosswalk/tree/crosswalk-23) and [`crosswalk-22` was the latest stable branch](https://github.com/crosswalk-project/crosswalk/tree/crosswalk-22).

The long-term goal is to get our changes accepted upstream.  Until then, we aim to keep the medic fork of crosswalk up-to-date with the latest stable branch from upstream.  Our changes should be **rebased** onto the latest stable branch when there are new changes, and then a new version of medic's fork should be built and released.

## What to change

Rebase [our changes](https://github.com/medic/crosswalk) onto the latest stable branch of [crosswalk](https://github.com/crosswalk-project/crosswalk).  If no changes are made to `.gclient`, the latest head of https://github.com/medic/crosswalk will be built.  It would be wise to test changes on a separate branch before pushing to master; see [the section on working with branches](https://github.com/medic/crosswalk-build#working-with-branches) below.

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

## Working with branches

When the build is run, `ninja`/`gn`/`gyp` automatically updates the local versions of `crosswalk` and `chromium-crosswalk`.  The version of `crosswalk` used depends on the content of the file `.gclient` in the root directory of this project.  The version of `chromium-crosswalk` depends on the commit hash specified in `DEPS.xwalk` in the root of the `crosswalk` project (i.e. `src/xwalk/DEPS.xwalk`).

Here are some example `.gclient` configurations to build different branches of `crosswalk`:

### Building `master`

	solutions = [
	  { "name"        : "src/xwalk",
	    "url"         : "https://github.com/medic/crosswalk.git",
	    "deps_file"   : "DEPS",
	    "managed"     : True,
	    "custom_deps" : {
	    },
	    "safesync_url": "",
	  },
	]
	cache_dir = None

### Building branch `my-branch`

	solutions = [
	  { "name"        : "src/xwalk",
	    "url"         : "https://github.com/medic/crosswalk.git@my-branch",
	    "deps_file"   : "DEPS",
	    "managed"     : True,
	    "custom_deps" : {
	    },
	    "safesync_url": "",
	  },
	]
	cache_dir = None

### Building the local copy

	solutions = [
	  { "name"        : "src/xwalk",
	    "url"         : "https://github.com/medic/crosswalk.git",
	    "deps_file"   : "DEPS",
	    "managed"     : False,
	    "custom_deps" : {
	    },
	    "safesync_url": "",
	  },
	]
	cache_dir = None

# Processor Architecture

Currently, this project is set up to only support arm32 processors.  If support for x86 or 64-bit processors (arm, or otherwise), is required we will have to do a couple of things:

1. run the build multiple times with different values for `GYP_DEFINES`
2. take the `/jni` directory from each different `.aar` that the builds for different architectures provide, and combine them into a single `.aar` file, which would be the one that we publish.
