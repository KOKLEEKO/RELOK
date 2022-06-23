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
import QtQuick.Layouts 1.15

import "qrc:/js/Helpers.js" as Helpers

ApplicationWindow {
    id: root
    property WebView webView
    property alias headings: headings
    property alias badReviewPopup: badReviewPopup
    readonly property bool isLandScape: width > height
    width: 640
    height: 480
    minimumWidth: 180
    minimumHeight: minimumWidth
    visible: true
    visibility: Window.AutomaticVisibility
    color: wordClock.background_color
    onClosing: {
        if (Helpers.isAndroid) {
            close.accepted = false
            DeviceAccess.moveTaskToBack()
        }
    }
    Component.onCompleted: { console.info("pixelDensity", Screen.pixelDensity) }

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

    Connections {
        target: DeviceAccess
        function onOrientationChanged() { orientationChangedSequence.start() }
    }
    SequentialAnimation {
        id: orientationChangedSequence
        property bool isMenuOpened
        PropertyAction { targets: [wordClock, settingPanel]; property:"opacity"; value: 0 }
        ScriptAction {
            script: {
                orientationChangedSequence.isMenuOpened = settingPanel.opened
                settingPanel.close()
            }
        }
        PauseAnimation { duration: 500 }
        PropertyAnimation {
            targets: [wordClock, settingPanel]
            property: "opacity"
            duration: 500
            from: 0
            to: 1
        }
        ScriptAction { script: { if (orientationChangedSequence.isMenuOpened) settingPanel.open() }}
    }
    MouseArea {
        function toggleFullScreen() {
            if (!Helpers.isMobile)
                Helpers.toggle(root, "visibility", Window.FullScreen, Window.AutomaticVisibility)
        }
        property point pressed
        readonly property int threshold: 5
        anchors.fill: parent
        onPressAndHold: toggleFullScreen()
        onPressed: pressed = Qt.point(mouse.x, mouse.y)
        onClicked: {
            if (Math.abs(mouse.x -pressed.x) < threshold &&
                    Math.abs(mouse.y - pressed.y) < threshold) {
                settingPanel.open()
            }
        }
    }
    WordClock { id: wordClock }
    Drawer {
        id: settingPanel
        property real in_line_implicit_width
        dragMargin: -parent.width/5
        y: (parent.height - height) / 2
        width: isLandScape ? Math.max(parent.width*.65, 300) : parent.width
        height: parent.height
        closePolicy: Drawer.CloseOnEscape | Drawer.CloseOnPressOutside
        edge: Qt.RightEdge
        dim: false
        topPadding: Screen.orientation === Qt.PortraitOrientation ?
                        DeviceAccess.notchHeight : 0
        bottomPadding: Screen.orientation === Qt.InvertedPortraitOrientation ?
                           DeviceAccess.notchHeight : 0
        background: Item {
            clip: true
            opacity: .95
            Rectangle {
                anchors { fill: parent; rightMargin: -radius }
                radius: Math.min(parent.height, parent.width)*.02
                color: palette.window
            }
        }
        SettingsMenu { }
        Component.onCompleted: in_line_implicit_width = implicitWidth
    }
    Dialog {
        id: howtoPopup
        anchors.centerIn: parent
        title: qsTr("Welcome to WordClock")
        width: Math.max(root.width/2, header.implicitWidth)
        clip: true
        z:1
        ColumnLayout {
            Layout.fillWidth: true
            Label {
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                text: "\
%1.

%2.".arg(qsTr("Thank you for downloading this application, we wish you a pleasant use"))
                .arg(qsTr("Please touch the screen to open the settings menu"))
            }
                CheckBox { id: hidePopupCheckbox; text: qsTr("Don't show this again") }
            }
            Connections { target: settingPanel; function onOpened() { howtoPopup.close() } }
            onClosed: DeviceAccess.setSettingsValue("Tutorial/showPopup", !hidePopupCheckbox.checked)
            standardButtons: Dialog.Close
            closePolicy: Dialog.NoAutoClose
            Component.onCompleted: {
                if (!Helpers.isWebAssembly && DeviceAccess.settingsValue("Tutorial/showPopup", true))
                    open()
            }
        }
        Dialog {
            id: badReviewPopup
            anchors.centerIn: parent
            title: qsTr("Thanks for your review")
            width: Math.max(root.width/2, header.implicitWidth)
            clip: true
            Label {
                wrapMode: Text.WordWrap
                width: parent.width
                text: qsTr("\
We are sorry to learn that you are not satisfied with this application.

But thanks to you, we will be able to improve it even more.

Send us your suggestions and we will take it into account.")
            }
            onAccepted: Qt.openUrlExternally("mailto:contact@kokleeko.io?subject=%1"
                                             .arg(qsTr("Suggestions for WordClock")))
            standardButtons: Dialog.Close | Dialog.Ok
        }
        Loader { active: Helpers.isMobile; source: "WebAccess.qml"; onLoaded: webView = item.webView }
    }
