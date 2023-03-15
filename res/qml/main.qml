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
    property bool aboutToQuit: false
    property WebView webView
    property alias headings: headings
    property alias badReviewPopup: badReviewPopup
    readonly property bool isLandScape: width > height
    readonly property bool isFullScreen: visibility == Window.FullScreen
    property bool isWidget: false
    property bool showTutorial: DeviceAccess.settingsValue("Tutorial/showPopup", true)
    property real tmpOpacity: root.opacity
    width: 640
    height: 480
    minimumWidth: 300
    minimumHeight: 300
    visible: true
    visibility: Helpers.isIos ? Window.FullScreen : Window.AutomaticVisibility
    opacity: DeviceAccess.settingsValue("Appearance/opacity", 1)
    color: wordClock.background_color
    onClosing: {
        aboutToQuit = true
        if (Helpers.isAndroid) {
            close.accepted = false
            DeviceAccess.moveTaskToBack()
        }
    }
    onIsFullScreenChanged: {
        if (!aboutToQuit) {
            DeviceAccess.setSettingsValue("Appearance/fullScreen", isFullScreen)
            if (isFullScreen) {
                tmpOpacity = root.opacity
                root.opacity = 1
            } else {
                root.opacity = tmpOpacity
            }
        }
    }
    onIsWidgetChanged: {
        if (Helpers.isDesktop)
            DeviceAccess.setSettingsValue("Appearance/widget", isWidget)
    }
    Component.onCompleted: {
        console.info("pixelDensity", Screen.pixelDensity)
    }

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
        midlight: systemPalette.midlight
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
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressAndHold: (mouse) => {
                            if (Helpers.isDesktop) {
                                switch (mouse.button) {
                                    case Qt.RightButton:
                                    Helpers.updateDisplayMode(root)
                                    break;
                                    case Qt.LeftButton:
                                    Helpers.updateVisibility(root, DeviceAccess)
                                    break;
                                }
                            } else {
                                Helpers.updateVisibility(root, DeviceAccess)
                            }
                        }
        onClicked: (mouse) => {
                       if (!Helpers.isDesktop || mouse.button === Qt.RightButton) {
                           settingPanel.open()
                       }
                   }
    }

    WordClock {
        id: wordClock
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height - (isFullScreen ? 0 : (DeviceAccess.statusBarHeight + DeviceAccess.navigationBarHeight))
        width: parent.width - (isLandScape ? settingPanel.position*settingPanel.width : 0)
    }
    Drawer {
        id: settingPanel
        y: isFullScreen ? 0 : DeviceAccess.statusBarHeight
        width: isLandScape ? Math.max(parent.width*.65, 300) : parent.width
        height: parent.height - (isFullScreen ? 0 : (DeviceAccess.statusBarHeight + DeviceAccess.navigationBarHeight))
        edge: Qt.RightEdge
        dim: false
        topPadding: Screen.primaryOrientation === Qt.PortraitOrientation ?
                        DeviceAccess.notchHeight : 0
        bottomPadding: Screen.primaryOrientation === Qt.InvertedPortraitOrientation ?
                           DeviceAccess.notchHeight : 0
        leftPadding: Screen.primaryOrientation === Qt.PortraitOrientation ?
                         DeviceAccess.notchHeight : 0
        rightPadding: Screen.primaryOrientation === Qt.PortraitOrientation ?
                          DeviceAccess.notchHeight : 0
        background: Item {
            clip: true
            opacity: isLandScape ? 1 : .95
            Rectangle {
                anchors { fill: parent; rightMargin: -radius }
                radius: Math.min(parent.height, parent.width)*.011
                color: palette.window
            }
        }
        SettingsMenu { }
    }
    Dialog {
        id: howtoPopup
        anchors.centerIn: parent
        title: qsTr("Welcome to WordClock")
        implicitWidth: Math.max(root.width/2, header.implicitWidth) + 2 * padding
        clip: true
        background.opacity: 0.95
        ColumnLayout {
            anchors { fill: parent; margins: howtoPopup.margins }
            Label {
                Layout.fillHeight: true
                Layout.fillWidth: true
                fontSizeMode: Label.Fit
                minimumPixelSize: 1
                wrapMode: Text.WordWrap
                text: "\%1.\n\n%2.".arg(qsTr("Thank you for downloading this application, we wish you a pleasant use"))
                .arg(Helpers.isMobile ? qsTr("Please touch the screen outside this window to close it and open the settings menu.")
                : qsTr("Please right-click outside this window to close it and open the settings menu.")
                )
            }
            CheckBox {
                id: hidePopupCheckbox;
                indicator.opacity: 0.5
                text: qsTr("Don't show this again")
            }
        }
        Connections { target: settingPanel; function onOpened() { howtoPopup.close() } }
        onClosed: root.showTutorial = !hidePopupCheckbox.checked
        closePolicy: Dialog.NoAutoClose
        Component.onCompleted: {
            header.background.visible = false
            if (!Helpers.isWebAssembly && showTutorial)
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
We are sorry to learn that you are not satisfied with this application.\
\nBut thanks to you, we will be able to improve it even more.\
\nSend us your suggestions and we will take it into account.")
        }
        onAccepted: Qt.openUrlExternally("mailto:contact@kokleeko.io?subject=%1"
                                         .arg(qsTr("Suggestions for WordClock")))
        standardButtons: Dialog.Close | Dialog.Ok
    }
    Loader { active: Helpers.isMobile; source: "WebAccess.qml"; onLoaded: webView = item.webView }
}
