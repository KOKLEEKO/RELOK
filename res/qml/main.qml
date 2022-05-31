/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtWebView 1.15

import "qrc:/js/Helpers.js" as Helpers

ApplicationWindow {
    id: root
    property WebView webView
    property alias headings: headings
    width: 640
    height: 480
    minimumWidth: 180
    minimumHeight: minimumWidth
    visible: true
    visibility: Helpers.isMobile ? Window.FullScreen : Window.AutomaticVisibility
    flags: Qt.Window | Qt.WindowStaysOnTopHint
    Screen.orientationUpdateMask: Qt.LandscapeOrientation |
                                  Qt.PortraitOrientation |
                                  Qt.InvertedLandscapeOrientation |
                                  Qt.InvertedPortraitOrientation
    Component.onCompleted: {console.log("pixelDensity", Screen.pixelDensity)}

    QtObject {
        id: headings
        readonly property real h0: 40
        readonly property real h1: 32
        readonly property real h2: 26
        readonly property real h3: 22
        readonly property real h4: 20
        readonly property real p1: 13
        readonly property real p2: 11
    }

    SystemPalette { id: systemPalette }
    palette {
        alternateBase: systemPalette.alternateBase
        base: systemPalette.base
        button: systemPalette.button
        buttonText: systemPalette.windowText
        dark: systemPalette.highlight
        highlight: systemPalette.highlight
        highlightedText: systemPalette.highlightedText
        light: systemPalette.light
        link: systemPalette.link
        linkVisited: systemPalette.linkVisited
        mid: systemPalette.mid
        midlight: systemPalette.light
        shadow: systemPalette.shadow
        text: systemPalette.text
        toolTipBase: systemPalette.toolTipBase
        toolTipText: systemPalette.toolTipText
        window: systemPalette.window
        windowText: systemPalette.windowText
    }

    MouseArea {
        function toggleFullScreen() {
            if (!Helpers.isMobile)
                Helpers.toggle(root, "visibility", Window.FullScreen, Window.AutomaticVisibility)
        }
        anchors.fill: parent
        onPressed: toggleFullScreen
        onPressAndHold: settingPanel.open()
    }
    WordClock { id: wordClock }
    Drawer {
        id: settingPanel
        property real in_line_implicit_width

        y: (parent.height - height) / 2
        width: Helpers.isEqual(Screen.primaryOrientation,
                               Qt.LandscapeOrientation,
                               Qt.InvertedLandscapeOrientation) ? Math.max(parent.width*.65, 300)
                                                                : parent.width
        height: parent.height
        closePolicy: Drawer.CloseOnEscape | Drawer.CloseOnPressOutside
        edge: Qt.RightEdge
        dim: false
        topPadding: Screen.primaryOrientation === Qt.PortraitOrientation ?
                        DeviceAccess.notchHeight : 0
        bottomPadding: Screen.primaryOrientation === Qt.InvertedPortraitOrientation ?
                           DeviceAccess.notchHeight : 0
        background: Item {
            clip: true
            opacity: 0.8
            Rectangle {
                anchors { fill: parent; rightMargin: -radius }
                radius: Math.min(parent.height, parent.width)*.02
                color: palette.window
            }
        }
        SettingsMenu { }
        Component.onCompleted: in_line_implicit_width = implicitWidth
    }
    Loader { active: Helpers.isMobile; source: "WebAccess.qml"; onLoaded: webView = item.webView }
}
