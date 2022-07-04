#!/bin/zsh

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace
source ~/.zshrc

local totaltime

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/wasm/build

echo_bold "env:"
echo_vars SCRIPT_DIR \
		  PROJECT_DIR \
		  PROJECT_NAME \
		  BUILD_DIR

echo_exec mkcd $BUILD_DIR
echo_exec $Qt5_DIR_WASM/bin/qmake -d $PROJECT_DIR/$PROJECT_NAME.pro >> $PROJECT_DIR/qmake.log 2>&1
echo_exec make -j$(nproc)
echo_exec cp WordClock.js WordClock.wasm ../app/

echo_bold "\nExecution time: $(seconds_to_time totaltime)"

echo_bold "Launch..."
echo_exec cd ../app; emrun --no_emrun_detect --serve_after_close index.html
