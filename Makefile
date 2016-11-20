.PHONY: default build continue dependencies configure

export XWALK_OS_ANDROID=1

MAVEN_DIR = maven/org/medicmobile/crosswalk/xwalk_core_library/${TARGET_VERSION}
MAVEN_AAR = ${MAVEN_DIR}/xwalk_core_library-${TARGET_VERSION}.aar
MAVEN_POM = ${MAVEN_DIR}/xwalk_core_library-${TARGET_VERSION}.pom

default: continue

build: dependencies configure
	(cd src/out/Default && \
		ninja -t clean && \
		ninja xwalk_core_library__aar)

continue:
	(cd src/out/Default && \
		ninja xwalk_core_library__aar && \
		ls -al xwalk_core_library.aar)

configure:
	mkdir -p src/out/Default && \
		(cd src && gn gen out/Default) && \
		cp args.gn src/out/Default/ && \
		(cd src && gn gen out/Default)

dependencies:
	yes | gclient sync && \
		(cd src && ./build/install-build-deps-android.sh)

release:
	if [ -z '${TARGET_VERSION}' ]; then echo 'TARGET_VERSION not set'; exit 1; fi
	git checkout gh-pages
	mkdir -p '${MAVEN_DIR}'
	cp src/out/Default/xwalk_core_library.aar '${MAVEN_AAR}'
	cp template.pom '${MAVEN_POM}'
	# Create a .bak file to maintain compatibility between GNU and BSD sed
	sed -i.bak -e 's/__TARGET_VERSION__/${TARGET_VERSION}/' '${MAVEN_POM}'
	rm '${MAVEN_POM}.bak'
	git add '${MAVEN_DIR}'
	git commit -m 'Release: ${TARGET_VERSION}'
	git tag 'medic-${TARGET_VERSION}'
	git push origin gh-pages
	git push --tags
	git checkout -
