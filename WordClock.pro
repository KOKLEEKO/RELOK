###################################################################################################
##  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors. All rights reserved.
##  Licensed under the LGPL license. See LICENSE file in the project root for details.
##  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
###################################################################################################

TEMPLATE = app
QT += quick core webview svg texttospeech purchasing

#include(webos.pri)

CONFIG += \
    c++1z \
    lrelease \
    embed_translations \
    sdk_no_version_check

CONFIG -= qtquickcompiler

HEADERS += src/DeviceAccess.h

SOURCES += src/main.cpp

RESOURCES += $$files(res/*.qrc)

VERSION = 1.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
             LICENSE \
             README.md \
             .github/PULL_REQUEST_TEMPLATE \
             .github/workflows/* \
             src/README.md \
             fastlane/*

TRANSLATIONS = $$system("ls translations/[^strings]*.ts")
OTHER_FILES += translations/strings.ts

macx | ios {
    QMAKE_TARGET_BUNDLE_PREFIX = io.kokleeko
    Q_ENABLE_BITCODE.name = ENABLE_BITCODE
    Q_ENABLE_BITCODE.value = NO
    QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE
    Q_ALWAYS_SEARCH_USER_PATHS.name = ALWAYS_SEARCH_USER_PATHS
    Q_ALWAYS_SEARCH_USER_PATHS.value = NO
    QMAKE_MAC_XCODE_SETTINGS += Q_ALWAYS_SEARCH_USER_PATHS
    QMAKE_ASSET_CATALOGS += apple/Assets.xcassets
    LIBS += -framework StoreKit
    DISTFILES += Gemfile
    macx {
        QMAKE_INFO_PLIST = apple/macx/Info.plist
        OBJECTIVE_SOURCES += src/DeviceAccess_macx.mm
    } else:ios {
        QMAKE_INFO_PLIST = apple/ios/Info.plist
        OBJECTIVE_SOURCES += src/DeviceAccess_ios.mm
        OTHER_FILES += apple/ios/Launch.storyboard
        app_launch_screen.files = apple/ios/Launch.storyboard
        QMAKE_BUNDLE_DATA += app_launch_screen
    }
} else:android {
    QT += androidextras
    ANDROID_VERSION_NAME = $$VERSION
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    DISTFILES += \
        android/AndroidManifest.xml \
        android/build.gradle \
        android/gradle.properties \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew \
        android/gradlew.bat \
        android/res/values/libs.xml \
        android/src/io/kokleeko/wordclock/DeviceAccess.java \
        android/src/io/kokleeko/wordclock/MyActivity.java
    SOURCES += src/DeviceAccess_android.cpp
} else {
    SOURCES += src/DeviceAccess.cpp
}

