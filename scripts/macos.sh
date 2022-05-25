#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/macos/build

mkdir -p $BUILD_DIR && cd $_
echo $PROJECT_DIR
$Qt_DIR/bin/qmake -d -spec macx-xcode $PROJECT_DIR/$PROJECT_NAME.pro >> $PROJECT_DIR/qmake.log 2>&1
open $PROJECT_NAME.xcodeproj
