###################################################################################################
##  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors. All rights reserved.
##  Licensed under the LGPL license. See LICENSE file in the project root for details.
##  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
###################################################################################################

TEMPLATE = app
QT += quick core webview svg texttospeech purchasing

#include(webos.pri)

CONFIG +=                                                       \
    c++1z                                                       \
    lrelease                                                    \
    embed_translations                                          \
    sdk_no_version_check

CONFIG -= qtquickcompiler

INCLUDEPATH +=                                                  \
    src/base                                                    \
    src/base/capability                                         \
    src/common

HEADERS +=                                                      \
    src/base/AdvertisingManagerBase.h                           \
    src/base/AutoLockManagerBase.h                              \
    src/base/BatteryManagerBase.h                               \
    src/base/ClockLanguageManagerBase.h                         \
    src/base/DeviceAccessBase.h                                 \
    src/base/EnergySavingManagerBase.h                          \
    src/base/ManagerBase.h                                      \
    src/base/PersistenceManagerBase.h                           \
    src/base/ReviewManagerBase.h                                \
    src/base/ScreenBrightnessManagerBase.h                      \
    src/base/ScreenSizeManagerBase.h                            \
    src/base/ShareContentManagerBase.h                          \
    src/base/SpeechManagerBase.h                                \
    src/base/SplashScreenManagerBase.h                          \
    src/base/TrackingManagerBase.h                              \
    src/base/TranslationManagerBase.h                           \
    src/base/capability/PersistenceCapability.h                 \
    src/common/ClockLanguageManager.h                           \
    src/common/DeviceAccessFactory.h                            \
    src/common/PersistenceManager.h                             \
    src/common/TranslationManager.h

SOURCES +=                                                      \
    src/base/AdvertisingManagerBase.cpp                         \
    src/base/AutoLockManagerBase.cpp                            \
    src/base/BatteryManagerBase.cpp                             \
    src/base/ClockLanguageManagerBase.cpp                       \
    src/base/DeviceAccessBase.cpp                               \
    src/base/EnergySavingManagerBase.cpp                        \
    src/base/PersistenceManagerBase.cpp                         \
    src/base/ReviewManagerBase.cpp                              \
    src/base/ScreenBrightnessManagerBase.cpp                    \
    src/base/ScreenSizeManagerBase.cpp                          \
    src/base/ShareContentManagerBase.cpp                        \
    src/base/SpeechManagerBase.cpp                              \
    src/base/SplashScreenManagerBase.cpp                        \
    src/base/TrackingManagerBase.cpp                            \
    src/base/TranslationManagerBase.cpp                         \
    src/base/capability/PersistenceCapability.cpp               \
    src/common/ClockLanguageManager.cpp                         \
    src/common/DeviceAccessFactory.cpp                          \
    src/common/PersistenceManager.cpp                           \
    src/common/TranslationManager.cpp                           \
    src/main.cpp

RESOURCES += $$files(res/*.qrc)

VERSION = 1.2.0

DEFINES +=                                                      \
    TARGET=\"\\\"$${TARGET}\\\"\"                               \
    VERSION=\"\\\"$${VERSION}\\\"\"

# Default rules for deployment.
qnx {
    target.path = /tmp/$${TARGET}/bin
} else {
    unix:!android: target.path = /opt/$${TARGET}/bin
}

!isEmpty(target.path): INSTALLS += target

DISTFILES +=                                                    \
    .github/PULL_REQUEST_TEMPLATE                               \
    .github/workflows/*                                         \
    LICENSE                                                     \
    README.md                                                   \
    fastlane/*                                                  \
    src/README.md

TRANSLATIONS = $$system("ls translations/[^strings]*.ts")
OTHER_FILES += translations/strings.ts

#message($$QMAKE_PLATFORM)

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
        INCLUDEPATH +=                                          \
            src/macx                                            \
            src/default

        HEADERS +=                                              \
            src/default/SpeechManager.h
        SOURCES +=                                              \
            src/default/SpeechManager.cpp

        OBJECTIVE_HEADERS +=                                    \
            src/macx/DeviceAccess.h
        OBJECTIVE_SOURCES +=                                    \
            src/macx/DeviceAccess.mm
        QMAKE_INFO_PLIST = apple/macx/Info.plist
        DISTFILES += src/DeviceAccess_macx.mm
    } else:ios {
        INCLUDEPATH += src/ios
        OBJECTIVE_HEADERS +=                                    \
            src/ios/AutoLockManager.h                           \
            src/ios/BatteryManager.h                            \
            src/ios/DeviceAccess.h                              \
            src/ios/EnergySavingManager.h                       \
            src/ios/ReviewManager.h                             \
            src/ios/ScreenBrightnessManager.h                   \
            src/ios/ScreenSizeManager.h                         \
            src/ios/ShareContentManager.h                       \
            src/ios/SpeechManager.h
        OBJECTIVE_SOURCES +=                                    \
            src/ios/AutoLockManager.mm                          \
            src/ios/BatteryManager.mm                           \
            src/ios/DeviceAccess.mm                             \
            src/ios/EnergySavingManager.mm                      \
            src/ios/ReviewManager.mm                            \
            src/ios/ScreenBrightnessManager.mm                  \
            src/ios/ScreenSizeManager.mm                        \
            src/ios/ShareContentManager.mm                      \
            src/ios/SpeechManager.mm
        QMAKE_INFO_PLIST = apple/ios/Info.plist
        DISTFILES += src/DeviceAccess_ios.mm
        OTHER_FILES += apple/ios/Launch.storyboard
        app_launch_screen.files = apple/ios/Launch.storyboard
        QMAKE_BUNDLE_DATA += app_launch_screen
    }
} else:android {
    QT += androidextras
    INCLUDEPATH += src/android
    HEADERS +=                                                  \
        src/android/AutoLockManager.h                           \
        src/android/BatteryManager.h                            \
        src/android/DeviceAccess.h                              \
        src/android/EnergySavingManager.h                       \
        src/android/ReviewManager.h                             \
        src/android/ScreenBrightnessManager.h                   \
        src/android/ScreenSizeManager.h                         \
        src/android/ShareContentManager.h                       \
        src/android/SpeechManager.h                             \
        src/android/SplashScreenManager.h
    SOURCES +=                                                  \
        src/android/AutoLockManager.cpp                         \
        src/android/BatteryManager.cpp                          \
        src/android/DeviceAccess.cpp                            \
        src/android/EnergySavingManager.cpp                     \
        src/android/ReviewManager.cpp                           \
        src/android/ScreenBrightnessManager.cpp                 \
        src/android/ScreenSizeManager.cpp                       \
        src/android/ShareContentManager.cpp                     \
        src/android/SpeechManager.cpp                           \
        src/android/SplashScreenManager.cpp
    ANDROID_VERSION_NAME = $$VERSION
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    DISTFILES +=                                                \
        android/AndroidManifest.xml                             \
        android/build.gradle                                    \
        android/gradle.properties                               \
        android/gradle/wrapper/gradle-wrapper.jar               \
        android/gradle/wrapper/gradle-wrapper.properties        \
        android/gradlew                                         \
        android/gradlew.bat                                     \
        android/res/values/libs.xml                             \
        android/src/io/kokleeko/wordclock/DeviceAccess.java     \
        android/src/io/kokleeko/wordclock/MyActivity.java
    SOURCES += src/DeviceAccess_android.cpp
} else:emscripten {
    INCLUDEPATH += src/wasm
    HEADERS +=                                                  \
        src/wasm/DeviceAccess.h
    SOURCES +=                                                  \
        src/wasm/DeviceAccess.cpp
} else {
    INCLUDEPATH += src/default
    HEADERS +=                                                  \
        src/default/DeviceAccess.h                              \
        src/default/SpeechManager.h
    SOURCES +=                                                  \
        src/default/DeviceAccess.cpp                            \
        src/default/SpeechManager.cpp
}

DISTFILES +=                                                    \
    src/DeviceAccess.h                                          \
    src/DeviceAccess.cpp
