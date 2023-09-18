/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls
import "qrc:/qml/settings" as Settings

import "qrc:/js/Helpers.js" as HelpersJS

QtControls.Drawer
{
    background: QtQuick.Item
    {
        clip: true
        opacity: isLandScape ? 1 : .925

        QtQuick.Rectangle
        {
            anchors { fill: parent; rightMargin: -radius }
            color: palette.window
            radius: Math.min(parent.height, parent.width)*.011
        }
    }
    bottomPadding: 20 + isFullScreen ? DeviceAccess.managers.screenSize.safeInsetBottom : 0
    dim: false
    edge: isLeftHanded ? Qt.RightEdge : Qt.LeftEdge
    height: parent.height
            - (isFullScreen ? 0
                            : (Math.max(DeviceAccess.managers.screenSize.statusBarHeight,
                                        DeviceAccess.managers.screenSize.safeInsetTop)
                               + (HelpersJS.isIos ? 0
                                                  : Math.max(DeviceAccess.managers.screenSize.navigationBarHeight,
                                                             DeviceAccess.managers.screenSize.safeInsetBottom))))
    leftPadding: isLandScape ? 20 : Math.max(20, DeviceAccess.managers.screenSize.safeInsetLeft)
    rightPadding: Math.max(20, DeviceAccess.managers.screenSize.safeInsetRight)
    topPadding: isFullScreen ? Math.max(20, DeviceAccess.managers.screenSize.safeInsetTop) : 20
    width: isLandScape ? Math.max(parent.width*.65, 300) : parent.width
    y: isFullScreen ? 0 : Math.max(DeviceAccess.managers.screenSize.statusBarHeight, DeviceAccess.managers.screenSize.safeInsetTop)

    QtQuick.Behavior on bottomPadding { QtQuick.NumberAnimation { duration: 100 } }
    QtQuick.Behavior on height { QtQuick.NumberAnimation { duration: 100 } }
    QtQuick.Behavior on topPadding { QtQuick.NumberAnimation { duration: 100 } }
    QtQuick.Behavior on y { QtQuick.NumberAnimation { duration: 100 } }
    Settings.Menu { }
    QtControls.BusyIndicator { anchors.centerIn: parent; running: tips.store.purchasing && !failedTransactionPopup.opened }
}
