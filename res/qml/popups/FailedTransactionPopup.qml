/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15 as QtControls
import QtQuick 2.15 as QtQuick

import DeviceAccess 1.0

QtControls.Dialog
{
    anchors.centerIn: parent
    clip: true
    modal: true
    standardButtons: QtControls.Dialog.No | QtControls.Dialog.Yes
    title: qsTr("Oops...") + DeviceAccess.managers.translation.emptyString
    width: Math.max(root.width/2, header.implicitWidth)
    z: 1

    onAccepted: tips.failedProduct.purchase()
    onRejected: tips.store.purchasing = false
    QtQuick.Component.onCompleted: {
        standardButton(QtControls.Dialog.No).text = Qt.binding(() => qsTranslate("QPlatformTheme", "No") +
                                                               DeviceAccess.managers.translation.emptyString);
        standardButton(QtControls.Dialog.Yes).text = Qt.binding(() => qsTranslate("QPlatformTheme", "Yes") +
                                                                DeviceAccess.managers.translation.emptyString);
    }

    QtControls.Label
    {
        horizontalAlignment: QtControls.Label.Center
        width: parent.width
        wrapMode: QtControls.Label.WordWrap
        text: "%1.\n\n%2".arg(qsTr("Something went wrong...")).arg(qsTr("Do you want to try again?")) +
              DeviceAccess.managers.translation.emptyString
    }
}
