/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts

import DeviceAccess 1.0

import "qrc:/js/Helpers.js" as HelpersJS

import "qrc:/qml/models" as Models

QtControls.Dialog
{
    id: welcomePopup

    anchors.centerIn: parent
    background.opacity: .95
    clip: true
    closePolicy: QtControls.Dialog.NoAutoClose
    implicitWidth: Math.max(root.width/2, header.implicitWidth, footer.implicitWidth) + 2 * padding
    title: qsTr("Welcome to %1 ( %2 )").arg(Qt.application.name).arg(Qt.application.version) +
           DeviceAccess.managers.translation.emptyString
    footer: QtControls.CheckBox
    {
        id: hidePopupCheckbox

        indicator.opacity: 0.5
        padding: welcomePopup.padding
        text: qsTr("<i>Don't show this again</i>") + DeviceAccess.managers.translation.emptyString
    }

    onClosed: showWelcome = !hidePopupCheckbox.checked
    QtQuick.Component.onCompleted:
    {
        header.background.visible = false
        if (showWelcome)
        {
            open();
        }
    }

    QtLayouts.ColumnLayout
    {
        anchors { fill: parent; margins: welcomePopup.margins }  // @disable-check M16  @disable-check M31
        QtControls.Label
        {
            QtLayouts.Layout.fillWidth: true
            font: GeneralFont
            fontSizeMode: QtControls.Label.Fit
            minimumPixelSize: 1
            text: qsTr("We hope you enjoy using it.") + DeviceAccess.managers.translation.emptyString
            textFormat: QtControls.Label.RichText
            wrapMode: QtControls.Label.WordWrap
        }
        QtControls.Pane
        {
            QtLayouts.Layout.fillHeight: true
            QtLayouts.Layout.fillWidth: true

            QtLayouts.ColumnLayout
            {
                anchors.fill: parent
                QtQuick.Text
                {
                    QtLayouts.Layout.fillWidth: true
                    text: qsTr("<b>What's new</b>")
                    font: GeneralFont
                }

                QtControls.ScrollView
                {
                    id: scrollView

                    QtLayouts.Layout.fillHeight: true
                    QtLayouts.Layout.fillWidth: true
                    clip: true
                    contentWidth: width
                    QtQuick.Text
                    {
                        font: GeneralFont
                        height: scrollView.availableHeight
                        text: qsTr(Models.Releases.currentReleaseNote) + DeviceAccess.managers.translation.emptyString
                        textFormat: QtQuick.Text.RichText
                        width: scrollView.availableWidth - scrollView.QtControls. ScrollBar.vertical.implicitWidth
                        wrapMode: QtQuick.Text.Wrap
                    }
                }
            }
        }
        QtControls.Label
        {
            QtLayouts.Layout.fillWidth: true
            font: GeneralFont
            fontSizeMode: QtControls.Label.Fit
            minimumPixelSize: 1
            text: qsTr("Please <b>press and hold</b> outside this popup to close it and open the pie menu.") +
                  DeviceAccess.managers.translation.emptyString
            textFormat: QtControls.Label.RichText
            wrapMode: QtControls.Label.WordWrap
        }
    }
}
