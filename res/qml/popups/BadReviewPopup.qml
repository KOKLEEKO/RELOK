/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls

import DeviceAccess 1.0

QtControls.Dialog
{
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
