#!/bin/bash

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/apple/ios/build

mkdir -p $BUILD_DIR && cd $_
$Qt_DIR_IOS/bin/qmake -d $PROJECT_DIR/$PROJECT_NAME.pro >> $PROJECT_DIR/qmake.log 2>&1

SCHEMES=$(xcodebuild -list -json | tr -d "\n")
DEFAULT_SCHEME=$(echo $SCHEMES | ruby -e "require 'json'; puts JSON.parse(STDIN.gets)['project']['targets'][0]")

open $PROJECT_NAME.xcodeproj
