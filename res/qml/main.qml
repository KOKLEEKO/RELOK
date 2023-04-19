/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtDigitalAdvertising 1.1
import QtPurchasing 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtWebView 1.15

import "qrc:/js/Helpers.js" as Helpers

ApplicationWindow {
    id: root
    property size size: Qt.size(width, height)
    property bool aboutToQuit: false
    property WebView webView
    property alias headings: headings
    property alias badReviewPopup: badReviewPopup
    readonly property bool isLandScape: width > height
    readonly property bool isFullScreen: Helpers.isIos ? DeviceAccess.prefersStatusBarHidden
                                                       : visibility === Window.FullScreen
    property bool isWidget: false
    property bool showWelcome: DeviceAccess.settingsValue("Welcome/showPopup", true)
    property real tmpOpacity: root.opacity

    //Tips
    property var failedProduct: null
    property string failedProductErrorSrting: ""

    property alias store: store
    property alias productTipBone: productTipBone
    property alias productTipCoffee: productTipCoffee
    property alias productTipCookie: productTipCookie
    property alias productTipIceCream: productTipIceCream
    property alias productTipBeer: productTipBeer
    property alias productTipBurger: productTipBurger
    property alias productTipWine: productTipWine

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
            if (Helpers.isDesktop) {
                if (isFullScreen) {
                    tmpOpacity = root.opacity
                    root.opacity = 1
                } else {
                    root.opacity = tmpOpacity
                }
            }
        }
    }
    onIsWidgetChanged: {
        if (Helpers.isDesktop)
            DeviceAccess.setSettingsValue("Appearance/widget", isWidget)
    }
    onVisibilityChanged: if (Helpers.isMobile && !settingPanel.opened) visibilityChangedSequence.start()
    Component.onCompleted: {
        console.info("pixelDensity", Screen.pixelDensity)
        if (Helpers.isAndroid)
            onSizeChanged.connect(DeviceAccess.updateSafeAreaInsets)

        //for (var prop in Qt.rgba(1,0,0,0))
        //  console.log(prop)
        //console.log(Qt.rgba(1,0,0,0).hslLightness)
    }

    Store {
        id: store
        property bool purchasing: false
        function success(transaction) {
            if (transaction)
                transaction.finalize()
            tipthanksPopup.open()
            purchasing = false
        }
        function failed(transaction, product) {
            if (transaction) {
                transaction.finalize()
                failedProduct = product
                failedProductErrorSrting = transaction.errorString
                failTransactionPopup.open()
            } else
                purchasing = false
        }
        onPurchasingChanged: {
            if (!purchasing) {
                failedProduct = null
                failedProductErrorSrting = ""
            }
        }

        Product {
            id: productTipBone
            identifier: "io.kokleeko.wordclock.tip.bone"
            type: Product.Consumable
            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, productTipBone)
        }
        Product {
            id: productTipCoffee
            identifier: "io.kokleeko.wordclock.tip.coffee"
            type: Product.Consumable
            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, productTipCoffee)
        }
        Product {
            id: productTipCookie
            identifier: "io.kokleeko.wordclock.tip.cookie"
            type: Product.Consumable
            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, productTipCookie)
        }
        Product {
            id: productTipIceCream
            identifier: "io.kokleeko.wordclock.tip.icecream"
            type: Product.Consumable
            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, productTipIceCream)
        }
        Product {
            id: productTipBeer
            identifier: "io.kokleeko.wordclock.tip.beer"
            type: Product.Consumable
            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, productTipBeer)
        }
        Product {
            id: productTipBurger
            identifier: "io.kokleeko.wordclock.tip.burger"
            type: Product.Consumable
            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, productTipBurger)
        }
        Product {
            id: productTipWine
            identifier: "io.kokleeko.wordclock.tip.wine"
            type: Product.Consumable
            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction. productTipWine)
        }
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
    //palette {
    //  alternateBase: systemPalette.alternateBase
    //  base: systemPalette.base
    //  button: systemPalette.button
    //  buttonText: systemPalette.windowText
    //  dark: systemPalette.highlight
    //  highlight: systemPalette.highlight
    //  highlightedText: systemPalette.highlightedText
    //  light: systemPalette.light
    //  link: systemPalette.link
    //  linkVisited: systemPalette.linkVisited
    //  mid: systemPalette.mid
    //  midlight: systemPalette.midlight
    //  shadow: systemPalette.shadow
    //  text: systemPalette.text
    //  toolTipBase: systemPalette.toolTipBase
    //  toolTipText: systemPalette.toolTipText
    //  window: systemPalette.window
    //  windowText: systemPalette.windowText
    //}

    Connections {
        target: DeviceAccess
        function onViewConfigurationChanged() { viewConfigurationChangedSequence.start() }
    }
    SequentialAnimation {
        id: viewConfigurationChangedSequence
        alwaysRunToEnd: true
        property bool isMenuOpened
        PropertyAction { targets: [wordClock, settingPanel]; property:"opacity"; value: 0 }
        ScriptAction {
            script: {
                viewConfigurationChangedSequence.isMenuOpened = settingPanel.opened
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
        ScriptAction {
            script: {
                if (viewConfigurationChangedSequence.isMenuOpened)
                    settingPanel.open()
            }
        }
    }
    SequentialAnimation {
        id: visibilityChangedSequence
        alwaysRunToEnd: true
        PropertyAction { target: wordClock; property:"opacity"; value: 0 }
        PropertyAnimation {
            targets: wordClock
            property: "opacity"
            duration: 350
            from: 0
            to: 1
        }
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
        x: DeviceAccess.safeInsetLeft
        height: parent.height
                - (isFullScreen ? 0
                                : (Math.max(DeviceAccess.statusBarHeight, DeviceAccess.safeInsetTop)
                                   + Math.max(DeviceAccess.navigationBarHeight,
                                              DeviceAccess.safeInsetBottom)))
        width: parent.width - (DeviceAccess.safeInsetLeft + DeviceAccess.safeInsetRight)
               - (isLandScape ? settingPanel.position
                                * (settingPanel.width - DeviceAccess.safeInsetRight)
                              : 0)
    }

    Drawer {
        id: settingPanel
        y: isFullScreen ? 0 : Math.max(DeviceAccess.statusBarHeight, DeviceAccess.safeInsetTop)
        Behavior on bottomPadding { NumberAnimation {duration: 100 } }
        Behavior on height { NumberAnimation {duration: 100 } }
        Behavior on topPadding { NumberAnimation {duration: 100 } }
        Behavior on y { NumberAnimation {duration: 100 } }
        width: isLandScape ? Math.max(parent.width*.65, 300) : parent.width
        height: parent.height
                - (isFullScreen ? 0
                                : (Math.max(DeviceAccess.statusBarHeight,
                                            DeviceAccess.safeInsetTop)
                                   + (Helpers.isIos ? 0
                                                    : Math.max(DeviceAccess.navigationBarHeight,
                                                               DeviceAccess.safeInsetBottom))))
        edge: Qt.RightEdge
        dim: false
        bottomPadding: 20 + isFullScreen ? DeviceAccess.safeInsetBottom : 0
        leftPadding: isLandScape ? 20 : Math.max(20, DeviceAccess.safeInsetLeft)
        rightPadding: Math.max(20, DeviceAccess.safeInsetRight)
        topPadding: isFullScreen ? Math.max(20, DeviceAccess.safeInsetTop) : 20
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
        BusyIndicator {
            anchors.centerIn: parent
            running: store.purchasing
        }
    }
    Popup {
            id: purchasingPopup
            width: 0
            height: 0
            modal: true
            visible: store.purchasing
            closePolicy: Popup.NoAutoClose
    }
    Dialog {
        id: tipthanksPopup
        anchors.centerIn: parent
        clip: true
        modal: true
        title: qsTr("Thank you for your support!")
        width: Math.max(root.width/2, header.implicitWidth)
        z: 1
        Label {
            horizontalAlignment: Label.Center
            width: parent.width
            wrapMode: Text.WordWrap
            text: "❤\n\n%1".arg(qsTr("It means a lot to us."))
        }
    }
    Dialog {
        id: failTransactionPopup
        anchors.centerIn: parent
        clip: true
        modal: true
        title: qsTr("Oops...")
        width: Math.max(root.width/2, header.implicitWidth)
        z: 1
        Label {
            horizontalAlignment: Label.Center
            width: parent.width
            wrapMode: Text.WordWrap
            text: "%1\n\n%2".arg(failedProductErrorSrting).arg(qsTr("Do you want to try again?"))
        }
        standardButtons: Dialog.No | Dialog.Yes
        onAccepted: failedProduct.purchase()
        onRejected: store.purchasing = false
    }
    Dialog {
        id: howtoPopup
        anchors.centerIn: parent
        background.opacity: .95
        clip: true
        implicitWidth: Math.max(root.width/2, header.implicitWidth) + 2 * padding
        title: qsTr("Welcome to WordClock++")
        z: 1
        ColumnLayout {
            anchors { fill: parent; margins: howtoPopup.margins }  // @disable-check M16  @disable-check M31
            Label {
                Layout.fillHeight: true
                Layout.fillWidth: true
                fontSizeMode: Label.Fit
                minimumPixelSize: 1
                wrapMode: Text.WordWrap
                text: "\%1.\n\n%2.".arg(qsTr("Thank you for downloading this application, we wish you a pleasant use"))
                .arg(Helpers.isMobile ? qsTr("Please touch the screen outside this window to close it and open the settings menu.")
                : qsTr("Please right-click outside this window to close it and open the settings menu."))
            }
            CheckBox {
                id: hidePopupCheckbox
                indicator.opacity: 0.5
                text: qsTr("Don't show this again")
            }
        }
        Connections { target: settingPanel; function onOpened() { howtoPopup.close() } }
        onClosed: root.showWelcome = !hidePopupCheckbox.checked
        closePolicy: Dialog.NoAutoClose
        Component.onCompleted: {
            header.background.visible = false
            if (!Helpers.isWebAssembly && showWelcome)
                open()
        }
    }
    Dialog {
        id: badReviewPopup
        anchors.centerIn: parent
        clip: true
        modal: true
        title: qsTr("Thanks for your review")
        width: Math.max(root.width/2, header.implicitWidth)
        z: 1
        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("\
We are sorry to learn that you are not satisfied with this application.\
\nBut thanks to you, we will be able to improve it even more.\
\nSend us your suggestions and we will take it into account.")
        }
        onAccepted: Qt.openUrlExternally("mailto:contact@kokleeko.io?subject=%1".arg(
                                             qsTr("Suggestions for WordClock")))
        standardButtons: Dialog.Close | Dialog.Ok
    }
    Loader { active: Helpers.isMobile; source: "WebAccess.qml"; onLoaded: webView = item.webView }
}
