# Prerequisites

See https://crosswalk-project.org/contribute/building_crosswalk/prerequisites.html

# Building

	export XWALK_OS_ANDROID=1
	git clone git@github.com:medic/crosswalk-build.git medic-crosswalk
	cd medic-crosswalk
	gclient sync
	(cd src && ./build/install-build-deps-android.sh)
	mkdir -p src/out/Default
	cp args.gn src/out/Default/
	(cd src && ninja -t clean && ninja -C out/Default xwalk_core_library__aar
