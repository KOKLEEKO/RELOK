#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/ios/build

mkdir -p $BUILD_DIR && cd $_
echo $PROJECT_DIR
$Qt_DIR_IOS/bin/qmake $PROJECT_DIR/$PROJECT_NAME.pro
open $PROJECT_NAME.xcodeproj