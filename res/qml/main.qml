/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
//import QtDigitalAdvertising 1.1
import QtPurchasing 1.15 as QtPurchasing
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts
import QtQuick.Window 2.15 as QtWindows
import QtWebView 1.15 as QtWebView

import DeviceAccess 1.0

import "qrc:/js/Helpers.js" as HelpersJS

QtControls.ApplicationWindow
{
    id: root

    property QtWebView.WebView webView: null
    property alias badReviewPopup: badReviewPopup
    property alias headings: headings
    property bool aboutToQuit: false
    property bool isWidget: false
    property bool showWelcome: DeviceAccess.managers.persistence.value("Welcome/showPopup", true)
    property real tmpOpacity: root.opacity
    property size size: Qt.size(width, height)
    readonly property bool isFullScreen: HelpersJS.isIos ? DeviceAccess.managers.screenSize.prefersStatusBarHidden
                                                         : visibility === QtWindows.Window.FullScreen
    readonly property bool isLandScape: width > height

    //Tips
    property alias store: store
    property string failedProductErrorString: ""
    property var failedProduct: null
    property var products: ({})
    readonly property var tipsModel: [
        { name: "bone"    , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Bone (for Denver)") },
        { name: "coffee"  , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Coffee")            },
        { name: "cookie"  , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Cookie")            },
        { name: "icecream", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me an Ice Cream")        },
        { name: "beer"    , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Beer")              },
        { name: "burger"  , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Burger")            },
        { name: "wine"    , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Wine Bottle")       }
    ]

    property int minimumSize: 287

    color: wordClock.background_color
    height: DeviceAccess.managers.persistence.value("Appearance/height", 480)
    minimumHeight: minimumSize
    minimumWidth: minimumSize
    opacity: DeviceAccess.managers.persistence.value("Appearance/opacity", 1)
    visibility: HelpersJS.isIos ? QtWindows.Window.FullScreen : QtWindows.Window.AutomaticVisibility
    visible: true
    width: DeviceAccess.managers.persistence.value("Appearance/width", 640)

    onClosing:
    {
        aboutToQuit = true
        if (HelpersJS.isAndroid)
        {
            close.accepted = false
            DeviceAccess.moveTaskToBack()
        }
        if (!isFullScreen)
        {
            DeviceAccess.managers.persistence.setValue("Appearance/width", width)
            DeviceAccess.managers.persistence.setValue("Appearance/height", height)
        }
    }
    onIsFullScreenChanged:
    {
        if (!aboutToQuit)
        {
            DeviceAccess.managers.persistence.setValue("Appearance/fullScreen", isFullScreen)
            if (HelpersJS.isDesktop)
            {
                if (isFullScreen)
                {
                    tmpOpacity = root.opacity
                    root.opacity = 1
                }
                else
                {
                    root.opacity = tmpOpacity
                }
            }
        }
    }
    onIsWidgetChanged:
    {
        if (HelpersJS.isDesktop)
        {
            DeviceAccess.managers.persistence.setValue("Appearance/widget", isWidget)
        }
    }
    onVisibilityChanged:
    {
        if (HelpersJS.isMobile && !settingPanel.opened)
        {
            visibilityChangedSequence.start()
        }
    }
    QtQuick.Component.onCompleted:
    {
        console.info("pixelDensity", QtWindows.Screen.pixelDensity)

        if (HelpersJS.isAndroid)
        {
            onSizeChanged.connect(DeviceAccess.managers.screenSize.updateSafeAreaInsets)
        }

        if (isDebug)
        {
            var paletteString = "↓\npalette {\n";
            for (var prop in palette) paletteString += "  %1: \"%2\"\n".arg(prop).arg(palette[prop])
            paletteString += "}"
            console.log(paletteString)
        }

        //for (var prop in Qt.rgba(1,0,0,0))
        //  console.log(prop)
        //console.log(Qt.rgba(1,0,0,0).hslLightness)
    }

    QtQuick.Instantiator
    {
        model: tipsModel

        onObjectAdded:
        {
            store.products.push(object)
            products[model[index].name] = object
            productsChanged()
        }

        QtPurchasing.Product
        {
            identifier: "io.kokleeko.wordclock.tip.%1".arg(modelData.name)
            type: QtPurchasing.Product.Consumable

            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, this)
        }
    }
    QtPurchasing.Store
    {
        id: store

        property bool purchasing: false

        function failed(transaction, product)
        {
            if (transaction)
            {
                transaction.finalize()
                failedProduct = product
                failedProductErrorString = transaction.errorString
                failTransactionPopup.open()
            }
            else
            {
                purchasing = false
            }
        }
        function success(transaction)
        {
            if (transaction)
            {
                transaction.finalize()
            }
            tipThanksPopup.open()
            purchasing = false
        }

        onPurchasingChanged:
        {
            if (!purchasing)
            {
                failedProduct = null
                failedProductErrorString = ""
            }
        }
    }

    QtQuick.QtObject
    {
        id: headings

        readonly property real h0: 40
        readonly property real h1: 32
        readonly property real h2: 26
        readonly property real h3: 22
        readonly property real h4: 20
        readonly property real p1: 13
        readonly property real p2: 11
    }

    QtQuick.SystemPalette { id: systemPalette }
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

    QtQuick.Connections
    {
        function onViewConfigurationChanged()
        {
            viewConfigurationChangedSequence.start()
        }
        target: DeviceAccess.managers.screenSize
    }
    QtQuick.SequentialAnimation
    {
        id: viewConfigurationChangedSequence

        property bool isMenuOpened

        alwaysRunToEnd: true

        QtQuick.PropertyAction { targets: [wordClock, settingPanel]; property:"opacity"; value: 0 }
        QtQuick.ScriptAction
        {
            script:
            {
                viewConfigurationChangedSequence.isMenuOpened = settingPanel.opened
                settingPanel.close()
            }
        }
        QtQuick.PauseAnimation { duration: 500 }
        QtQuick.PropertyAnimation { targets: [wordClock, settingPanel]; property: "opacity"; duration: 500; from: 0; to: 1 }
        QtQuick.ScriptAction { script: if (viewConfigurationChangedSequence.isMenuOpened) settingPanel.open() }
    }
    QtQuick.SequentialAnimation
    {
        id: visibilityChangedSequence

        alwaysRunToEnd: true

        QtQuick.PropertyAction { target: wordClock; property:"opacity"; value: 0 }
        QtQuick.PropertyAnimation { targets: wordClock; property: "opacity"; duration: 350; from: 0; to: 1 }
    }
    QtQuick.MouseArea
    {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent

        onClicked: (mouse) =>
                   {
                       if (!HelpersJS.isDesktop || mouse.button === Qt.RightButton)
                       {
                           settingPanel.open()
                       }
                   }
        onPressAndHold: (mouse) =>
                        {
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
                            }
                            else
                            {
                                HelpersJS.updateVisibility(root)
                            }
                        }
    }
    WordClock
    {
        id: wordClock
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height - (isFullScreen ? 0
                                              : (Math.max(DeviceAccess.managers.screenSize.statusBarHeight,
                                                          DeviceAccess.managers.screenSize.safeInsetTop)
                                                 + Math.max(DeviceAccess.managers.screenSize.navigationBarHeight,
                                                            DeviceAccess.managers.screenSize.safeInsetBottom)))
        width: parent.width - (DeviceAccess.managers.screenSize.safeInsetLeft
                               + DeviceAccess.managers.screenSize.safeInsetRight) -
               (isLandScape ? settingPanel.position * (settingPanel.width -
                                                       DeviceAccess.managers.screenSize.safeInsetRight)
                            : 0)
        x: DeviceAccess.managers.screenSize.safeInsetLeft
    }
    QtControls.Drawer
    {
        id: settingPanel

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
        edge: Qt.RightEdge
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

        QtQuick.Behavior on bottomPadding { QtQuick.NumberAnimation {duration: 100 } }
        QtQuick.Behavior on height { QtQuick.NumberAnimation {duration: 100 } }
        QtQuick.Behavior on topPadding { QtQuick.NumberAnimation {duration: 100 } }
        QtQuick.Behavior on y { QtQuick.NumberAnimation {duration: 100 } }
        SettingsMenu { }
        QtControls.BusyIndicator { anchors.centerIn: parent; running: store.purchasing && !failTransactionPopup.opened }
    }
    QtControls.Popup
    {
        id: purchasingPopup

        background: null
        closePolicy: QtControls.Popup.NoAutoClose
        modal: true
        visible: store.purchasing
        z: 1
    }
    QtControls.Dialog
    {
        id: tipThanksPopup

        anchors.centerIn: parent
        clip: true
        modal: true
        title: qsTr("Thank you for being so supportive!") + DeviceAccess.managers.translation.emptyString
        width: header.implicitWidth
        z: 1

        QtControls.Label
        {
            horizontalAlignment: QtControls.Label.Center
            text: "❤\n\n%1".arg(qsTr("It means a lot to us.")) + DeviceAccess.managers.translation.emptyString
            width: parent.width
            wrapMode: QtControls.Label.WordWrap
        }
    }
    QtControls.Dialog
    {
        id: failTransactionPopup

        anchors.centerIn: parent
        clip: true
        modal: true
        standardButtons: QtControls.Dialog.No | QtControls.Dialog.Yes
        title: qsTr("Oops...") + DeviceAccess.managers.translation.emptyString
        width: Math.max(root.width/2, header.implicitWidth)
        z: 1

        onAccepted: failedProduct.purchase()
        onRejected: store.purchasing = false
        QtQuick.Component.onCompleted: {
            standardButton(QtControls.Dialog.No).text = Qt.binding(() => qsTranslate("QPlatformTheme", "No") +
                                                                   DeviceAccess.managers.translation.emptyString)
            standardButton(QtControls.Dialog.Yes).text = Qt.binding(() => qsTranslate("QPlatformTheme", "Yes") +
                                                                    DeviceAccess.managers.translation.emptyString)
        }

        QtControls.Label
        {
            horizontalAlignment: QtControls.Label.Center
            width: parent.width
            wrapMode: QtControls.Label.WordWrap
            text: ("%1.\n\n%2".arg(failedProductErrorString ?
                                       failedProductErrorString :
                                       qsTr("Something went wrong..."))).arg(qsTr("Do you want to try again?")) +
                  DeviceAccess.managers.translation.emptyString
        }
    }
    QtControls.Dialog
    {
        id: welcomePopup

        anchors.centerIn: parent
        background.opacity: .95
        clip: true
        closePolicy: QtControls.Dialog.NoAutoClose
        implicitWidth: Math.max(root.width/2, header.implicitWidth) + 2 * padding
        title: qsTr("Welcome to %1").arg(Qt.application.name) + DeviceAccess.managers.translation.emptyString
        z: 1

        onClosed: root.showWelcome = !hidePopupCheckbox.checked
        QtQuick.Component.onCompleted: { header.background.visible = false; if (!HelpersJS.isWasm && showWelcome) open() }

        QtLayouts.ColumnLayout
        {
            anchors { fill: parent; margins: welcomePopup.margins }  // @disable-check M16  @disable-check M31
            QtControls.Label
            {
                QtLayouts.Layout.fillHeight: true
                QtLayouts.Layout.fillWidth: true
                fontSizeMode: QtControls.Label.Fit
                minimumPixelSize: 1

                text:
                    "\%1.\n\n%2.".arg(qsTr("We thank you for downloading this application and wish you good use.")).arg(
                        HelpersJS.isMobile ? qsTr("Please touch the screen outside this pop-up window to close it and \
open the settings menu.") : qsTr("Please right-click outside this pop-up window to \
close it and open the settings menu.")) + DeviceAccess.managers.translation.emptyString
                wrapMode: QtControls.Label.WordWrap
            }
            QtControls.CheckBox
            {
                id: hidePopupCheckbox

                indicator.opacity: 0.5
                text: qsTr("Don't show this again") + DeviceAccess.managers.translation.emptyString
            }
        }
        QtQuick.Connections { target: settingPanel; function onOpened() { welcomePopup.close() } }
    }
    QtControls.Dialog
    {
        id: badReviewPopup

        anchors.centerIn: parent
        clip: true
        modal: true
        standardButtons: QtControls.Dialog.Close | QtControls.Dialog.Ok
        title: qsTr("Thanks for your review") + DeviceAccess.managers.translation.emptyString
        width: Math.max(root.width/2, header.implicitWidth)
        z: 1

        onAccepted: Qt.openUrlExternally("mailto:contact@kokleeko.io?subject=%1"
                                         .arg(qsTr("Suggestions for %1").arg(Qt.application.name))) +
                    DeviceAccess.managers.translation.emptyString

        QtQuick.Component.onCompleted:
        {
            standardButton(QtControls.Dialog.Close).text = Qt.binding(() => qsTranslate("QPlatformTheme", "Close") +
                                                                      DeviceAccess.managers.translation.emptyString)
            standardButton(QtControls.Dialog.Ok).text = Qt.binding(() => qsTranslate("QPlatformTheme", "OK") +
                                                                   DeviceAccess.managers.translation.emptyString)
        }

        QtControls.Label
        {
            text: qsTr("We are sorry to find out that you are not completely satisfied with this application...
With your feedback, we can make it even better!

Your suggestions will be taken into account.") + DeviceAccess.managers.translation.emptyString
            width: parent.width
            wrapMode: QtControls.Label.WordWrap
        }
    }
    QtQuick.Loader { active: HelpersJS.isMobile; source: "WebAccess.qml"; onLoaded: webView = item.webView }
}
