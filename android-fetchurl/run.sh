#!/bin/sh -ex
skip android build --static-swift-stdlib
skip android run android-fetchurl http://example.org https://example.org
