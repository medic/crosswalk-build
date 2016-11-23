.PHONY: default build continue dependencies

export XWALK_OS_ANDROID=1

MAVEN_DIR = maven/org/medicmobile/crosswalk/xwalk_core_library/${TARGET_VERSION}
MAVEN_AAR = ${MAVEN_DIR}/xwalk_core_library-${TARGET_VERSION}.aar
MAVEN_POM = ${MAVEN_DIR}/xwalk_core_library-${TARGET_VERSION}.pom

default: continue

build: dependencies
	(cd src/out/Release && \
		ninja xwalk_core_library_aar)

continue:
	(cd src/out/Release && \
		ninja xwalk_core_library_aar && \
		ls -al xwalk_core_library.aar)

dependencies:
	yes | gclient sync && \
		(cd src && \
			./build/install-build-deps-android.sh && \
			./xwalk/gyp_xwalk)

release:
	if [ -z '${TARGET_VERSION}' ]; then echo 'TARGET_VERSION not set'; exit 1; fi
	git checkout gh-pages
	mkdir -p '${MAVEN_DIR}'
	cp src/out/Release/xwalk_core_library.aar '${MAVEN_AAR}'
	cp template.pom '${MAVEN_POM}'
	# Create a .bak file to maintain compatibility between GNU and BSD sed
	sed -i.bak -e 's/__TARGET_VERSION__/${TARGET_VERSION}/' '${MAVEN_POM}'
	rm '${MAVEN_POM}.bak'
	./scripts/build_maven_index
	git add 'maven/'
	git commit -m 'Release: ${TARGET_VERSION}'
	git push origin gh-pages
	git checkout -
	git tag 'medic-${TARGET_VERSION}'
	git push --tags
