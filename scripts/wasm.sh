#!/bin/bash

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/wasm/build

mkdir -p $BUILD_DIR && cd $_
$Qt_DIR_WASM/bin/qmake -d $PROJECT_DIR/$PROJECT_NAME.pro >> $PROJECT_DIR/qmake.log 2>&1
make -j$(nproc)
cp WordClock.js WordClock.wasm ../app/
cd ../app; emrun --no_emrun_detect --serve_after_close index.html
