#!/bin/zsh

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace
source ~/.zshrc

local totaltime

export SCRIPT_DIR=$(realpath $(dirname "$0"))
export PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
export PROJECT_NAME=$(basename $PROJECT_DIR)
export BUILD_DIR=$PROJECT_DIR/apple/macx/build

echo_bold "env:"
echo_vars SCRIPT_DIR \
		  PROJECT_DIR \
		  PROJECT_NAME \
		  BUILD_DIR


echo_exec mkcd $BUILD_DIR
echo_exec $Qt5_DIR/bin/qmake -d -spec macx-xcode $PROJECT_DIR/$PROJECT_NAME.pro

echo_bold "\nExecution time: $(seconds_to_time totaltime)"

echo_bold "Open Xcode..."
open $PROJECT_NAME.xcodeproj
