/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
//import QtDigitalAdvertising 1.1
import QtPurchasing 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtWebView 1.15

import DeviceAccess 1.0

import "qrc:/js/Helpers.js" as HelpersJS

ApplicationWindow {
    id: root
    property size size: Qt.size(width, height)
    property bool aboutToQuit: false
    property WebView webView
    property alias headings: headings
    property alias badReviewPopup: badReviewPopup
    readonly property bool isLandScape: width > height
    readonly property bool isFullScreen: HelpersJS.isIos ? DeviceAccess.managers.screenSize.prefersStatusBarHidden
                                                       : visibility === Window.FullScreen
    property bool isWidget: false
    property bool showWelcome: DeviceAccess.managers.persistence.value("Welcome/showPopup", true)
    property real tmpOpacity: root.opacity

    //Tips
    property var failedProduct: null
    property string failedProductErrorString: ""
    property alias store: store
    property var products: ({})
    readonly property var tipsModel: [ { name: "bone", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Bone (for Denver)") },
        /**/                           { name: "coffee", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Coffee") },
        /**/                           { name: "cookie", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Cookie")},
        /**/                           { name: "icecream", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me an Ice Cream")},
        /**/                           { name: "beer", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Beer") },
        /**/                           { name: "burger", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Burger") },
        /**/                           { name: "wine", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Wine Bottle") }
    ]

    property int minimumSize: 287

    width: DeviceAccess.managers.persistence.value("Appearance/width", 640)
    height: DeviceAccess.managers.persistence.value("Appearance/height", 480)
    minimumWidth: minimumSize
    minimumHeight: minimumSize
    visible: true
    visibility: HelpersJS.isIos ? Window.FullScreen : Window.AutomaticVisibility
    opacity: DeviceAccess.managers.persistence.value("Appearance/opacity", 1)
    color: wordClock.background_color

    onClosing: {
        aboutToQuit = true
        if (HelpersJS.isAndroid) { close.accepted = false; DeviceAccess.moveTaskToBack() }
        if (!isFullScreen) {
            DeviceAccess.managers.persistence.setValue("Appearance/width", width)
            DeviceAccess.managers.persistence.setValue("Appearance/height", height)
        }
    }
    onIsFullScreenChanged: {
        if (!aboutToQuit) {
            DeviceAccess.managers.persistence.setValue("Appearance/fullScreen", isFullScreen)
            if (HelpersJS.isDesktop) {
                if (isFullScreen) {
                    tmpOpacity = root.opacity
                    root.opacity = 1
                } else {
                    root.opacity = tmpOpacity
                }
            }
        }
    }
    onIsWidgetChanged: if (HelpersJS.isDesktop) DeviceAccess.managers.persistence.setValue("Appearance/widget", isWidget)
    onVisibilityChanged: if (HelpersJS.isMobile && !settingPanel.opened) visibilityChangedSequence.start()
    Component.onCompleted: {
        console.log(Object.keys(DeviceAccess.managers))
        console.info("pixelDensity", Screen.pixelDensity)
        if (HelpersJS.isAndroid) onSizeChanged.connect(DeviceAccess.managers.screenSize.updateSafeAreaInsets)

        if (isDebug) {
            var paletteString = "↓\npalette {\n";
            for (var prop in palette) paletteString += "  %1: \"%2\"\n".arg(prop).arg(palette[prop])
            paletteString += "}"
            console.log(paletteString)
        }

        //for (var prop in Qt.rgba(1,0,0,0))
        //  console.log(prop)
        //console.log(Qt.rgba(1,0,0,0).hslLightness)
    }

    Instantiator {
        model: tipsModel
        onObjectAdded: { store.products.push(object); products[model[index].name] = object; productsChanged() }
        Product {
            identifier: "io.kokleeko.wordclock.tip.%1".arg(modelData.name)
            type: Product.Consumable
            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, this)
        }
    }
    Store {
        id: store
        property bool purchasing: false
        function success(transaction) {
            if (transaction) transaction.finalize()
            tipthanksPopup.open()
            purchasing = false
        }
        function failed(transaction, product) {
            if (transaction) {
                transaction.finalize()
                failedProduct = product
                failedProductErrorString = transaction.errorString
                failTransactionPopup.open()
            } else
                purchasing = false
        }
        onPurchasingChanged: if (!purchasing) { failedProduct = null; failedProductErrorString = "" }
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
        target: DeviceAccess.managers.screenSize
        function onViewConfigurationChanged() { viewConfigurationChangedSequence.start() }
    }
    SequentialAnimation {
        id: viewConfigurationChangedSequence
        alwaysRunToEnd: true
        property bool isMenuOpened
        PropertyAction { targets: [wordClock, settingPanel]; property:"opacity"; value: 0 }
        ScriptAction {
            script: { viewConfigurationChangedSequence.isMenuOpened = settingPanel.opened; settingPanel.close() }
        }
        PauseAnimation { duration: 500 }
        PropertyAnimation { targets: [wordClock, settingPanel]; property: "opacity"; duration: 500; from: 0; to: 1 }
        ScriptAction { script: if (viewConfigurationChangedSequence.isMenuOpened) settingPanel.open() }
    }
    SequentialAnimation {
        id: visibilityChangedSequence
        alwaysRunToEnd: true
        PropertyAction { target: wordClock; property:"opacity"; value: 0 }
        PropertyAnimation { targets: wordClock; property: "opacity"; duration: 350; from: 0; to: 1 }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressAndHold: (mouse) => {
                            if (HelpersJS.isDesktop)
                            {
                                switch (mouse.button)
                                {
                                    case Qt.RightButton:
                                    HelpersJS.updateDisplayMode(root)
                                    break;
                                    case Qt.LeftButton:
                                    HelpersJS.updateVisibility(root)
                                    break;
                                }
                            } else {
                                HelpersJS.updateVisibility(root)
                            }
                        }
        onClicked: (mouse) => {
                       if (!HelpersJS.isDesktop || mouse.button === Qt.RightButton)
                       settingPanel.open()
                   }
    }

    WordClock {
        id: wordClock
        anchors.verticalCenter: parent.verticalCenter
        x: DeviceAccess.managers.screenSize.safeInsetLeft
        height: parent.height - (isFullScreen ? 0
                                              : (Math.max(DeviceAccess.managers.screenSize.statusBarHeight, DeviceAccess.managers.screenSize.safeInsetTop)
                                                 + Math.max(DeviceAccess.managers.screenSize.navigationBarHeight,
                                                            DeviceAccess.managers.screenSize.safeInsetBottom)))
        width: parent.width - (DeviceAccess.managers.screenSize.safeInsetLeft + DeviceAccess.managers.screenSize.safeInsetRight)
               - (isLandScape ? settingPanel.position * (settingPanel.width - DeviceAccess.managers.screenSize.safeInsetRight) : 0)
    }

    Drawer {
        id: settingPanel
        y: isFullScreen ? 0 : Math.max(DeviceAccess.managers.screenSize.statusBarHeight, DeviceAccess.managers.screenSize.safeInsetTop)
        Behavior on bottomPadding { NumberAnimation {duration: 100 } }
        Behavior on height { NumberAnimation {duration: 100 } }
        Behavior on topPadding { NumberAnimation {duration: 100 } }
        Behavior on y { NumberAnimation {duration: 100 } }
        width: isLandScape ? Math.max(parent.width*.65, 300) : parent.width
        height: parent.height
                - (isFullScreen ? 0
                                : (Math.max(DeviceAccess.managers.screenSize.statusBarHeight,
                                            DeviceAccess.managers.screenSize.safeInsetTop)
                                   + (HelpersJS.isIos ? 0
                                                    : Math.max(DeviceAccess.managers.screenSize.navigationBarHeight,
                                                               DeviceAccess.managers.screenSize.safeInsetBottom))))
        edge: Qt.RightEdge
        dim: false
        bottomPadding: 20 + isFullScreen ? DeviceAccess.managers.screenSize.safeInsetBottom : 0
        leftPadding: isLandScape ? 20 : Math.max(20, DeviceAccess.managers.screenSize.safeInsetLeft)
        rightPadding: Math.max(20, DeviceAccess.managers.screenSize.safeInsetRight)
        topPadding: isFullScreen ? Math.max(20, DeviceAccess.managers.screenSize.safeInsetTop) : 20
        background: Item {
            clip: true
            opacity: isLandScape ? 1 : .925
            Rectangle {
                anchors { fill: parent; rightMargin: -radius }
                radius: Math.min(parent.height, parent.width)*.011
                color: palette.window
            }
        }
        SettingsMenu { }
        BusyIndicator { anchors.centerIn: parent; running: store.purchasing && !failTransactionPopup.opened }
    }
    Popup {
        id: purchasingPopup
        modal: true
        z: 1
        background: null
        visible: store.purchasing
        closePolicy: Popup.NoAutoClose
    }
    Dialog {
        id: tipthanksPopup
        anchors.centerIn: parent
        clip: true
        modal: true
        title: qsTr("Thank you for being so supportive!") + DeviceAccess.managers.translation.emptyString
        width: header.implicitWidth
        z: 1
        Label {
            horizontalAlignment: Label.Center
            width: parent.width
            wrapMode: Text.WordWrap
            text: "❤\n\n%1".arg(qsTr("It means a lot to us.")) + DeviceAccess.managers.translation.emptyString
        }
    }
    Dialog {
        id: failTransactionPopup
        anchors.centerIn: parent
        clip: true
        modal: true
        title: qsTr("Oops...") + DeviceAccess.managers.translation.emptyString
        width: Math.max(root.width/2, header.implicitWidth)
        z: 1
        Label {
            horizontalAlignment: Label.Center
            width: parent.width
            wrapMode: Text.WordWrap
            text: ("%1.\n\n%2".arg(failedProductErrorString ? failedProductErrorString
                                                            : qsTr("Something went wrong...")))
            /**/              .arg(qsTr("Do you want to try again?")) + DeviceAccess.managers.translation.emptyString
        }
            standardButtons: Dialog.No | Dialog.Yes
            onAccepted: failedProduct.purchase()
            onRejected: store.purchasing = false
            Component.onCompleted: {
                standardButton(Dialog.No).text = Qt.binding(() => qsTranslate("QPlatformTheme", "No")
                                                            + DeviceAccess.managers.translation.emptyString)
                standardButton(Dialog.Yes).text = Qt.binding(() => qsTranslate("QPlatformTheme", "Yes")
                                                             + DeviceAccess.managers.translation.emptyString)
            }
        }
        Dialog {
            id: welcomePopup
            anchors.centerIn: parent
            background.opacity: .95
            clip: true
            implicitWidth: Math.max(root.width/2, header.implicitWidth) + 2 * padding
            title: qsTr("Welcome to %1").arg(Qt.application.name) + DeviceAccess.managers.translation.emptyString
            z: 1
            ColumnLayout {
                anchors { fill: parent; margins: welcomePopup.margins }  // @disable-check M16  @disable-check M31
                Label {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    fontSizeMode: Label.Fit
                    minimumPixelSize: 1
                    wrapMode: Text.WordWrap
                    text:
                        "\%1.\n\n%2.".arg(qsTr("We thank you for downloading this application and wish you good use."))
                    /**/             .arg(HelpersJS.isMobile ? qsTr("Please touch the screen outside this pop-up window \
to close it and open the settings menu.")                  : qsTr("Please right-click outside this pop-up window to \
close it and open the settings menu.")) + DeviceAccess.managers.translation.emptyString
                }
                    CheckBox {
                        id: hidePopupCheckbox
                        indicator.opacity: 0.5
                        text: qsTr("Don't show this again") + DeviceAccess.managers.translation.emptyString
                    }
                }
                Connections { target: settingPanel; function onOpened() { welcomePopup.close() } }
                onClosed: root.showWelcome = !hidePopupCheckbox.checked
                closePolicy: Dialog.NoAutoClose
                Component.onCompleted: { header.background.visible = false; if (!HelpersJS.isWasm && showWelcome) open() }
            }
            Dialog {
                id: badReviewPopup
                anchors.centerIn: parent
                clip: true
                modal: true
                title: qsTr("Thanks for your review") + DeviceAccess.managers.translation.emptyString
                width: Math.max(root.width/2, header.implicitWidth)
                z: 1
                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("We are sorry to find out that you are not completely satisfied with this application...
With your feedback, we can make it even better!

Your suggestions will be taken into account.") + DeviceAccess.managers.translation.emptyString
                }
                onAccepted: Qt.openUrlExternally("mailto:contact@kokleeko.io?subject=%1"
                                                 .arg(qsTr("Suggestions for %1").arg(Qt.application.name)))
                            + DeviceAccess.managers.translation.emptyString
                standardButtons: Dialog.Close | Dialog.Ok
                Component.onCompleted: {
                    standardButton(Dialog.Close).text = Qt.binding(() => qsTranslate("QPlatformTheme", "Close")
                                                                   + DeviceAccess.managers.translation.emptyString)
                    standardButton(Dialog.Ok).text = Qt.binding(() => qsTranslate("QPlatformTheme", "OK")
                                                                + DeviceAccess.managers.translation.emptyString)
                }
            }
            Loader { active: HelpersJS.isMobile; source: "WebAccess.qml"; onLoaded: webView = item.webView }
        }
