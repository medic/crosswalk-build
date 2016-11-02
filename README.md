# Prerequisites

See https://crosswalk-project.org/contribute/building_crosswalk/prerequisites.html

# Building

The build takes a lot of disk space (40GB+?) and requires a fair amount of downloads on the first execution.  For this reason, it's sometimes useful to build it on a remote machine.

## Locally

	git clone git@github.com:medic/crosswalk-build.git medic-crosswalk && \
	cd medic-crosswalk && \
	make

## Remotely

	git clone git@github.com:medic/crosswalk-build.git medic-crosswalk && \
	cd medic-crosswalk && \
	(nohup make & tail -F nohup.out)
