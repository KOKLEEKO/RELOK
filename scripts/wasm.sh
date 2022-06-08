#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/wasm/build

mkdir -p $BUILD_DIR && cd $_
$Qt_DIR_WASM/bin/qmake -d $PROJECT_DIR/$PROJECT_NAME.pro >> $PROJECT_DIR/qmake.log 2>&1
make -j$(nproc)
cp WordClock.html ../app/index.html
cp WordClock.js WordClock.wasm qtloader.js qtlogo.svg ../app/
cd ../app; emrun --no_emrun_detect --serve_after_close index.html