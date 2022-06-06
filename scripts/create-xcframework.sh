#!/usr/bin/env bash

set -e

# Archive device
xcodebuild archive \
  -project JudoKit_iOS.xcodeproj \
  -scheme JudoKit_iOS \
  -destination "generic/platform=iOS" \
  -configuration Release \
  -archivePath ./build/JudoKit_iOS
 
# Archive simulator
xcodebuild archive \
  -project JudoKit_iOS.xcodeproj \
  -scheme JudoKit_iOS \
  -destination "generic/platform=iOS Simulator" \
  -configuration Release \
  -archivePath ./build/JudoKit_iOS-Sim

# Create XCFramework
rm -rf ./build/JudoKit_iOS.xcframework
xcodebuild -create-xcframework \
  -framework ./build/JudoKit_iOS.xcarchive/Products/Library/Frameworks/JudoKit_iOS.framework \
  -framework ./build/JudoKit_iOS-Sim.xcarchive/Products/Library/Frameworks/JudoKit_iOS.framework \
  -output ./build/JudoKit_iOS.xcframework
