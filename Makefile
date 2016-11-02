.PHONY: build dependencies configure

export XWALK_OS_ANDROID=1

build: dependencies configure
	(cd src/out/Default && \
		ninja -t clean && \
		ninja xwalk_core_library__aar)

configure:
	mkdir -p src/out/Default && \
		(cd src && gn gen out/Default) && \
		cp args.gn src/out/Default/ && \
		(cd src && gn gen out/Default)

dependencies:
	yes | gclient sync && \
		(cd src && ./build/install-build-deps-android.sh)
