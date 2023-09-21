/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15 as QtControls

import DeviceAccess 1.0

QtControls.Dialog
{
    anchors.centerIn: parent
    clip: true
    modal: true
    title: qsTr("Thank you for being so supportive!") + DeviceAccess.managers.translation.emptyString
    width: header.implicitWidth

    QtControls.Label
    {
        horizontalAlignment: QtControls.Label.Center
        text: "❤\n\n%1".arg(qsTr("It means a lot to us.")) + DeviceAccess.managers.translation.emptyString
        width: parent.width
        wrapMode: QtControls.Label.WordWrap
    }
}
