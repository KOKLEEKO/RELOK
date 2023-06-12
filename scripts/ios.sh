#!/bin/zsh

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace
source ~/.zshrc

local totaltime

echo_bold "env"
export SCRIPT_DIR=$(realpath $(dirname "$0"))
export PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
export PROJECT_NAME=$(basename $PROJECT_DIR)
export BUILD_DIR=$PROJECT_DIR/apple/ios/build

echo_bold "env:"
echo_vars SCRIPT_DIR \
		  PROJECT_DIR \
		  PROJECT_NAME \
		  BUILD_DIR

echo_exec mkcd $BUILD_DIR

echo_exec $Qt5_DIR_IOS/bin/qmake $PROJECT_DIR/$PROJECT_NAME.pro

# for resource in $(ls $PROJECT_DIR/res/*.qrc); do
# 	echo_exec rcc -g cpp $resource -o qrc_$(basename $resource .qrc).cpp
# done

# for header in $(ls $PROJECT_DIR/src/*.h); do
# 	echo_exec moc -o moc_$(basename $header .h).cpp $header
# done
echo_exec make -j$(nproc) -i

SCHEMES=$(xcodebuild -list -json | tr -d "\n")
DEFAULT_SCHEME=$(echo $SCHEMES | ruby -e "require 'json'; puts JSON.parse(STDIN.gets)['project']['targets'][0]")

echo_bold "\nExecution time: $(seconds_to_time totaltime)"

echo_bold "Open Xcode..."
open $PROJECT_NAME.xcodeproj
