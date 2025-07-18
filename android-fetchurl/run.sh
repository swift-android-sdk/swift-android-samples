#!/bin/sh -ex
if [ "${SWIFT_SDK_VERSION}" = "6.1" ]; then
    # clang: error: no such file or directory: '/Users/runner/Library/org.swift.swiftpm/swift-sdks/swift-6.1-RELEASE-android-24-0.1.artifactbundle/swift-6.1-release-android-24-sdk/android-27c-sysroot/usr/lib/swift_static/android/x86_64/swiftrt.o'
    echo "Skipping skip android build --static-swift-stdlib for ${SWIFT_SDK_VERSION}"
else
    skip android build --static-swift-stdlib
fi

skip android run android-fetchurl http://example.org https://example.org
