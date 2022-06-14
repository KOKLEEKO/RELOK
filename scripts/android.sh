#!/bin/bash

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/android/build

mkdir -p $BUILD_DIR && cd $_
$Qt_DIR_ANDROID/bin/qmake -spec android-clang ANDROID_ABIS="x86_64" $PROJECT_DIR/$PROJECT_NAME.pro
$ANDROID_NDK_ROOT/prebuilt/darwin-x86_64/bin/make qmake_all
make -j$(nproc)
make -j$(nproc) apk_install_target
make -j$(nproc) apk
open -a /Applications/Android\ Studio.app ${BUILD_DIR}/android-build