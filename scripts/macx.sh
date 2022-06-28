#!/bin/bash

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/apple/macx/build

mkdir -p $BUILD_DIR && cd $_
$Qt_DIR/bin/qmake -d -spec macx-xcode $PROJECT_DIR/$PROJECT_NAME.pro >> $PROJECT_DIR/qmake.log 2>&1
open $PROJECT_NAME.xcodeproj
