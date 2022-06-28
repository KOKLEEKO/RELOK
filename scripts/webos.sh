#!/bin/bash

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/webos/build
TARGET_DEVICE=WTV

 ares-package ${PROJECT_DIR}/webos -o $BUILD_DIR
 ares-install --device $TARGET_DEVICE ${BUILD_DIR}/io.kokleeko.wordclock_1.0.0_all.ipk
 ares-launch --device $TARGET_DEVICE io.kokleeko.wordclock