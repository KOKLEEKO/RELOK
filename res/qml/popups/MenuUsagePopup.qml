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

QtControls.Dialog
{
    id: menuUsagePopup

    anchors.centerIn: parent
    background.opacity: .95
    clip: true
    closePolicy: QtControls.Dialog.NoAutoClose
    implicitWidth: Math.max(root.width/2, header.implicitWidth, footer.implicitWidth) + 2 * padding
    modal: true
    title: qsTr("How to use it? [%1/%2]").arg(view.currentIndex+1).arg(view.count) + DeviceAccess.managers.translation.emptyString
    spacing: 0
    footer: QtLayouts.ColumnLayout
    {
        spacing: 0
        QtControls.CheckBox
        {
            id: hidePopupCheckbox

            QtLayouts.Layout.alignment: Qt.AlignLeft
            indicator.opacity: 0.5
            padding: menuUsagePopup.padding
            text: qsTr("<i>Don't show this again</i>") + DeviceAccess.managers.translation.emptyString
        }
        QtControls.DialogButtonBox
        {
            QtLayouts.Layout.fillWidth: true
            background: null
            QtControls.Button
            {
                text: qsTr("Previous") + DeviceAccess.managers.translation.emptyString
                enabled: view.isPreviousItem
                onClicked: view.decrementCurrentIndex()
            }
            QtControls.Button
            {
                text: qsTr("Next") + DeviceAccess.managers.translation.emptyString
                enabled: view.isNextItem
                onClicked: view.incrementCurrentIndex()
            }
            QtControls.Button
            {
                text: qsTr("Close") + DeviceAccess.managers.translation.emptyString
                onClicked: close()
            }
        }
    }

    onClosed: showMenuUsage = !hidePopupCheckbox.checked

    QtQuick.Component.onCompleted: header.background.visible = false

    QtControls.SwipeView
    {
        id: view

        readonly property bool isNextItem: currentIndex !== (count - 1)
        readonly property bool isPreviousItem: currentIndex !== 0

        anchors { fill: parent; margins: 0 }  // @disable-check M16  @disable-check M31
        clip: true

        QtControls.Label
        {
            QtLayouts.Layout.fillHeight: true
            QtLayouts.Layout.fillWidth: true
            fontSizeMode: QtControls.Label.Fit
            minimumPixelSize: 1
            textFormat: QtControls.Label.RichText
            text: "\%1<br><br>%2".arg(qsTr("We hope you enjoy using it.")).arg(qsTr("Please <b>press and hold</b> outside this \
    popup to close it and open the pie menu.")) + DeviceAccess.managers.translation.emptyString
            wrapMode: QtControls.Label.WordWrap
        }
        QtControls.Label
        {
            QtLayouts.Layout.fillHeight: true
            QtLayouts.Layout.fillWidth: true
            fontSizeMode: QtControls.Label.Fit
            minimumPixelSize: 1
            textFormat: QtControls.Label.RichText
            text: "\%1<br><br>%2".arg(qsTr("We hope you enjoy using it.")).arg(qsTr("Please <b>press and hold</b> outside this \
    popup to close it and open the pie menu.")) + DeviceAccess.managers.translation.emptyString
            wrapMode: QtControls.Label.WordWrap
        }
        QtControls.Label
        {
            QtLayouts.Layout.fillHeight: true
            QtLayouts.Layout.fillWidth: true
            fontSizeMode: QtControls.Label.Fit
            minimumPixelSize: 1
            textFormat: QtControls.Label.RichText
            text: "\%1<br><br>%2".arg(qsTr("We hope you enjoy using it.")).arg(qsTr("Please <b>press and hold</b> outside this \
    popup to close it and open the pie menu.")) + DeviceAccess.managers.translation.emptyString
            wrapMode: QtControls.Label.WordWrap
        }
    }
}
