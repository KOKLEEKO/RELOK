#!/bin/zsh

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace
source ~/.zshrc

local totaltime

echo_bold "env"
export SCRIPT_DIR=$(realpath $(dirname "$0"))
export PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
export PROJECT_NAME=$(basename $PROJECT_DIR)
export BUILD_DIR=$PROJECT_DIR/android/build

export ANDROID_BUILD_DIR=$BUILD_DIR/android-build
export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/21.3.6528147
export ANDROID_NDK_PLATFORM=android-33

echo_vars ANDROID_ABIS 						\
		  ANDROID_API_VERSION 				\
		  ANDROID_DEPLOYMENT_DEPENDENCIES 	\
		  ANDROID_EXTRA_LIBS 				\
		  ANDROID_EXTRA_PLUGINS 			\
		  ANDROID_HOME 						\
		  ANDROID_MIN_SDK_VERSION 			\
		  ANDROID_NDK_HOST 					\
		  ANDROID_NDK_PLATFORM 				\
		  ANDROID_NDK_ROOT 					\
		  ANDROID_PACKAGE_SOURCE_DIR 		\
		  ANDROID_SDK_ROOT 					\
		  ANDROID_TARGET_SDK_VERSION 		\
		  ANDROID_VERSION_CODE 				\
		  ANDROID_VERSION_NAME 				\
		  JAVA_HOME 						\
		  SCRIPT_DIR 						\
          PROJECT_DIR 						\
		  PROJECT_NAME 						\
          BUILD_DIR

echo_exec mkcd $BUILD_DIR

echo_exec $Qt5_DIR_ANDROID/bin/qmake $PROJECT_DIR/$PROJECT_NAME.pro

MAKE_COMMAND=$ANDROID_NDK_ROOT/prebuilt/$ANDROID_NDK_HOST/bin/make
echo_exec $MAKE_COMMAND -j$(nproc)
echo_exec $MAKE_COMMAND -j$(nproc) apk_install_target

echo_exec cd $ANDROID_BUILD_DIR
echo_exec $Qt5_DIR_ANDROID/bin/androiddeployqt --input $BUILD_DIR/android-WordClock-deployment-settings.json --output $ANDROID_BUILD_DIR --android-platform $ANDROID_NDK_PLATFORM

echo_bold "\nExecution time: $(seconds_to_time totaltime)"

echo_bold "Open Android Studio..."
open -a /Applications/Android\ Studio.app $ANDROID_BUILD_DIR
