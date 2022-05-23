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
    visibility: Window.AutomaticVisibility
    flags: Qt.Window | Qt.WindowStaysOnTopHint

    Component.onCompleted: {console.log("pixelDensity", Screen.pixelDensity)}

    QtObject {
        id: headings
        readonly property real h0: 40*Screen.devicePixelRatio
        readonly property real h1: 32*Screen.devicePixelRatio
        readonly property real h2: 26*Screen.devicePixelRatio
        readonly property real h3: 22*Screen.devicePixelRatio
        readonly property real h4: 20*Screen.devicePixelRatio
        readonly property real p1: 13*Screen.devicePixelRatio
        readonly property real p2: 11*Screen.devicePixelRatio
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

    Connections {
        target: DeviceAccess
        function onToggleFullScreen() {
            Helpers.toggle(root, "visibility", Window.FullScreen, Window.AutomaticVisibility)
        }
    }
    MouseArea {
        property point pressedPoint
        property bool isPressAndHold: false
        anchors.fill: parent
        onPressed: {
            isPressAndHold = false
            pressedPoint = Qt.point(mouseX, mouseY)
        }
        onPressAndHold: {
            isPressAndHold = true
            settingPanel.open()
        }
        onPositionChanged: {
            if (Math.abs(pressedPoint.y - mouseY) >= 1)
                DeviceAccess.setBrigthnessDelta(2*(pressedPoint.y - mouseY)/root.height)
        }
        onReleased:{
            if (!isPressAndHold && Math.abs(pressedPoint.x - mouseX) < 1 && Math.abs(pressedPoint.y - mouseY) < 1)
                DeviceAccess.toggleStatusBarVisibility()
        }
    }
    WordClock { id: wordClock }
    Drawer {
        id: settingPanel
        property real inLineImplicitWidth
        y: (parent.height - height) / 2
        width: Screen.primaryOrientation === Qt.LandscapeOrientation ?
                   Math.max(parent.width*.5,300) : parent.width*.95
        height: parent.height
        closePolicy: Drawer.CloseOnEscape | Drawer.CloseOnPressOutside
        edge: Qt.RightEdge
        dim: false
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
        Component.onCompleted: inLineImplicitWidth = implicitWidth
    }
    Loader { active: Helpers.isMobile; source: "WebAccess.qml"; onLoaded: webView = item.webView }
}
