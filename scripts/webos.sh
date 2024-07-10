#!/bin/zsh

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace
source ~/.zshrc

local totaltime

export SCRIPT_DIR=$(realpath $(dirname "$0"))
export PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
export PROJECT_NAME=$(basename $PROJECT_DIR)
export BUILD_DIR=$PROJECT_DIR/webos/build
export TARGET_DEVICE=$1

echo_bold "env:"
echo_vars SCRIPT_DIR 	\
          PROJECT_DIR 	\
          PROJECT_NAME 	\
          BUILD_DIR 	\
	  TARGET_DEVICE

echo_exec ares-package ${PROJECT_DIR}/webos -o $BUILD_DIR
echo_exec ares-install --device $TARGET_DEVICE ${BUILD_DIR}/io.kokleeko.relok_1.0.0_all.ipk

echo_bold "\nExecution time: $(seconds_to_time totaltime)"

echo_bold "Launch..."
echo_exec ares-launch --device $TARGET_DEVICE io.kokleeko.relok
