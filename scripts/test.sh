#!/usr/bin/env bash

set -e

xcodebuild clean test \
  -project JudoKit_iOS.xcodeproj \
  -scheme JudoKit_iOS \
  -destination 'platform=iOS Simulator,OS=15.4,name=iPhone 13'
