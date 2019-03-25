#!/bin/sh

BUILD_VERSION_NUMBER=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")

BUILD_VERSION_NUMBER=$(($BUILD_VERSION_NUMBER + 1))

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_VERSION_NUMBER" "$INFOPLIST_FILE"