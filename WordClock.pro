###################################################################################################
##  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors. All rights reserved.
##  Licensed under the MIT license. See LICENSE file in the project root for details.
##  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
###################################################################################################

TEMPLATE = app
QT += quick core webview svg

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += \
    c++1z \
    sdk_no_version_check

QMAKE_TARGET_BUNDLE_PREFIX = io.kokleeko

HEADERS += src/DeviceAccess.h

SOURCES += src/main.cpp

RESOURCES += $$files(res/*.qrc)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

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
             fastlane/

macx | ios {
    QMAKE_ASSET_CATALOGS += apple/Assets.xcassets
    LIBS += -framework StoreKit
    macx {
       QMAKE_INFO_PLIST = apple/macx/Info.plist
       OBJECTIVE_SOURCES += src/DeviceAccess_macos.mm
    }
    ios {
        OTHER_FILES += apple/ios/Launch.storyboard
        OBJECTIVE_SOURCES += src/DeviceAccess_ios.mm
        QMAKE_INFO_PLIST = apple/ios/Info.plist
        app_launch_screen.files = apple/ios/Launch.storyboard
        QMAKE_BUNDLE_DATA += app_launch_screen
        QMAKE_POST_LINK += $$quote(cp -r $$PWD/fastlane $$OUT_PWD$$escape_expand(\n\t))
    }
} else {
  SOURCES += src/DeviceAccess.cpp
}

