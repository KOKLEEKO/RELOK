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

import "qrc:/qml/popups" as Popups

import "qrc:/js/Helpers.js" as HelpersJS

QtControls.ApplicationWindow
{
    id: root

    property QtWebView.WebView webView: null
    property alias badReviewPopup: badReviewPopup
    property alias headings: headings
    property bool aboutToQuit: false
    property bool isWidget: false
    property bool isLeftHanded: Boolean(parseInt(DeviceAccess.managers.persistence.value("Appearance/hand_preference",
                                                                                         1)))
    property bool showWelcome: DeviceAccess.managers.persistence.value("Advanced/show_welcome", true)
    property real tmpOpacity: root.opacity
    readonly property size size: Qt.size(width, height)
    readonly property bool isFullScreen: HelpersJS.isIos ? DeviceAccess.managers.screenSize.prefersStatusBarHidden
                                                         : visibility === QtWindows.Window.FullScreen
    readonly property bool isLandScape: width > height
    property alias tips: tips
    property int minimumSize: 287

    color: wordClock.background_color
    height: DeviceAccess.managers.persistence.value("Appearance/height", 480)
    minimumHeight: minimumSize
    minimumWidth: minimumSize
    opacity: HelpersJS.isDesktop ? DeviceAccess.managers.persistence.value("Advanced/opacity", 1) : 1
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
            DeviceAccess.managers.persistence.setValue("Advanced/widget", isWidget)
        }
    }
    onVisibilityChanged:
    {
        if (HelpersJS.isMobile && !settingsPanel.opened)
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
            console.info(paletteString)
        }

        //for (var prop in Qt.rgba(1,0,0,0))
        //  console.debug(prop)
        //console.debug(Qt.rgba(1,0,0,0).hslLightness)
    }

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

        QtQuick.PropertyAction { targets: [wordClock, settingsPanel]; property:"opacity"; value: 0 }
        QtQuick.ScriptAction
        {
            script:
            {
                viewConfigurationChangedSequence.isMenuOpened = settingsPanel.opened
                settingsPanel.close()
            }
        }
        QtQuick.PauseAnimation { duration: 500 }
        QtQuick.PropertyAnimation { targets: [wordClock, settingsPanel]; property: "opacity"; duration: 500; from: 0; to: 1 }
        QtQuick.ScriptAction { script: if (viewConfigurationChangedSequence.isMenuOpened) settingsPanel.open() }
    }
    QtQuick.SequentialAnimation
    {
        id: visibilityChangedSequence

        alwaysRunToEnd: true

        QtQuick.PropertyAction { target: wordClock; property:"opacity"; value: 0 }
        QtQuick.PropertyAnimation { targets: wordClock; property: "opacity"; duration: 350; from: 0; to: 1 }
    }
    Headings { id: headings }
    Tips { id: tips }
    SystemPalette { id: systemPalette }
    WordClock { id: wordClock }
    ClickableArea { }
    SettingsPanel { id: settingsPanel }

    Popups.PurchasingPopup { }
    Popups.TipsThanksPopup { id: tipsThanksPopup }
    Popups.FailedTransactionPopup { id: failedTransactionPopup }
    Popups.WelcomePopup { id: welcomePopup }
    Popups.BadReviewPopup { id: badReviewPopup }

    QtQuick.Loader { active: HelpersJS.isMobile; source: "WebAccess.qml"; onLoaded: webView = item.webView }
}
