/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts
import QtWebView 1.15 as QtWebView

import DeviceAccess 1.0

import "qrc:/js/Helpers.js" as HelpersJS
import "qrc:/js/WebAccess.js" as WebAccessJS

QtControls.Drawer
{
    id: webAccess

    property alias webView: webView
    property var webAccessJS: null

    edge: Qt.RightEdge
    height: parent.height -
            (isFullScreen ? 0 : (Math.max(DeviceAccess.managers.screenSize.statusBarHeight,
                                          DeviceAccess.managers.screenSize.safeInsetTop) +
                                 (HelpersJS.isIos ? 0
                                                  : Math.max(DeviceAccess.managers.screenSize.navigationBarHeight,
                                                             DeviceAccess.managers.screenSize.safeInsetBottom))))
    interactive: opened
    width: parent.width
    y: isFullScreen ? 0 : Math.max(DeviceAccess.managers.screenSize.statusBarHeight,
                                   DeviceAccess.managers.screenSize.safeInsetTop)
    z: 1

    QtQuick.Component.onCompleted: webAccessJS = new WebAccessJS.Object(this, isDebug)

    QtLayouts.ColumnLayout
    {
        anchors.fill: parent  // @disable-check M16 @disable-check M31
        spacing: 0

        QtControls.ToolBar
        {
            QtLayouts.Layout.fillWidth: true
            leftPadding: DeviceAccess.managers.screenSize.safeInsetLeft
            rightPadding: DeviceAccess.managers.screenSize.safeInsetRight
            topPadding: DeviceAccess.managers.screenSize.safeInsetTop

            QtLayouts.RowLayout
            {
                anchors.fill: parent  // @disable-check M16 @disable-check M31

                QtControls.ToolButton
                {
                    icon.source: "qrc:/assets/close.svg"
                    onClicked: webAccess.close()
                }
                QtControls.ToolSeparator { }
                QtControls.ToolButton
                {
                    icon.source: "qrc:/assets/back.svg"
                    onClicked: webAccessJS.openUrl(webView.base_url, true)
                }
                QtControls.ToolButton
                {
                    icon.source: "qrc:/assets/refresh.svg"
                    onClicked: webView.reload()
                }
                QtControls.Label
                {
                    QtLayouts.Layout.fillWidth: true
                    elide: QtControls.Label.ElideRight
                    font.bold: true
                    horizontalAlignment: Qt.AlignHCenter
                    text: webView.title
                    verticalAlignment: Qt.AlignVCenter
                }
                QtControls.ToolButton
                {
                    icon.source: "qrc:/assets/browser.svg"
                    onClicked: Qt.openUrlExternally(webView.base_url)
                }
            }
        }
        QtQuick.Item
        {
            QtLayouts.Layout.fillHeight: true
            QtLayouts.Layout.fillWidth: true

            QtWebView.WebView
            {
                id: webView

                property int status
                property string base_url
                property string error_string
                property string title

                function openUrl(url) { webAccessJS.openUrl(url); }

                visible: status === QtWebView.WebView.LoadSucceededStatus
                anchors.fill: parent

                onLoadingChanged: (loadRequest) => webAccessJS.loadingChanged(loadRequest)
            }
            QtControls.BusyIndicator
            {
                anchors.centerIn: parent
                running: visible
                visible: webView.status === QtWebView.WebView.LoadStartedStatus
            }
            QtQuick.Rectangle
            {
                id: errorPage

                anchors.fill: parent
                color: palette.button
                visible: webView.status === QtWebView.WebView.LoadFailedStatus
                QtControls.Label
                {
                    anchors { fill: parent; margins: parent.width/4 }
                    font.pointSize: headings.h1
                    horizontalAlignment: QtControls.Label.AlignHCenter
                    maximumLineCount: 10
                    style: QtControls.Label.Raised
                    styleColor: palette.base
                    text: webView.error_string
                    verticalAlignment: QtControls.Label.AlignVCenter
                    wrapMode: QtControls.Label.WordWrap
                }
            }
        }
    }
}
