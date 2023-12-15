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

import "qrc:/qml/models" as Models

QtControls.Dialog
{
    id: menuUsagePopup

    anchors.centerIn: parent
    background.opacity: .95
    clip: true
    closePolicy: QtControls.Dialog.NoAutoClose
    implicitHeight: implicitHeaderHeight + implicitContentHeight + implicitFooterHeight + 2 * padding
    implicitWidth: Math.max(root.width/2, implicitContentWidth)
    modal: true
    title: qsTr("How to use it? [%1/%2]").arg(view.currentIndex+1).arg(view.count) +
           DeviceAccess.managers.translation.emptyString
    spacing: 0
    footer: QtLayouts.ColumnLayout
    {
        QtLayouts.Layout.fillWidth: true
        spacing: 0
        QtControls.CheckBox
        {
            id: hidePopupCheckbox

            QtLayouts.Layout.alignment: Qt.AlignLeft
            checked: !showMenuUsage
            indicator.opacity: 0.5
            padding: menuUsagePopup.padding
            text: "<i>%1</i>".arg(qsTr("Don't show this again")) + DeviceAccess.managers.translation.emptyString
        }
        QtControls.DialogButtonBox
        {
            QtLayouts.Layout.fillWidth: true
            QtLayouts.Layout.preferredWidth: menuUsagePopup.implicitWidth
            background: null
            QtControls.Button
            {
                QtLayouts.Layout.fillWidth: true
                text: qsTr("Previous") + DeviceAccess.managers.translation.emptyString
                enabled: view.isPreviousItem

                onClicked: view.decrementCurrentIndex()
            }
            QtControls.Button
            {
                QtLayouts.Layout.fillWidth: true
                text: qsTr("Next") + DeviceAccess.managers.translation.emptyString
                enabled: view.isNextItem

                onClicked: view.incrementCurrentIndex()
            }
            QtControls.Button
            {
                QtLayouts.Layout.fillWidth: true
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

        QtQuick.Repeater {
            model: Models.MenuUsage.instructions
            QtControls.Label
            {
                QtLayouts.Layout.fillHeight: true
                QtLayouts.Layout.fillWidth: true
                fontSizeMode: QtControls.Label.Fit
                minimumPixelSize: 1
                textFormat: QtControls.Label.RichText
                text: "<b>%1</b><ul>%2</ul>".arg(qsTranslate("MenuUsage", modelData.title))
                /**/.arg(Models.MenuUsage.contentAsListItem(index)) + DeviceAccess.managers.translation.emptyString
                wrapMode: QtControls.Label.WordWrap
            }
        }
    }
}
