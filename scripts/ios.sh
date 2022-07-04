#!/bin/zsh

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace
source ~/.zshrc

local totaltime

SCRIPT_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)
BUILD_DIR=$PROJECT_DIR/apple/ios/build

echo_bold "env:"
echo_vars SCRIPT_DIR \
		  PROJECT_DIR \
		  PROJECT_NAME \
		  BUILD_DIR

echo_exec mkcd $BUILD_DIR

echo_exec $Qt5_DIR_IOS/bin/qmake -d $PROJECT_DIR/$PROJECT_NAME.pro

SCHEMES=$(xcodebuild -list -json | tr -d "\n")
DEFAULT_SCHEME=$(echo $SCHEMES | ruby -e "require 'json'; puts JSON.parse(STDIN.gets)['project']['targets'][0]")

echo_bold "\nExecution time: $(seconds_to_time totaltime)"

echo_bold "Open Xcode..."
open $PROJECT_NAME.xcodeproj
