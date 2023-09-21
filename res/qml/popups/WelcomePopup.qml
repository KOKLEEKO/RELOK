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
    id: welcomePopup

    anchors.centerIn: parent
    background.opacity: .95
    clip: true
    closePolicy: QtControls.Dialog.CloseOnPressOutside
    implicitWidth: Math.max(root.width/2, header.implicitWidth) + 2 * padding
    title: qsTr("Welcome to %1 ( %2 )").arg(Qt.application.name).arg(Qt.application.version) + DeviceAccess.managers.translation.emptyString
    z: 1

    onClosed: root.showWelcome = !hidePopupCheckbox.checked
    QtQuick.Component.onCompleted: { header.background.visible = false; if (showWelcome) open() }

    QtLayouts.ColumnLayout
    {
        anchors { fill: parent; margins: welcomePopup.margins }  // @disable-check M16  @disable-check M31
        QtControls.Label
        {
            QtLayouts.Layout.fillHeight: true
            QtLayouts.Layout.fillWidth: true
            fontSizeMode: QtControls.Label.Fit
            minimumPixelSize: 1

            text: "\%1.\n\n%2.".arg(qsTr("We hope you enjoy using it.")).arg(qsTr("Please press and hold outside this \
popup to close it and open the settings menu.")) + DeviceAccess.managers.translation.emptyString
            wrapMode: QtControls.Label.WordWrap
        }
        QtControls.CheckBox
        {
            id: hidePopupCheckbox

            indicator.opacity: 0.5
            text: qsTr("Don't show this again") + DeviceAccess.managers.translation.emptyString
        }
    }
}
